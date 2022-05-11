###########################
### variable
###########################

variable "aws_region" {
  description = "Region"
  type        = string
  default     = "eu-central-1"
}

variable "az_number" {
  # Assign a number to each AZ letter used in our configuration
  default = {
    a = 1
    b = 2
    c = 3
    # and so on, up to n = 14 if that many letters are assigned
  }
}

variable "region_number" {
  # Arbitrary mapping of region name to number to use in
  # a VPC's CIDR prefix.
  default = {
    us-east-1      = 1
    us-west-1      = 2
    us-west-2      = 3
    eu-central-1   = 4
    ap-northeast-1 = 5
  }
}

variable "project" {
  description = "Project"
  type        = string
}

variable "service_name" {
  description = "The name of the service to be created"
  type        = string
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


