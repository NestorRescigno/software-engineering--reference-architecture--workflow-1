#########################
## VPC 
#########################

data "aws_vpc" "vpc_product" {
  tags = {
      Name = local.data.vpc.vpc_product
  }
}

data "aws_iam_role" "role" {
   name = join("-", [var.project, var.environment, "role"])
}




#######################################
### Security group
########################################

data "aws_security_group" "alb"{
  name = join("-",[var.service_name,"alb",var.environment_prefix,"sg"])
}

data "aws_security_group" "instances"{
  name = join("-",[var.service_name, "instances",var.environment_prefix,"sg"])
}

data "aws_iam_instance_profile" "iam_instance_profile" {
  name = join("-",[var.project,var.environment,"instanceprofile",var.service_name])
}

# #########################
# ## data source base ami
# #########################
# 
data "aws_ami" "base_ami" {
    
    most_recent = true
    # name_regex       = "^amazon-linux2-\\d{3}"
    # owners = ["self"]
    owners = ["468727120003"]

    filter {
      name   = "name"
      values = ["iaggbs-shared-amzn2-base-arm64-v2.2.0-*"]
    }
    # filter {
    #  name  = "name"
    #  value = ["ubuntu/image/hvm-ssd/ubuntu-xenial-20.08-amf64-server-**"]
    # }
    
  #  filter {
  #    name  = "virtualization - type"
  #    value = ["hvm"]
  #  }

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