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
    sid = "GetSSParam"

    actions = [
      "ssm:GetParameter"
    ]

    resources = [
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter${aws_ssm_parameter.rSsmParameter.name}"
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

