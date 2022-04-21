# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
# example code of [data-source](https://www.terraform.io/language/data-sources)

data "aws_caller_identity" "current" {}


data "aws_iam_instance_profile" "ip" {
  name = join("-",[var.project,var.environment,"instanceprofile",var.service_name])
}


