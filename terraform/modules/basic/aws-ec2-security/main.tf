
data "aws_caller_identity" "current" {}


data "aws_vpc" "vpc_product" {
  tags = {
      Name = "${var.project}-${var.environment_prefix}"
  }
}

########################
# create security group 
########################

module "sucuritygroup" {
  source = "./securitygroup"
  hasPrivateSubnet = var.hasPrivateSubnet
  project = var.product
  environment_prefix = var.environment_prefix
  vpc_id = data.aws_vpc.vpc_product.id
}

########################
# create role iam
########################

module "iamrole" {
  source = "./iamrole"
  project = var.product
  service_name = var.service_name
  environment = var.environment
  environment_prefix = var.environment_prefix
}
