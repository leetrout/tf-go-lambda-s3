resource "aws_s3_bucket" "input_bucket" {
  bucket = var.input_bucket_name
}

resource "aws_s3_bucket" "output_bucket" {
  bucket = var.output_bucket_name
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.input_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.run_model.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_permission.allow_input_bucket,
  ]
}
