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
      version = "~> 4.15" # chnage version because the data zone isn't available after version.
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  alias = "aws"
  region = var.aws_region
}


####################################################################################
# Create Internet Gateway
####################################################################################

resource "aws_internet_gateway" "igw_dc" {
  #count  = length(local.data.subaws_subnet.subnets) != 0 ? 1 : 0
  vpc_id = data.aws_vpc.vpc_product.id
  #tags      = merge(var.common_tags, map("Name", "igw-${var.vpc_name}"))
  tags = merge(var.common_tags, tomap({ "Name" = "igw-${local.data.vpc.vpc_product}" }))
}


####################################################################################
# Creación de NAT Gateway 
####################################################################################

# resource "aws_eip" "nat_eip" {
#   for_each = data.aws_availability_zone.all
#   vpc   = true
#   #tags          = merge(var.common_tags, map("Name", "eip-${var.vpc_name}-${element(var.azs, count.index)}"))
#   tags = merge(var.common_tags, tomap({ "Name" = "eip-${local.data.vpc.vpc_product}-${ each.value.name_suffix}" }))
# }

# resource "aws_nat_gateway" "nat_gateway_private" {
#   for_each = data.aws_availability_zone.all
#   #allocation_id = aws_eip.nat_eip[each.key].id
#   subnet_id = data.aws_subnets.snet_amber_eu_central_1_subnets[each.key].id
#   connectivity_type = "private"
#   #allocation_id = element(aws_eip.nat_eip.*.id, count.index)
#   #subnet_id     = element(aws_subnet.subnet.*.id, count.index)
#   #tags          = merge(var.common_tags, map("Name", "natgw-${var.vpc_name}-${element(var.azs, count.index)}"))
#   tags = merge(var.common_tags, tomap({ "Name" = "natgw-${local.data.vpc.vpc_product}-${ each.value.name_suffix}-private" }))
  
#   depends_on = [aws_internet_gateway.igw_dc]
# }


####################################################################################
#Rutas de las redes privadas. Si está habilitado el NAT Gateway lo asocia a las rutas
#sino deja solo la ruta por defecto
####################################################################################
resource "aws_route_table" "private" {
  # count                 = var.vertical_routes ? length(var.azs) : var.n_tiers
  for_each = data.aws_availability_zone.all
  vpc_id = data.aws_vpc.vpc_product.id
  propagating_vgws = []
  tags             =  merge(var.common_tags, tomap({ "Name" = "rt-${local.data.vpc.vpc_product}-${each.value.name_suffix}-private" })) 
  

  lifecycle {
    # When attaching VPN gateways it is common to define aws_vpn_gateway_route_propagation
    # resources that manipulate the attributes of the routing table (typically for the private subnets)
    ignore_changes = [propagating_vgws]
  }
}

# resource "aws_route" "route_nat_gateway_private" {
#   for_each = data.aws_availability_zone.all
#   route_table_id         = aws_route_table.private[each.key].id
#   nat_gateway_id         = aws_nat_gateway.nat_gateway_private[each.key].id
#   destination_cidr_block = "0.0.0.0/0"

#   timeouts {
#     create = "5m"
#   }
# }


####################### test output
resource "aws_route_table_association" "route_table_association_private" {
  for_each = toset(data.aws_subnets.snet_amber_eu_central_1_subnets.ids)
  subnet_id = each.value
  route_table_id = aws_route_table.private[index(data.aws_subnets.snet_amber_eu_central_1_subnets.ids, each.key)].id
}



# ####################################################################################
# # route net public
# ####################################################################################
# resource "aws_route_table" "rt_igw_dc" {
#   count  = length(aws_subnet.subnets) != 0 ? 1 : 0
#   vpc_id = aws_vpc.vpc_product.id
#   #tags   = merge(var.common_tags, map("Name", "rt-${var.vpc_name}-public"))
#   tags = merge(var.common_tags, tomap({ "Name" = "rt-${local.data.vpc.vpc_product}-public" }))
# }

# # all traffic NO-LOCAL subnet public route to IGW-Gateway
# resource "aws_route" "rt_igw_dc" {
#   count                  = length(aws_subnet.subnets) != 0 ? 1 : 0
#   route_table_id         = aws_route_table.rt_igw_dc[0].id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.igw_dc[0].id
#   depends_on             = [aws_internet_gateway.igw_dc]
# }

# # asigned route public to Internet Gateway subnet public
# resource "aws_route_table_association" "rt_igw_dc_asoc" {
#   #vpc_id = "${aws_vpc.vpc.id}"
#   for_each       = aws_subnet.subnets
#   # count          = length(aws_subnet.subnets) != 0 ? length(data.aws_availability_zone.all) : 0
#   route_table_id = aws_route_table.rt_igw_dc[0].id
#   subnet_id      = each.value.id
#   depends_on     = [aws_route_table.rt_igw_dc]
# }


######################
# VPC Endpoint for S3
######################

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = data.aws_vpc.vpc_product.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  tags = merge(var.common_tags, tomap({"Name" = "s3-${local.data.vpc.vpc_product}-endpoint" }))
}


####################### test output
resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  for_each = toset(data.aws_subnets.snet_amber_eu_central_1_subnets.ids)
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.private[index(data.aws_subnets.snet_amber_eu_central_1_subnets.ids, each.key)].id
}

# resource "aws_vpc_endpoint_route_table_association" "public_s3" {
#   count = var.enable_s3_endpoint && (var.public_mask != 0 || length(var.public_subnets) != 0) && length(var.azs) > 0 ? 1 : 0

#   vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
#   route_table_id  = aws_route_table.rt_igw_dc[0].id
# }
