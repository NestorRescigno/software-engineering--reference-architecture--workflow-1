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
  count = var.state != null ? 1 : 0 
  tags = {
      Name = local.data.vpc.vpc_product
  }
  state = ["pending", "available"][count.index]
}

#########################
## instance profile ip 
#########################
data "aws_iam_instance_profile" "ip" {
  name = join("-",[var.project,var.environment,"instanceprofile",var.service_name])
}

###########################
## data Route53 Hosted Zone
###########################

data "aws_route53_zone" "route_local" {
  count = var.state != null ? 1 : 0 
  name         = join(".",[var.environment,var.project,var.global_dns])
  private_zone = true
}

#########################
## SG for instances
#########################

data "aws_security_group" "sg_instances" {
  count = var.state != null ? 1 : 0 
  name = join("-",[var.project,"sg","instances"])
  vpc_id = data.aws_vpc.vpc_product.id[count.index]
}

data "aws_security_group" "sg_common_microservices" {
  count = var.state != null ? 1 : 0 
  name = join("-",[var.project,"sg","common","microservices"])
  vpc_id = data.aws_vpc.vpc_product.id[count.index]

}

#########################
### SG for ALB Internal
#########################

data "aws_security_group" "sg_common_microservices_alb" {
  count = var.state != null ? 1 : 0 
  name = join("-",[var.project,"sg","common","microservices","alb"])
  vpc_id = data.aws_vpc.vpc_product.id[count.index]


}

#########################
###### Amber Subnets data
#########################

data "aws_subnet_ids" "snet_amber_eu_central_1_subnets" {
  count = var.state != null ? 1 : 0 
  vpc_id = data.aws_vpc.vpc_product.id[count.index]

  tags = {
    Name = local.data.vpc.amber.subnet
  }
}

data "aws_subnet" "snet_amber_eu_central_1a" {
  count = var.state != null ? 1 : 0 
  vpc_id = data.aws_vpc.vpc_product.id[count.index]

  tags = {
    Name = local.data.vpc.amber.subneta
  }
}

data "aws_subnet" "snet_amber_eu_central_1b" {
  count = var.state != null ? 1 : 0 
  vpc_id = data.aws_vpc.vpc_product.id[count.index]

  tags = {
    Name = local.data.vpc.amber.subnetb
  }
}

data "aws_subnet" "snet_amber_eu_central_1c" {
  count = var.state != null ? 1 : 0
  vpc_id = data.aws_vpc.vpc_product.id[count.index]
  tags = {
    Name = local.data.vpc.amber.subnetc
  }
}

