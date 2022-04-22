# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************

# Module create build image in EC2 aws

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
  region = var.aws_region
}

# data source with identity account
data "aws_caller_identity" "current" {}

locals {
  sharedId = [data.aws_caller_identity.current.id, var.shareds_id]
}

# create ami form instance id
resource "aws_ami_from_instance" "app_ami" {
    # asign name for type lenguage example: 
    # - java:     ms-bestpratice-demo-1.0.0-20220422201115
    # - angular:  web-bestpratice-demo-1.0.0-20220422201115

    name = join("-",[((var.lenguage_code=="java")?"ms":"web"), var.project_name, var.service_name, var.service_version, formatdate("YYMMMDDhhmmss", timestamp)])
    source_instance_id = var.source_instance_id
    
}

# shared ami other account id
resource "aws_ami_launch_permission" "shared" {
      count = length(local.sharedId)
      image_id = aws_ami_from_instance.app_ami.id
      account_id  = local.sharedId[count.id]
}
