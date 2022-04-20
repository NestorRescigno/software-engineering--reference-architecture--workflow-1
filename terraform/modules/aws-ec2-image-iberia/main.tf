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
  region = var.aws_region
}


# resource ami form instance
resource "aws_ami_from_instance" "app_ami" {
    name = join("-",[((var.lenguage_code=="java")?"ms":"web"), var.project_name, var.service_name, var.service_version, formatdate("YYMMMDDhhmmss", timestamp)])
    source_instance_id = var.source_instance_id
}

# destroy instance app
