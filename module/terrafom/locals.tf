# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
# example code of [local value](https://www.terraform.io/language/values/locals)


###############################
### Stack local variables
###############################

locals {
  global_common_tags = {
    Project                  = var.project
    Environment              = var.environment
    Name                     = var.service_name
    Cluster                  = local.cluster_name
    Side                     = var.service_name
    "Application:ArtifactId" = "${var.service_name}-core"
    "tf:Used"                = "True"
  }
}

## Change these values if neccesary
locals {

  health_check_grace_period         = "60"  
  default_cooldown                  = "30"  
  health_check_type                 = "ELB"
  wait_for_capacity_timeout         = "30m"
  cluster_name                      = var.service_name
  instance_type                     = "t4g.micro"
  asg_min                           = 1
  asg_desired                       = 1
  asg_max                           = 2
  targetgroup_protocol              = "HTTP"
  targetgroup_port                  = "8080"
  alb_tg_service_name               = "${var.service_name}-${var.environment}-tg"
  traffic_distribution              = "${var.service_name}"
  autoscaling_policy_cpu_value      = 90.0
  autoscaling_policy_requests_value = 1200.0
  estimated_instance_warmup         = 130
  #environment_prefix               = "${var.project}-${var.environment}"
}


locals {

  data = {
    sg-common-microservices = ""
    vpc = {
      vpc-product = "${var.project}-${var.environment}"
      amber = {
        subnet  = "*amber*"
        subneta = "product-*-snet-amber-eu-central-1a"
#       subnetb = "product-*-snet-amber-eu-central-1b"
#       subnetc = "product-*-snet-amber-eu-central-1c"
      }
#    green = {
#        subnet  = "*green*"
#        subneta = "ancill-*-snet-green-eu-central-1a"
#        subnetb = "ancill-*-snet-green-eu-central-1b"
#        subnetc = "ancill-*-snet-green-eu-central-1c"
#      }
#    red = {
#        subnet  = "*red*"
#        subneta = "ancill-*-snet-red-eu-central-1a"
#        subnetb = "ancill-*-snet-red-eu-central-1b"
#        subnetc = "ancill-*-snet-red-eu-central-1c"
#      }
    }
  }
}
