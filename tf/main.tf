provider aws {
  region = "us-west-2"
}

module "my-lambda-module" {
  source  = "./modules/mylambda"
  # version = "0.0.1" can version pin once published

  input_bucket_name = "lee-test-input-bucket"
  output_bucket_name = "lee-test-output-bucket"
  lambda_handler = "myfunc" # Hardcoded in build script
  lambda_name = "lee-tf-test"
  lambda_env = {
    "FOO": "bar"
  }
  lambda_source      = "../build/myfunc.zip"
}
