# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************

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

####################################################################
## Change value key service_name with same value in terraform.tfvars
####################################################################

terraform {
  backend "s3" {
   
    bucket = var.bucket_name  # bucket = "terraform-backend-ancill-accounts"
    key = var.bucket_key   # key= "prelive/terraform.[service_name].tfstate" 

    region = provider.aws.region

    dynamodb_table = var.dynamodb_table
    encrypt        = true
    kms_key_id     = var.kms_key_id
    role_arn       = var.role_arn
  }
}
