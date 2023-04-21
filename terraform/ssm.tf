resource "aws_ssm_parameter" "rSsmParameter" {
  name ="/my-tf-ssm/param"
  type = "String"
  value="I am coming from SSM"
}