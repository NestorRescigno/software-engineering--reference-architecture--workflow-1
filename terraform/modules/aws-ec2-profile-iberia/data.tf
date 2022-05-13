##########################################
# amazon ssm policy
##########################################
data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# add new policy amazon
data "aws_iam_policy" "SSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# data "aws_iam_policy" "SSMServiceRolePolicy" {
#     arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonSSMServiceRolePolicy"
# }


##################
# global policies
##################

# data "aws_iam_policy" "cloudwatch_agent" {
#   name        = "${var.environment_prefix}-policy-cloudwatch-agent"
# }

data "aws_iam_policy" "ssm" {
  name   = "ssm-global-policy"            
}

# data "aws_iam_policy" "common-microservices" {
#   name   = "${var.environment_prefix}-policy-common-microservices"
# }