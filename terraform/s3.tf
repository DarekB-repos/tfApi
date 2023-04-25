resource "aws_s3_bucket" "assignmentBucket" {
  bucket = "tf-assignment-bucket"

  tags = {
    Name        = "Assignment bucket"
    Environment = "Dev"
  }
}