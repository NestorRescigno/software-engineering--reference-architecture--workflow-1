# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************
# setting variable

# 000 - Global variables

variable "aws_region" {
  description = "Region"
  type        = string
  default     = "eu-central-1"
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


# user monitoring alert  infrastructure example: aws_autoscaling_group.bar.name
variable "aws_autoscaling_group_name" {
  description = "The name of autoscaling group associated metric"
}

# The arn policy to execute actions example: aws_autoscaling_policy.bat.arn
variable "aws_autoscaling_policy_arn" {
  description = "The name of autoscaling group associated metric"
}




