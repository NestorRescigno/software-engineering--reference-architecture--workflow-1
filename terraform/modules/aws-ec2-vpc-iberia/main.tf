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

  enable_dns_support = true
  enable_dns_hostnames = true
  
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

  # map ips public 
  map_public_ip_on_launch = true

  # set IP 
  cidr_block        = cidrsubnet(aws_vpc.vpc_product.cidr_block, 4, var.az_number[each.value.name_suffix])
  # set tag
  tags = {
     Name = join("-",[var.project,"snet","amber", data.aws_region.current.name, each.value.name_suffix])
  }
}

####################################################################################
#create Internet Gateway
#será necesario configurar la variable public_mask distinto de 0 para que se genere
####################################################################################

resource "aws_internet_gateway" "igw_dc" {
  count  = length(aws_subnet.subnets) != 0 ? 1 : 0
  vpc_id = aws_vpc.vpc_product.id
  #tags      = merge(var.common_tags, map("Name", "igw-${var.vpc_name}"))
  tags = merge(var.common_tags, tomap({ "Name" = "igw-${aws_vpc.vpc_product.id}" }))
}


####################################################################################
#Creación de NAT Gateway 
#será necesario configurar la variable enable_nat_gateway a true
####################################################################################

resource "aws_eip" "nat_eip" {
  for_each = data.aws_availability_zone.all
  vpc   = true
  #tags          = merge(var.common_tags, map("Name", "eip-${var.vpc_name}-${element(var.azs, count.index)}"))
  tags = merge(var.common_tags, tomap({ "Name" = "eip-${aws_vpc.vpc_product.id}-${each.value}" }))
}

resource "aws_nat_gateway" "nat_gateway" {
  for_each = data.aws_availability_zone.all
  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id = aws_subnet.subnetsp[each.key].id
  #allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  #subnet_id     = element(aws_subnet.subnet.*.id, count.index)
  #tags          = merge(var.common_tags, map("Name", "natgw-${var.vpc_name}-${element(var.azs, count.index)}"))
  tags = merge(var.common_tags, tomap({ "Name" = "natgw-${aws_vpc.vpc_product.id}-${each.value}" }))

  depends_on = [aws_internet_gateway.igw_dc]
}


####################################################################################
# route net public
####################################################################################
resource "aws_route_table" "rt_igw_dc" {
  count  = length(aws_subnet.subnets) != 0 ? 1 : 0
  vpc_id = aws_vpc.vpc_product.id
  #tags   = merge(var.common_tags, map("Name", "rt-${var.vpc_name}-public"))
  tags = merge(var.common_tags, tomap({ "Name" = "rt-${aws_vpc.vpc_product.id}-public" }))
}

# all traffic NO-LOCAL subnet public route to IGW-Gateway
resource "aws_route" "rt_igw_dc" {
  count                  = length(aws_subnet.subnets) != 0 ? 1 : 0
  route_table_id         = aws_route_table.rt_igw_dc[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_dc[0].id
  depends_on             = [aws_internet_gateway.igw_dc]
}

# asigned route public to Internet Gateway subnet public
resource "aws_route_table_association" "rt_igw_dc_asoc" {
  #vpc_id = "${aws_vpc.vpc.id}"
  count          = length(aws_subnet.subnets) != 0 ? length(data.aws_availability_zone.all) : 0
  route_table_id = aws_route_table.rt_igw_dc[0].id
  subnet_id      = aws_subnet.subnets[count.index].id
  depends_on     = [aws_route_table.rt_igw_dc]
}
