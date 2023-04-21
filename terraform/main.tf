provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "dariusz-s3-tf-state-files"
    key    = "vpc_plus_lambda.tf"
    region = "eu-west-2"

  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}