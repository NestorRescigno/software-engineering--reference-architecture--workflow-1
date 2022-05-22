
locals {
  dhcp_options_domain_name = var.dhcp_options_domain_name != null ? var.dhcp_options_domain_name : "${var.aws_region}.compute.internal"
}


locals {

  data = {
    sg-common-microservices = ""
    vpc = {
      vpc_product = "${var.project}-${var.environment_prefix}"
    }
  }
}


####################################################################################
# create DHCP Options Set
####################################################################################
resource "aws_vpc_dhcp_options" "dhcp_options" {

  domain_name          = local.dhcp_options_domain_name
  domain_name_servers  = var.dhcp_options_domain_name_servers
  ntp_servers          = var.dhcp_options_ntp_servers
  netbios_name_servers = var.dhcp_options_netbios_name_servers
  netbios_node_type    = var.dhcp_options_netbios_node_type
  #tags                  = merge(var.common_tags, map("Name", "dhcp-ops-${lookup(var.common_tags, "Project")}-${var.vpc_name}"))
  tags = merge(var.common_tags, tomap({ "Name" = "dhcp-ops-Project-${local.data.vpc.vpc_product}" }))

}

resource "aws_vpc_dhcp_options_association" "dhcp_options_association" {
  vpc_id          = var.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_options.id
}