# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************

# Module create build image in EC2 aws

# Define provider aws
# provider "aws" {
#  project     = var.project_name
#  access_key  = var.access_key
#  region      = var.availability_zone_name
#  secret_key  = var.secret_key
# }

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

# data source base ami
data "aws_ami" "base_ami" {
    
    executable_users = ["self"]
    most_recent = true
    # name_regex       = "^amazon-linux2-\\d{3}"
    owners           = ["self"]

    filter {
      name   = "name"
      values = ["amazon-linux2-*"]
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


#####################################
### New resources ALB SG 
######################################

# Provides a security group resource for cluster ALB

resource "aws_security_group" "alb" {

  # asign name: demo-alb-dev-sg
  name        = join("-",[var.service_name,"alb",var.environment_prefix,"sg"])
  description = "SG for ${var.service_name} cluster ALB"
  
  # asign vpc id to apply security group 

  vpc_id      = data.aws_vpc.vpc_product.id

  # Configuration block for ingress rules. 
  # Can be specified multiple times for each ingress rule. 
  # Each ingress block supports fields documented below. 
  # This argument is processed in attribute-as-blocks mode.
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [ data.aws_security_group.sg_instances.id ]
    description     = "From ${var.service_name} ALB"
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
  name        = join("-",[var.service_name,"instances",var.environment_prefix,"sg"])
  description = "SG for ${var.service_name} cluster instances"
  vpc_id      = data.aws_vpc.vpc_product.id
  

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

# Provides an EC2 instance resource
# create and configure instance aws 
# this run an bash form script template 'user_data.tftpl' at configure
resource "aws_instance" "app" {
    # AMI to use for the instance from generate example: ubuntu-xenial-20.08-amf64-server-**
    ami                     = data.aws_ami.base_ami.id
    instance_type           = var.instance_type
    # number launch
    count                   = 1
    # VPC Subnet ID to launch in.
    subnet_id               = data.aws_subnet.snet_amber_eu_central_1a.id
    # A list of security grou[p IDs to associate with.
    vpc_security_group_ids  = [aws_security_group.alb.id, aws_security_group.instances.id] 
    # configure bash param to script template
    user_data               = templatefile("user_data.tftpl", {
        department = "${var.user_departament}", 
        name = "${var.user_name}", 
        lenguage= "${var.lenguage_code}",
        artifact= "${var.ref}" , 
        package = "${var.package}" , 
        user   = "${var.artifact_user}",
        secret = "${var.artifact_secret}"
      })
    tags = {
        #Name = join("-",["i",var.service_name, var.service_version])
        Name = join("-",["i",var.service_name]) # remove version un tag for service @ lastVersion
    }
  # destroy instance and reemplace with new configuration.  
  lifecycle { create_before_destroy = true }  
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


resource "aws_iam_instance_profile" "iam_instance_profile" {
  count = data.aws_iam_instance_profile.ip.name != "null" ? 0 : 1
  name = join("-",[var.project, var.environment, "instanceprofile", var.service_name])
  role = aws_iam_role.role.name
}