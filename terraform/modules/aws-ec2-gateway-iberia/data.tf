data "aws_region" "current" {}

#########################
## VPC 
#########################

data "aws_vpc" "vpc_product" {
  tags = {
      Name = "${var.project}-${var.environment_prefix}"
  }
}

data "aws_iam_role" "role" {
   name = join("-", [var.project, var.environment, "role"])
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

##############################
# data endpoint to route table.
##############################

data "aws_vpc_endpoint" "s3" {
   vpc_id = data.aws_vpc.vpc_product.id
}

# resource "aws_vpc_endpoint_route_table_association" "public_s3" {
#   count = var.enable_s3_endpoint && (var.public_mask != 0 || length(var.public_subnets) != 0) && length(var.azs) > 0 ? 1 : 0

#   vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
#   route_table_id  = aws_route_table.rt_igw_dc[0].id
# }
