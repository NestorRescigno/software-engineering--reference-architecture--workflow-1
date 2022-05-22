# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************
# setting variable

variable "aws_region" {
  description = "The aws region providers"
  default     = "eu-central-1"
} 

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

variable "service_groupid" {
  description = "The name of groupid application service."
  type        = string
}

variable "global_dns" {
  description = "mian domain dns."
  type        = string
  default     = "cloud.iberia.local"
}

variable "vpc_id" {
  description = "mian domain dns."
  type        = string
  default     = "cloud.iberia.local"
}