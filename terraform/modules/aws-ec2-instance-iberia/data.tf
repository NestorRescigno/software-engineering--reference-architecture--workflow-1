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


data "aws_iam_instance_profile" "ip" {
  name = join("-",[var.project,var.environment,"instanceprofile",var.service_name])
}

# #########################
# ## data source base ami
# #########################
# 
data "aws_ami" "base_ami" {
    
    most_recent = true
    # name_regex       = "^amazon-linux2-\\d{3}"
    owners = ["self"]

    filter {
      name   = "name"
      values = ["shared-linux2-base*"]
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

# #########################
# ## SG for instances
# #########################


# data "aws_security_group" "instances" { 
#   name = join("-",[var.service_name, "instances",var.environment_prefix,"sg"])
#   vpc_id = data.aws_vpc.vpc_product.id
# }

# data "aws_security_group" "alb" { 
#   name = join("-",[var.service_name, "alb", var.environment_prefix, "sg"])
#   vpc_id = data.aws_vpc.vpc_product.id
# }


# data "aws_security_group" "sg_common_microservices" {
#  name = join("-",[var.project,"sg","common","microservices"])
#  vpc_id = data.aws_vpc.vpc_product.id
#}

#########################
### SG for ALB Internal
#########################

#data "aws_security_group" "sg_common_microservices_alb" {
#  name = join("-",[var.project,"sg","common","microservices","alb"])
#  vpc_id = data.aws_vpc.vpc_product.id
#}


#########################
###### Amber Subnets data
#########################

data "aws_subnet_ids" "snet_amber_eu_central_1_subnets" {
  vpc_id = data.aws_vpc.vpc_product.id

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