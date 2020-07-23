# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_exec" {
  name        = "lambda_logging_and_s3"
  path        = "/"
  description = "IAM policy for logging from a lambda and s3 access"

  policy = file("${path.module}/policies/execution_role.json")
}

resource "aws_iam_role_policy_attachment" "lambda_exec" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_exec.arn
}



resource "aws_iam_role" "lambda_exec_role" {
  name = "iam_for_lambda"

  assume_role_policy = file("${path.module}/policies/assume_role.json")
}

resource "aws_lambda_function" "run_model" {
  function_name = var.lambda_name
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = var.lambda_handler

  filename      = var.lambda_source
  source_code_hash = filebase64sha256(var.lambda_source)

  runtime = "go1.x"

   depends_on = [
    aws_iam_role_policy_attachment.lambda_exec, 
    aws_cloudwatch_log_group.example
  ]

  environment {
    variables = var.lambda_env
  }
}


resource "aws_lambda_permission" "allow_input_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.run_model.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.input_bucket.arn
}


