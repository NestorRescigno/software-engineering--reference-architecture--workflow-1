###########################
### locals vpc
###########################
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
