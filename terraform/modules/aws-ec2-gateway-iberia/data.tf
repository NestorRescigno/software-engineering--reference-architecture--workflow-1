data "aws_region" "current" {}

#########################
## VPC 
#########################

data "aws_vpc" "vpc_product" {
  tags = {
      Name = "${var.project}-${var.environment_prefix}"
  }
}

# Determine all of the available availability zones in the
# current AWS region.
data "aws_availability_zones" "available" {

  state = "available"
}

# This additional data source determines some additional
# details about each VPC, including its suffix letter.
data "aws_availability_zone" "all" {
  for_each = toset(data.aws_availability_zones.available.names) 
  name = each.key
  # test
}

#########################
###### Amber Subnets data
#########################

data "aws_subnets" "snet_amber_eu_central_1_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc_product.id]
  }
  
  tags = {
    Name = local.data.vpc.amber.subnet
  }
}

data "aws_subnet" "snet_amber_eu_central_1a" {
  vpc_id = data.aws_vpc.vpc_product.id
 
  tags = {
    Name =local.data.vpc.amber.subneta
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
