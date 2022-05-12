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
      version = "~> 3.29" # chnage version because the data zone isn't available after version.
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
  # cidr_block       = "10.0.0.0/16"
  cidr_block = cidrsubnet("10.1.0.0/16", 4, var.region_number[data.aws_region.current.name])

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

############################
### create subnet in vpc 
### with aws availability zone
############################

# resource subnet
resource "aws_subnet" "subnets" {
  # interate array
  for_each = data.aws_availability_zone.all
  # select vpc id
  vpc_id            = aws_vpc.vpc_product.id
  # get key of item array
  availability_zone = each.key
  # set IP 
  cidr_block        = cidrsubnet(aws_vpc.vpc_product.cidr_block, 4, var.az_number[each.value.name_suffix])
  # set tag
  tags = {
     Name = join("-",[var.project,"snet","amber", data.aws_region.current.name, each.value.name_suffix])
  }
}





