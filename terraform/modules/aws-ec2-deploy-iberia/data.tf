# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
# example code of [data-source](https://www.terraform.io/language/data-sources)

data "aws_caller_identity" "current" {}


data "aws_iam_instance_profile" "ip" {
  name = join("-",[var.project,var.environment,"instanceprofile",var.service_name])
}

##################
# global policies
##################

data "aws_iam_policy" "cloudwatch_agent" {
  name        = join("-",[var.environment_prefix,"policy","cloudwatch","agent"])
}

data "aws_iam_policy" "ssm" {
  name   = join("-", [var.environment_prefix,"policy","ssm"])            
}

data "aws_iam_policy" "common-microservices" {
  name   = join("-",[var.environment_prefix,"policy","common","microservices"])
}


