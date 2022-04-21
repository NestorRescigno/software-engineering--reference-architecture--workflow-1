# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************
# setting variable
variable "aws_region" {
  description = "The aws region providers"
  default     = "us-east-1"
} 

# service name
variable "service_name" {
  description = "The name of service"
}

# service name
variable "service_version" {
  description = "The version of service"
}

# project name 
variable "project_name" {
  description = "The name of project"
}

# secret read to reference register 
variable "source_instance_id" {
  description = "the EC2 instance aws id"
}

# secret read to reference register 
variable "shareds_id" {
  description = "the ami shared to other account" 
}

variable "lenguage_code" {
  description ="lenguage code origin for example java, angular , go , etc."
  validation{
    condition     = can(regex("", var.lenguage_code))
    error_message = "the lenguage value must be a valid: java, angular, go"
  }
}
