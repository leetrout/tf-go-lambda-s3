variable "input_bucket_name" {
    type = string
}

variable "output_bucket_name" {
    type = string
}

variable "lambda_handler" {
    type = string
}

variable "lambda_name" {
    type = string
}

variable "lambda_source" {
    type = string
}

variable "lambda_env" {
  type = map
}
