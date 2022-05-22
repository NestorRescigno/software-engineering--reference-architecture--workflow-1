# project name 
variable "aws_region" {
  description = "The aws region providers"
  default     = "eu-central-1"
} 

variable "vpc_id" {
  type    = string
}

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

variable "hasPrivateSubnet" {
  description = "the vpc has private subnet"
  type        = bool
  default     = false
}