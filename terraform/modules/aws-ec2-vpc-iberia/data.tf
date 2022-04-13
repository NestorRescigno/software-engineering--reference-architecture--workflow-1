# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
# example code of [data-source](https://www.terraform.io/language/data-sources)

data "aws_caller_identity" "current" {}

###########################
## data Route53 Hosted Zone
###########################

data "aws_route53_zone" "ancillaries_cloud_iberia_local" {
  name         = "${var.environment}.${var.project}.${var.global_dns}"
  private_zone = true
}

#########################
## SG for instances
#########################

data "aws_security_group" "sg-instances" {
  name   = "${var.project}-sg-instances"
  vpc_id = data.aws_vpc.vpc_product.id
}

data "aws_security_group" "sg-common-microservices" {

  name = "${var.project}-sg-common-microservices"

  vpc_id = data.aws_vpc.vpc_product.id

}
#########################
### SG for ALB Internal
#########################

data "aws_security_group" "sg-common-microservices-alb" {

  name = "${var.project}-sg-common-microservices-alb"

  vpc_id = data.aws_vpc.vpc_product.id

}

data "aws_iam_instance_profile" "ip" {
  name = "${var.project}-${var.environment}-instanceprofile-${var.service_name}"
}

#########################
## VPC ancilliaries
#########################

data "aws_vpc" "vpc_product" {
  tags = {
    Name = local.data.vpc.vpc_product
  }
}

#########################
###### Amber Subnets data
#########################

data "aws_subnet_ids" "snet-amber-eu-central-1_subnets" {
  vpc_id = data.aws_vpc.vpc_product.id

  tags = {
    Name = local.data.vpc.amber.subnet
  }
}

data "aws_subnet" "snet-amber-eu-central-1a" {
  vpc_id = data.aws_vpc.vpc_product.id

  tags = {
    Name = local.data.vpc.amber.subneta
  }
}

data "aws_subnet" "snet-amber-eu-central-1b" {
  vpc_id = data.aws_vpc.vpc_product.id

  tags = {
    Name = local.data.vpc.amber.subnetb
  }
}

data "aws_subnet" "snet-amber-eu-central-1c" {
  vpc_id = data.aws_vpc.vpc_product.id

  tags = {
    Name = local.data.vpc.amber.subnetc
  }
}
