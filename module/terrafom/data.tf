# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
# example code of [data-source](https://www.terraform.io/language/data-sources)

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

###########################
## data Route53 Hosted Zone
###########################

data "aws_route53_zone" "route-zone" {
  name         = "${var.environment}.${var.route-zone}"
  private_zone = true
}

#########################
## SG for instances
#########################

data "aws_security_group" "sg-svc-instances" {
  name   = "${var.project}-sg-anc-svc-instances"
  vpc_id = data.aws_vpc.vpc-product.id
}

data "aws_security_group" "sg-common-microservices" {

  name = "${var.project}-sg-common-microservices"

  vpc_id = data.aws_vpc.vpc-product.id

}
#########################
### SG for ALB Internal
#########################

data "aws_security_group" "sg-common-microservices-alb" {

  name = "${var.project}-sg-common-microservices-alb"

  vpc_id = data.aws_vpc.vpc-product.id

}

data "aws_iam_instance_profile" "ip" {
  name = "${var.project}-${var.environment}-instanceprofile-${var.service_name}"
}

#########################
## VPC
#########################

data "aws_vpc" "vpc-product" {
  tags = {
    Name = local.data.vpc.vpc-product
  }
}

#########################
###### Subnets data
#########################

data "aws_subnet_ids" "snet-internal-eu-central-1_subnets" {
  vpc_id = data.aws_vpc.vpc-product.id

  tags = {
    Name = local.data.vpc.internal.subnet
  }
}

data "aws_subnet" "snet-internal-eu-central-1a" {
    vpc_id = data.aws_vpc.vpc-product.id
 
   tags = {
    Name = local.data.vpc.internal.subneta
   }
}

# data "aws_subnet" "snet-amber-eu-central-1b" {
#   vpc_id = data.aws_vpc.vpc-ancill.id
# 
#   tags = {
#     Name = local.data.vpc.amber.subnetb
#   }
# }

# data "aws_subnet" "snet-amber-eu-central-1c" {
#   vpc_id = data.aws_vpc.vpc-ancill.id
# 
#   tags = {
#     Name = local.data.vpc.amber.subnetc
#   }
# }

##################
# global policies
##################

data "aws_iam_policy" "cloudwatch_agent" {
  name        = "${var.environment_prefix}-policy-cloudwatch-agent"
}


data "aws_iam_policy" "ssm" {
  name   = "${var.environment_prefix}-policy-ssm"            
}

data "aws_iam_policy" "common-microservices" {
  name   = "${var.environment_prefix}-policy-common-microservices"
}
