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
  cidr_block            = cidrsubnet("10.0.0.0/16", 4, var.region_number[data.aws_region.current.name])

  # A tenancy option for instances launched into the VPC. 
  # Default is default, which ensures that EC2 instances launched
  # in this VPC use the EC2 instance tenancy attribute specified 
  # when the EC2 instance is launched. The only other option is dedicated, 
  # which ensures that EC2 instances launched in this VPC are run on dedicated 
  # tenancy instances regardless of the tenancy attribute specified at launch. 
  # This has a dedicated per region fee of $2 per hour, plus an hourly per instance usage fee.
  instance_tenancy      = "default"
  # A map of tags to assign to the resource. If configured with a provider

  enable_dns_support    = true
  enable_dns_hostnames  = true
  
  tags = {
    Name = local.data.vpc.vpc_product
  }
  
}


###################################################################################
# submodule crete subnet
###################################################################################

module "subnets" {
  source = "./submodule"
  project = var.product
  aws_vpc_id = aws_vpc.vpc_product.id
  cidr_block = aws_vpc.vpc_product.cidr_block
  hasPublicIpOnLaunch = true
}


module "subnets_private" {
  source = "./submodule"
  count = var.hasPrivateSubnet ? 1 : 0
  project = var.product
  aws_vpc_id = aws_vpc.vpc_product.id
  cidr_block = aws_vpc.vpc_product.cidr_block
}


####################################################################################
# create DHCP Options Set
####################################################################################
resource "aws_vpc_dhcp_options" "dhcp_options" {

  domain_name          = local.dhcp_options_domain_name
  domain_name_servers  = var.dhcp_options_domain_name_servers
  ntp_servers          = var.dhcp_options_ntp_servers
  netbios_name_servers = var.dhcp_options_netbios_name_servers
  netbios_node_type    = var.dhcp_options_netbios_node_type
  #tags                  = merge(var.common_tags, map("Name", "dhcp-ops-${lookup(var.common_tags, "Project")}-${var.vpc_name}"))
  tags = merge(var.common_tags, tomap({ "Name" = "dhcp-ops-Project-${local.data.vpc.vpc_product}" }))

}

resource "aws_vpc_dhcp_options_association" "dhcp_options_association" {
  vpc_id          = aws_vpc.vpc_product.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_options.id
}
