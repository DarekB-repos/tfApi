variable "aws_region" {
  default = "eu-west-2"
}

# variable "ssm_param_name" {
#   type    = string
#   default = "/test/param/path"
# }

variable "lambdas3_bucket" {
  default = "dariusz-s3-lambda-deploy"
}


variable "lambdas3_key" {
  default = "lambda_function.zip"
}