variable "aws_region" {
  description = "The aws region providers"
  default     = "eu-central-1"
} 

# project name 
variable "project" {
  description = "The name of project"
}

# service name
variable "service_name" {
  description = "The name of service"
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

variable "common_tags" {
  type    = map(any)
  default = {}
}

variable "hasPrivateSubnet" {
  description = "the vpc has private subnet"
  type        = bool
  default     = false
}