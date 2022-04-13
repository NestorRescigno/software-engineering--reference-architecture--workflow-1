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
    bucket = "terraform-backend-ancill-accounts"

    key    = "int/terraform.[service_name].tfstate" 
    
    region = "eu-central-1"
    dynamodb_table = "terraform-backend-ancill-accounts-locking"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-central-1:468727120003:key/dd424714-7461-4d74-81e8-31b62c409b4f"
    role_arn       = "arn:aws:iam::468727120003:role/TerraformAccessBackendANCILL"
  }
}
