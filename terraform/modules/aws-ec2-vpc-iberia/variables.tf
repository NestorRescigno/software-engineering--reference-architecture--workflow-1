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

variable "environment" {
  description = "Environment"
  type        = string
}

variable "environment_prefix" {
  description = "Environment Prefix."
  type        = string
}

variable "global_dns" {
  description = "dns."
  type        = string
  default     = "cloud.iberia.local"
}

variable "bucket_name" {
  description = "bucket_name."
  type        = string
}

variable "bucket_key" {
  description = "bucket_key."
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
  description = "role aim arn."
  type        = string
}
