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
    # set provice assume role: set stage in line command "terraform workspace new staging"
  # No credentials explicitly set here because they come from either the
  # environment or the global credentials file.

  # assume_role = {
  #  role_arn = "${var.workspace_iam_roles[terraform.workspace]}"
  # }

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


# Note of developer: use lanch template with script 

# # Provides an EC2 instance resource
# # create and configure instance aws 
# # this run an bash form script template 'user_data.tftpl' at configure
# resource "aws_instance" "app" {
#     # AMI to use for the instance from generate example: ubuntu-xenial-20.08-amf64-server-**
#     for_each                = data.aws_subnets.snet_amber_eu_central_1_subnets.ids
#     ami                     = data.aws_ami.base_ami.id
#     instance_type           = var.instance_type
#     # number launch
#     # count                   = 1
#     # VPC Subnet ID to launch in.
#     subnet_id               = each.value # test with id because data not get id
#     # A list of security grou[p IDs to associate with.
#     vpc_security_group_ids  = [aws_security_group.alb.id, aws_security_group.instances.id] 
#     # IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile.
#     iam_instance_profile    = aws_iam_instance_profile.iam_instance_profile.name


#     # configure bash param to script template
#     user_data               = templatefile("user_data.tftpl", {
#         department = "${var.user_departament}", 
#         name = "${var.user_name}", 
#         lenguage= "${var.lenguage_code}",
#         artifact= "${var.ref}" , 
#         package = "${var.package}" , 
#         user   = "${var.artifact_user}",
#         secret = "${var.artifact_secret}"
#       })
#     tags = {
#         #Name = join("-",["i",var.service_name, var.service_version])
#         Name = join("-",[var.service_name, var.environment_prefix]) # remove version un tag for service @ lastVersion
#     }

    
#   # destroy instance and reemplace with new configuration.  
#   lifecycle { create_before_destroy = true }  
# }
