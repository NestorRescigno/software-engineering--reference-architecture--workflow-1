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
  # asssigne standars policy
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
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
