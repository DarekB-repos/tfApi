resource "aws_s3_bucket" "assignmentBucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = "Assignment bucket"
    Environment = "Dev"
  }
}