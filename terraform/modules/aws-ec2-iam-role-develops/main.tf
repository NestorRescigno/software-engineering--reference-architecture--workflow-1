# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

# ##############################
# ## IAM Role
# ##############################

resource "aws_iam_role" "service" {
  name        = "${var.service_name}-${var.environment_prefix}-role"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
      "Action": "sts:AssumeRole",
      "Principal": {
          "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
      }
  ]
}
  
# ##############################
# ## IAM Instance profile Role
# ##############################
resource "aws_iam_instance_profile" "service" {
  name = "${var.service_name}-instanceprofile-${var.environment_prefix}"
  role = aws_iam_role.service.name
}
  
##########################################################
# Attach the policy cloudwatch_agent to the role
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.service.name
  policy_arn = data.aws_iam_policy.cloudwatch_agent.arn
}
# Attach the policy ssm to the role
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.service.name
  policy_arn = data.aws_iam_policy.ssm.arn
}
# Attach the policy common-microservices to the role
resource "aws_iam_role_policy_attachment" "common-microservices" {
  role       = aws_iam_role.service.name
  policy_arn = data.aws_iam_policy.common-microservices.arn
}
EOF

  tags = local.global_common_tags
}
