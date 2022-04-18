# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************

provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_providers {
    aws = { source = "hashicorp/aws"
    version = "3.61.0" }
  }
}

####################################################################
## Change value key service_name with same value in terraform.tfvars
####################################################################

terraform {
  backend "s3" {
   
    bucket = var.bucket_name  # bucket = "terraform-backend-ancill-accounts"
    key = var.bucket_key   # key= "prelive/terraform.[service_name].tfstate" 

    region = "eu-central-1"

    dynamodb_table = var.dynamodb_table
    encrypt        = true
    kms_key_id     = var.kms_key_id
    role_arn       = var.role_arn
  }
}
