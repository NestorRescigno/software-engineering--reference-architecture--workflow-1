variable "az_number" {
  # Assign a number to each AZ letter used in our configuration
  default = {
    a = 1
    b = 2
    c = 3
    # and so on, up to n = 14 if that many letters are assigned
  }
}

variable "region_number" {
  # Arbitrary mapping of region name to number to use in
  # a VPC's CIDR prefix.
  default = {
    us-east-1      = 1
    us-west-1      = 2
    us-west-2      = 3
    eu-central-1   = 4
    ap-northeast-1 = 5
  }
}

variable "project" {
  description = "Project"
  type        = string
}

variable "aws_vpc_id" {
  description = "aws vpc id"
  type        = string
}

variable "cidr_block" {
  description = "cidir block"
  type        = string
}

variable "hasPublicIpOnLaunch" {
  description = "the vpc has private subnet"
  type        = bool
  default     = false
}