data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

###########################
## data Route53 Hosted Zone
###########################

data "aws_route53_zone" "ancillaries_cloud_iberia_local" {
  name         = "${var.environment}.ancillaries.cloud.iberia.local"
  private_zone = true
}

#########################
## SG for instances
#########################

data "aws_security_group" "sg-svc-instances" {
  name   = "ancill-*-sg-anc-svc-instances"
  vpc_id = data.aws_vpc.vpc-ancill.id
}

data "aws_security_group" "sg-common-microservices" {

  name = "ancill-*-sg-common-microservices"

  vpc_id = data.aws_vpc.vpc-ancill.id

}
#########################
### SG for ALB Internal
#########################

data "aws_security_group" "sg-common-microservices-alb" {

  name = "ancill-*-sg-common-microservices-alb"

  vpc_id = data.aws_vpc.vpc-ancill.id

}

data "aws_iam_instance_profile" "ip-ancill" {
  name = "ancill-${var.environment}-instanceprofile-${var.service_name}"
}

#########################
## VPC ancilliaries
#########################

data "aws_vpc" "vpc-ancill" {
  tags = {
    Name = local.data.vpc.vpc-ancill
  }
}

#########################
###### Amber Subnets data
#########################

data "aws_subnet_ids" "snet-amber-eu-central-1_subnets" {
  vpc_id = data.aws_vpc.vpc-ancill.id

  tags = {
    Name = local.data.vpc.amber.subnet
  }
}

data "aws_subnet" "snet-amber-eu-central-1a" {
  vpc_id = data.aws_vpc.vpc-ancill.id

  tags = {
    Name = local.data.vpc.amber.subneta
  }
}

data "aws_subnet" "snet-amber-eu-central-1b" {
  vpc_id = data.aws_vpc.vpc-ancill.id

  tags = {
    Name = local.data.vpc.amber.subnetb
  }
}

data "aws_subnet" "snet-amber-eu-central-1c" {
  vpc_id = data.aws_vpc.vpc-ancill.id

  tags = {
    Name = local.data.vpc.amber.subnetc
  }
}

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
