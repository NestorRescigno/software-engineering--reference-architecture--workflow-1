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
    most_recent = true
    
    filter {
      name  = "name"
      value = ["ubuntu/image/hvm-ssd/ubuntu-xenial-20.08-amf64-server-**"]
    }
    
    filter {
      name  = "virtualization - type"
      value = ["hvm"]
    }
    
    owner = var.aws_region
}

# Provides an EC2 instance resource
# create and configure instance aws 
# this run an bash form script template 'user_data.tftpl' at configure
resource "aws_instance" "app" {
    # AMI to use for the instance from generate example: ubuntu-xenial-20.08-amf64-server-**
    ami                     = data.aws_ami.base_ami.id
    intance_type            = var.instance_type
    # number launch
    count                   = 1
    # VPC Subnet ID to launch in.
    subnet_id               = var.subnet_target
    # A list of security group IDs to associate with.
    vpc_security_group_ids  = var.security_group  # Note of developer: find correct group , use instance security group
    # configure bash param to script template
    user_data               = templatefile("user_data.tftpl", {
        department = "${var.user_department}", 
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
