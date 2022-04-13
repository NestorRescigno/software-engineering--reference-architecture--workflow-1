# 000 - Global variables

variable "anc_ins_ami_id" {
  description = "AMI id"
  type        = string
}
variable "anc_ins_version" {
  description = "Version ID"
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
