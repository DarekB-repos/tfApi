provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "terraform-state-ram"
    key    = "vpc_plus_lambda.tf"
    region = "us-east-1"

  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
