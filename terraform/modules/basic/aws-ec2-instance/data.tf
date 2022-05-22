locals {
  data = {
    sg-common-microservices = ""
    vpc = {
      vpc_product = "${var.project}-${var.environment_prefix}"
    }
  }
}

#########################
## VPC 
#########################

data "aws_vpc" "vpc_product" {
  tags = {
      Name = local.data.vpc.vpc_product
  }
}

#########################
## subnets ids
#########################

## Public
data "aws_subnets" "snet_public__subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc_product.id]
  }
  
  tags = {
    Type = "public"
  }
}

## Private
data "aws_subnets" "snet_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc_product.id]
  }
  
  tags = {
    Type = "private"
  }
}


#########################
## Security & profile
#########################

## IAM
data "aws_iam_role" "role" {
   name = join("-", [var.project, var.environment, "role"])
}

data "aws_iam_instance_profile" "iam_instance_profile" {
  name = join("-",[var.project,var.environment,"instanceprofile",var.service_name])
}

## Security group
data "aws_security_group" "db_server_sg"{
   name = join("-",[var.project, var.environment_prefix, "db", "server", "sg"])
}

data "aws_security_group" "web_server_sg"{
  name = join("-",[var.project, var.environment_prefix, "web", "server", "sg"])
}

