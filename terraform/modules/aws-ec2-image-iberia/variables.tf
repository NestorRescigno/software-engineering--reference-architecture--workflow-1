# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************
# setting variable

# user creating this infrastructure
variable "user_name" {
  description = "The user creating this infrastructure"
  default     = "user-ec2"
}

# organization type
variable "user_departament" {
  description = "The organization the user belongs to: dev, prod, qa"
  default     = "dev"
}

# instance type to create instance
variable "instance_type" {
  description = "The instance aws type"
  default     = "t2.micro"
}

# reference register 
variable "ref" {
  description = "The reference register artifact"
}

variable "lenguage_code" {
  description ="lenguage code origin for example java, angular , go , etc."
  validation{
    condition     = can(regex("", var.lenguage_code))
    error_message = "the lenguage value must be a valid: java, angular, go"
  }
}
