###########################
### locals vpc
###########################


locals {

  data = {
    sg-common-microservices = ""
    vpc = {
      vpc_product = "${var.project}-${var.environment_prefix}"
      amber = {
        subnet  = "*amber*"
        subneta = join("-",[var.project,"snet","amber", var.aws_region,"a"])
        subnetb = join("-",[var.project,"snet","amber", var.aws_region,"b"])
        subnetc = join("-",[var.project,"snet","amber", var.aws_region,"c"])
      }
      green = {
        subnet  = "*green*"
        subneta = join("-",[var.project,"snet","green", var.aws_region,"a"])
        subnetb = join("-",[var.project,"snet","green", var.aws_region,"b"])
        subnetc = join("-",[var.project,"snet","green", var.aws_region,"c"])
      }
      red = {
        subnet  = "*red*"
        subneta = join("-",[var.project,"snet","red", var.aws_region,"a"])
        subnetb = join("-",[var.project,"snet","red", var.aws_region,"b"])
        subnetc = join("-",[var.project,"snet","red", var.aws_region,"c"])
      }
    }
  }
}
