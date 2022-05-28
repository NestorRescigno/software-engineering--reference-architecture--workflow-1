# service name
variable "service_name" {
  description = "The name of service"
}


# project name 
variable "project" {
  description = "The name of project"
}


variable "environment" {
  description = "Environment"
  type        = string
  default     = "development"
}

variable "environment_prefix" {
  description = "Environment Prefix."
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "The aws region providers"
  default     = "eu-central-1"
} 

variable "common_tags" {
  type    = map(any)
  default = {}
}

# use this value for set IAM en role 
# When configuring Terraform, use either environment variables or the standard credentials file ~/.aws/credentials to 
# provide the administrator user's IAM credentials within the administrative account to both the S3 backend and to 
# Terraform's AWS provider.

# variable "workspace_iam_roles" {
#   default = {
#     development    = "arn:aws:iam::DEVELOPMENT-ACCOUNT-ID:role/Terraform"
#     staging    = "arn:aws:iam::STAGING-ACCOUNT-ID:role/Terraform"
#     production = "arn:aws:iam::PRODUCTION-ACCOUNT-ID:role/Terraform"
#   }
# }