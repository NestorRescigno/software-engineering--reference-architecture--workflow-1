variable "aws_region" {
  description = "Region"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "project" {
  description = "Project"
  type        = string
}

variable "environment_prefix" {
  description = "Environment Prefix."
  type        = string
  default     = "dev"
}

variable "common_tags" {
  type    = map(any)
  default = {}
}

#############################################
##  dhcp options domanin 
############################################

variable "dhcp_options_domain_name" {
  description = "Should be true to enable DNS support in the VPC"
  type        = string
  default     = true
}


variable "dhcp_options_domain_name_servers" {
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}

variable "dhcp_options_ntp_servers" {
  description = "Specify a list of NTP servers for DHCP options set (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_name_servers" {
  description = "Specify a list of netbios servers for DHCP options set (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = []
}


variable "dhcp_options_netbios_node_type" {
  description = "Specify netbios node_type for DHCP options set (requires enable_dhcp_options set to true)"
  type        = string
  default     = ""
}

