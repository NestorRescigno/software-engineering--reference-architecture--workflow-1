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


# Attach the policy ssm to the role
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.role.name
  policy_arn = data.aws_iam_policy.ssm.arn
}

resource "aws_iam_role_policy_attachment" "SSMManagedInstanceCore" {
  role       = aws_iam_role.role.name
  policy_arn = data.aws_iam_policy.SSMManagedInstanceCore.arn
}


##############################################
# IAM ROLE
##############################################

resource "aws_iam_role" "flow_log_role" {
  name               = "flow-${local.data.vpc.vpc_product}-log-role"
  assume_role_policy = data.aws_iam_policy_document.flow_log_assume_role_policy.json
}

resource "aws_iam_role_policy" "flow_log_policy" {
  name   = "flow-${local.data.vpc.vpc_product}-log-policy"
  role   = aws_iam_role.flow_log_role.id
  policy = data.aws_iam_policy_document.flow_log_policy.json
}

##############################################
# S3 logs test 
##############################################
resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  name              = "/aws/flowlogs/${local.data.vpc.vpc_product}"
  retention_in_days = 90
  tags = merge(var.common_tags, tomap({ "Name" = "fl-${local.data.vpc.vpc_product}" }))
}


resource "aws_flow_log" "vpc_flow_log" {
  log_destination = aws_cloudwatch_log_group.vpc_flow_log.arn
  iam_role_arn    = aws_iam_role.flow_log_role.arn
  vpc_id          = data.aws_vpc.vpc_product.id
  traffic_type    = "ALL"
}
