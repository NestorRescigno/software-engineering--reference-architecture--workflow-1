# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.13"
    }
  }
}

provider "aws" {
  region = var.aws_region
  # set provice assume role: set stage in line command "terraform workspace new staging"
  # No credentials explicitly set here because they come from either the
  # environment or the global credentials file.

  # assume_role = {
  #  role_arn = "${var.workspace_iam_roles[terraform.workspace]}"
  # }

}


####################################################################
## Change value key service_name with same value in terraform.tfvars
####################################################################

terraform {
  backend "s3" {
   
    bucket = var.bucket_name  # bucket = "terraform-backend-ancill-accounts"
    key = var.bucket_key   # key= "prelive/terraform.[service_name].tfstate" 

    region = var.aws_region

    dynamodb_table = var.dynamodb_table
    encrypt        = true
    kms_key_id     = var.kms_key_id
    role_arn       = var.role_arn
  }
}
