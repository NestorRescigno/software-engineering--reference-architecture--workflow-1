#########################
## VPC 
#########################

data "aws_vpc" "vpc_product" {
  tags = {
      Name = "${var.project}-${var.environment_prefix}"
  }
}

data "aws_iam_role" "role" {
   name = join("-", [var.project, var.environment, "role"])
}