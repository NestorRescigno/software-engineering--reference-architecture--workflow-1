# project name 
variable "project" {
  description = "The name of project"
  type        = string
}

# service name
variable "service_name" {
  description = "The name of service"
   type        = string
}

# pr

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
