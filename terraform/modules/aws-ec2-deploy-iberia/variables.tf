# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************
# 000 - Global variables

variable "ami_id" {
  description = "AMI id"
  type        = string
}

variable "version" {
  description = "Version ID"
  type        = string
}

variable "service_groupid" {
  description = "The name of groupid application service."
  type        = string
}


variable "service_name" {
  description = "The name of the service to be created"
  type        = string
}

variable "aws_region" {
  description = "Region"
  type        = string
  default     = "eu-central-1"
}

variable "project" {
  description = "Project"
  type        = string
}

variable instance_type {
  description = "type of instance up"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "environment_prefix" {
  description = "Environment Prefix."
  type        = string
}

variable "global_dns" {
  description = "mian domain dns."
  type        = string
  default     = "cloud.iberia.local"
}

# array security group
variable "security_group" {
  description = "the security group aws"
}

# arry subnet ids
variable "subnet_target" {
  description = "the subnet aws"
}

variable "aws_alb_target_group_arn" {
  description = "aws target group arn."
  type        = string
}

variable "aws_lb_alb_arn_suffix" {
  description = "aws target group arn."
  type        = string
}

variable "aws_alb_target_group_arn_suffix" {
  description = "aws target group arn."
  type        = string
}

variable "bucket_name" {
  description = "bucket aws name."
  type        = string
}

variable "bucket_key" {
  description = "bucket aws key."
  type        = string
}

variable "dynamodb_table" {
  description = "dynamo db table."
  type        = string
}

variable "kms_key_id" {
  description = "kms key id."
  type        = string
}

variable "role_arn" {
  description = "aws role aim arn."
  type        = string
}
