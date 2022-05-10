

#########################
###### Amber Subnets data
#########################

data "aws_subnet_ids" "snet_amber_eu_central_1_subnets" {
  vpc_id = aws_vpc.vpc_product.id

  tags = {
    Name = local.data.vpc.amber.subnet
  }
}

data "aws_subnet" "snet_amber_eu_central_1a" {
  vpc_id = aws_vpc.vpc_product.id

  tags = {
    Name = local.data.vpc.amber.subneta
  }
}

data "aws_subnet" "snet_amber_eu_central_1b" { 
  vpc_id = aws_vpc.vpc_product.id

  tags = {
    Name = local.data.vpc.amber.subnetb
  }
}

data "aws_subnet" "snet_amber_eu_central_1c" {
  vpc_id = aws_vpc.vpc_product.id
  tags = {
    Name = local.data.vpc.amber.subnetc
  }
}

#########################
## instance profile ip 
#########################
data "aws_iam_instance_profile" "ip" {
  name = join("-",[var.project,var.environment,"instanceprofile",var.service_name])
}
