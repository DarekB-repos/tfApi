variable "aws_region" {
  default = "us-east-1"
}

# variable "ssm_param_name" {
#   type    = string
#   default = "/test/param/path"
# }

variable "lambdas3_bucket" {
  default = "terraform-state-ram"
}


variable "lambdas3_key" {
  default = "lambda_function.zip"
}