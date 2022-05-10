# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************


###########################
### Provider
###########################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  alias = "aws"
  region = var.aws_region
}


###########################
### New Resource vpc
###########################

# create vitual private cloud network for product
resource "aws_vpc" "vpc_product" {
    # The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using
  cidr_block       = "10.0.0.0/16"
  # A tenancy option for instances launched into the VPC. 
  # Default is default, which ensures that EC2 instances launched
  # in this VPC use the EC2 instance tenancy attribute specified 
  # when the EC2 instance is launched. The only other option is dedicated, 
  # which ensures that EC2 instances launched in this VPC are run on dedicated 
  # tenancy instances regardless of the tenancy attribute specified at launch. 
  # This has a dedicated per region fee of $2 per hour, plus an hourly per instance usage fee.
  instance_tenancy = "default"
  # A map of tags to assign to the resource. If configured with a provider
  tags = {
    Name = local.data.vpc.vpc_product
  }
  
}

# create subnet in vpc
resource "aws_subnet" "subneta" {
  
  # The VPC ID. 
  vpc_id =  aws_vpc.vpc_product.id
  # The IPv4 CIDR block for the subnet.
  cidr_block = "10.0.1.0/24"
  # A map of tags to assign to the resource. If configured with a provider
  tags = {
    Name = local.data.vpc.amber.subneta
  }
}

# create subnet in vpc
resource "aws_subnet" "subnetb" {
  # The VPC ID. 
  
  vpc_id = aws_vpc.vpc_product.id
  # The IPv4 CIDR block for the subnet.
  cidr_block = "10.0.2.0/24"
  # A map of tags to assign to the resource. If configured with a provider
  tags = {
    Name = local.data.vpc.amber.subnetb
  }

}

# create subnet in vpc
resource "aws_subnet" "subnetc" {
  # The VPC ID. 
  
  vpc_id = aws_vpc.vpc_product.id
  # The IPv4 CIDR block for the subnet.
  cidr_block = "10.0.3.0/24"
  # A map of tags to assign to the resource. If configured with a provider
  tags = {
    Name = local.data.vpc.amber.subnetc
  }
}


#####################################
### New resources ALB SG 
######################################

# Provides a security group resource for cluster ALB

resource "aws_security_group" "alb" {

  # asign name: demo-alb-dev-sg
  name        = join("-",[var.service_name,"alb",var.environment_prefix,"sg"])
  description = "SG for ${var.service_name} cluster ALB"
  
  # asign vpc id to apply security group 

  vpc_id      = aws_vpc.vpc_product.id

  # Configuration block for ingress rules. 
  # Can be specified multiple times for each ingress rule. 
  # Each ingress block supports fields documented below. 
  # This argument is processed in attribute-as-blocks mode.
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    # security_groups = [ aws_security_group.instances.id ]
    # data.aws_vpc.vpc_product
    
  }

  # asign tag use marge takes an arbitrary number of maps or objects, 
  # and returns a single map or object that contains 
  # a merged set of elements from all arguments.
  # tag:{
  #    Project = "bestpractice"
  #    Name = "demo-alb-dev-sg"
  #    Environment = "developer"
  #    Cluster = "demo"
  #    Side = "demo"
  #    "tf:Used"                = "True"
  #    "Application:ArtifactId" = "demo-core"      
  # }
  tags = merge(
    local.global_common_tags,
    # converts to map { Name = demo-alb-dev-sg}
    tomap({
      Name = join("-",[var.service_name,"alb",var.environment_prefix,"sg"])
    })
  )
}

resource "aws_security_group" "instances" {

  depends_on = [
    aws_security_group.alb
  ]

  # asign name: demo-instances-dev-sg
  name        = join("-",[var.service_name, "instances",var.environment_prefix,"sg"])
  description = "SG for ${var.service_name} cluster instances"
  vpc_id      = aws_vpc.vpc_product.id
  

  ingress {
    from_port       = 8080
    to_port         = 8080     
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description = "From ${var.service_name} ALB"
  }

  tags = merge(
    local.global_common_tags,
    tomap({
      Name = join("-",[var.service_name,"instances",var.environment_prefix,"sg"])
    })
  )
}


############################
### New instance profile 
############################

resource "aws_iam_role" "role" {
  name = join("-", [var.project, var.environment, "role"])
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}




