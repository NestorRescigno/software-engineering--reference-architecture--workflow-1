locals {

  global_common_tags = {
    Project                  = "${var.project}"
    Environment              = "${var.environment}"
    Name                     = "${var.service_name}"
    Cluster                  = "${local.cluster_name}"
    Side                     = "${var.service_name}"
    #Type                     = "Service" //This tag is checked in deploys by jenkins, so it no longer makes sense.
    "Application:ArtifactId" =  join("-",[var.service_name,"core"])
    "tf:Used"                = "True"
  }
}

## Change these values if neccesary
locals {
  cluster_name          = var.service_name
}



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
