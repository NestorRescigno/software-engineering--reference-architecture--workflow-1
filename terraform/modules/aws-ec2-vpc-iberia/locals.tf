# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************
# 000 - local variables

###############################
### Stack local variables
###############################

locals {

  global_common_tags = {
    Project                  = "${var.project}"
    Environment              = "${var.environment}"
    Name                     = "${var.service_name}"
    Cluster                  = "${local.cluster_name}"
    Side                     = "${var.service_name}"
    #Type                     = "Service" //This tag is checked in deploys by jenkins, so it no longer makes sense.
    "Application:ArtifactId" = join("-",[var.service_name,"core"])      
    "tf:Used"                = "True"
  }
}

## Change these values if neccesary
locals {

  health_check_grace_period = "60"  
  default_cooldown          = "30" 
  health_check_type         = "ELB"
  wait_for_capacity_timeout = "30m"
  cluster_name          = var.service_name
  instance_type         = "t4g.micro"
  asg_min               = 1
  asg_desired           = 1
  asg_max               = 2
  targetgroup_protocol      = "HTTP"
  targetgroup_port          = "8080"
  alb_tg_service_name       = join("-",[var.service_name, var.environment_prefix,"tg"])  # use prefix because "name" cannot be longer than 32 characters
  #environment_prefix       = "${var.project}-${var.environment}"
  traffic_distribution      = "${var.service_name}"
  autoscaling_policy_cpu_value = 90.0
  autoscaling_policy_requests_value = 1200.0
  estimated_instance_warmup   = 130
}


locals {

  data = {
    sg-common-microservices = ""
    vpc = {
      vpc_product = "${var.project}-${var.environment}"
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
