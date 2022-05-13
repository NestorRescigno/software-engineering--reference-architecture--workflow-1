# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************


###########################
### Provider
###########################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.13"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  alias = "aws"
  region = var.aws_region
}



############################
### New instance profile 
############################

# create resource AIM 
resource "aws_iam_role" "role" {
  # assigned name best-practice-development-role
  name = join("-", [var.project, var.environment, "role"])
  path = "/"
  
  # add new policy
  #managed_policy_arns = [data.aws_iam_policy.SSMManagedInstanceCore.arn, data.aws_iam_policy.SSMServiceRolePolicy.arn]

  
  # asssigne standars policy
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
  # assume_role_policy = <<EOF
  # {
  #     "Version": "2012-10-17",
  #     "Statement": [
  #         {
  #             "Action": "sts:AssumeRole",
  #             "Principal": {
  #               "Service": "ec2.amazonaws.com"
  #             },
  #             "Effect": "Allow",
  #             "Sid": ""
  #         }
  #     ]
  # }
  # EOF
  tags = local.global_common_tags

}
# ##############################
# ## IAM Instance profile Role
# ##############################

# create instance profile
resource "aws_iam_instance_profile" "iam_instance_profile" {

   name = join("-",[var.project, var.environment, "instanceprofile", var.service_name])
   role = aws_iam_role.role.name
 
}




##########################################################
# Attach the policy cloudwatch_agent to the role
# resource "aws_iam_instance_profile" "service" {
#   name = "${var.service_name}-instanceprofile-${var.environment_prefix}"
#   role = aws_iam_role.service.name
# }

# resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
#   role       = aws_iam_role.service.name
#   policy_arn = data.aws_iam_policy.cloudwatch_agent.arn
# }

# Attach the policy ssm to the role
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.role.name
  policy_arn = data.aws_iam_policy.ssm.arn
}

resource "aws_iam_role_policy_attachment" "SSMManagedInstanceCore" {
  role       = aws_iam_role.role.name
  policy_arn = data.aws_iam_policy.SSMManagedInstanceCore.arn
}

# # Attach the policy common-microservices to the role
# resource "aws_iam_role_policy_attachment" "common-microservices" {
#   role       = aws_iam_role.service.name
#   policy_arn = data.aws_iam_policy.common-microservices.arn
# }


