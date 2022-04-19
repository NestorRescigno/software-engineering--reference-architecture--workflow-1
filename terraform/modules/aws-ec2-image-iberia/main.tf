# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************

# Module create build image in EC2 aws

# Define provider aws
provider "aws" {
  project     = var.project_name
  region      = var.availability_zone_name
  access_key  = var.access_key
  secret_key  = var.secret_key
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
    
    owner = provider.aws.project
}

# instance aws with script configuration bash on instance
resource "aws_instance" "app" {
    ami                   = data.aws_ami.base_ami.id
    intance_type          = var.instance_type
    subnet_id             = var.subnet
    vpc_scurity_group_ids = [var.security]
    user_data             = templatefile("user_data.tftpl", {
        department = var.user_department, 
        name = var.user_name, 
        lenguage= var.lenguage_code,
        artifact= var.ref , 
        package = var.package , 
        user   = var.artifact_user,
        secret = var.artifact_secret
      })
}

# resource ami form instance
resource "aws_ami_from_instance" "app_ami" {
    name = join("-",[((var.lenguage_code=="java")?"ms":"web"), var.project_name, var.service_name, var.service_version, formatdate("YYMMMDDhhmmss", timestamp)])
    source_instance_id = resource.aws_instance.app.id
}

# destroy instance app
