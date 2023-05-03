resource "aws_iam_role" "rLambdaRole" {
  assume_role_policy    = data.aws_iam_policy_document.dLambdaAssumeRole.json
  force_detach_policies = true
}

data "aws_iam_policy_document" "dLambdaAssumeRole" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


resource "aws_iam_role_policy_attachment" "rLambdaBasicRoleExecution" {
  role       = aws_iam_role.rLambdaRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "rLambdaS3ReadOnly" {
  role       = aws_iam_role.rLambdaRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

data "aws_iam_policy_document" "dApiGWAssumeRole" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "rApiGWRole" {
  assume_role_policy    = data.aws_iam_policy_document.dApiGWAssumeRole.json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "dApiGWAssumeRoleForLambda" {
  role       = aws_iam_role.rApiGWRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}

data "aws_iam_policy_document" "dSSMAcess" {
  statement {
    sid = "ReadS3"

    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.assignmentBucket.arn,
      "${aws_s3_bucket.assignmentBucket.arn}/*"
    ]
  }

}

resource "aws_iam_policy" "rSsmAccessPolicy" {
  policy      = data.aws_iam_policy_document.dSSMAcess.json
  description = "Access to ssm paraameter for lambda"
}

resource "aws_iam_role_policy_attachment" "rLambdaSmmAccess" {
  role       = aws_iam_role.rLambdaRole.name
  policy_arn = aws_iam_policy.rSsmAccessPolicy.arn
}

