# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

###########################
## New resource Route53 
###########################

resource "aws_route53_record" "alb-record" {
  zone_id = data.aws_route53_zone.ancillaries_cloud_iberia_local.id
  name    = "${var.service_name}.${var.environment}.ancillaries.cloud.iberia.local"
  type    = "A"
  

  alias {
    name                   = aws_lb.alb_anc.dns_name
    zone_id                = aws_lb.alb_anc.zone_id
    evaluate_target_health = true
  }
}

### TO-DO: Delete these blue-green records redirection #####

###########################################
## Modified blue record tonew ALB endpoint
###########################################
resource "aws_route53_record" "blue-record" {
  zone_id = data.aws_route53_zone.ancillaries_cloud_iberia_local.id
  name    = "${var.service_name}.blue.${var.environment}.ancillaries.cloud.iberia.local"
  type    = "A"
  allow_overwrite = true
  

  alias {
    name                   = aws_lb.alb_anc.dns_name
    zone_id                = aws_lb.alb_anc.zone_id
    evaluate_target_health = false
  }
}

############################################
## Modified green record to new ALB endpoint
############################################
resource "aws_route53_record" "green-record" {
  zone_id = data.aws_route53_zone.ancillaries_cloud_iberia_local.id
  name    = "${var.service_name}.green.${var.environment}.ancillaries.cloud.iberia.local"
  type    = "A"
  allow_overwrite = true
  

  alias {
    name                   = aws_lb.alb_anc.dns_name
    zone_id                = aws_lb.alb_anc.zone_id
    evaluate_target_health = false
  }
}

