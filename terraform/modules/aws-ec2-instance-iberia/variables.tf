# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************
# setting variable

# user creating this infrastructure
variable "user_name" {
  description = "The user creating this infrastructure"
  default     = "ec2-user"
}


variable "aws_region" {
  description = "The aws region providers"
  default     = "eu-central-1"
} 

# organization type
variable "user_departament" {
  description = "The organization the user belongs to: dev, prod, qa"
  default     = "dev"
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
variable "project" {
  description = "The name of project"
}

# instance type to create instance
variable "instance_type" {
  description = "The instance aws type"
  default     = "t2.micro" 
}

# reference register 
variable "ref" {
  description = "The reference register artifact. example: Nexus"
}

# reference register 
variable "package" {
  description = "The reference type of package artifact. example: jar"
}

# user read to reference register 
variable "artifact_user" {
  description = "the user access to read register artifact. example: Nexus"
}

# secret read to reference register 
variable "artifact_secret" {
  description = "the secret key access to read register artifact. example: Nexus"
}

variable "lenguage_code" {
  description ="lenguage code origin for example java, angular , go , etc."
  # validation{
  #   condition     = can(regex("", var.lenguage_code))
  #   error_message = "the lenguage value must be a valid: java, angular, go"
  # }
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

variable "pem" {
  description = "key peir"
  type        = string
  default     = "runner-key"
}