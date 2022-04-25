# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
# example code of [data-source](https://www.terraform.io/language/data-sources)

data "aws_caller_identity" "current" {}

#########################
## VPC 
#########################

data "aws_vpc" "vpc_product" {
  tags = {
    Name = local.data.vpc.vpc_product
  }
}

###########################
## data Route53 Hosted Zone
###########################

data "aws_route53_zone" "route_local" {
  name         = join(".",[var.environment,var.project,var.global_dns])
  private_zone = true
}

#########################
## SG for instances
#########################

data "aws_security_group" "sg_instances" {
  
  name = join("-",[var.project,"sg","instances"])
  vpc_id = data.aws_vpc.vpc_product.id
}

data "aws_security_group" "sg_common_microservices" {

  name = join("-",[var.project,"sg","common","microservices"])
  vpc_id = data.aws_vpc.vpc_product.id

}
#########################
### SG for ALB Internal
#########################

data "aws_security_group" "sg_common_microservices_alb" {

  name = join("-",[var.project,"sg","common","microservices","alb"])

  vpc_id = data.aws_vpc.vpc_product.id

}

data "aws_iam_instance_profile" "ip" {
  name = join("-",[var.project,var.environment,"instanceprofile",var.service_name])
}



#########################
###### Amber Subnets data
#########################

data "aws_subnet_ids" "snet_amber_eu_central_1_subnets" {
  vpc_id = data.aws_vpc.vpc_product.id

  tags = {
    Name = local.data.vpc.amber.subnet
  }
}

data "aws_subnet" "snet_amber_eu_central_1a" {
  vpc_id = data.aws_vpc.vpc_product.id

  tags = {
    Name = local.data.vpc.amber.subneta
  }
}

data "aws_subnet" "snet_amber_eu_central_1b" {
  vpc_id = data.aws_vpc.vpc_product.id

  tags = {
    Name = local.data.vpc.amber.subnetb
  }
}

data "aws_subnet" "snet_amber_eu_central_1c" {
  vpc_id = data.aws_vpc.vpc_product.id

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

