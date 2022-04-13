# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

###########################
## New Resource listener
###########################
resource "aws_lb_listener" "lb-listener-anc" {
  load_balancer_arn = aws_lb.alb_anc.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_anc.arn
    type             = "forward"
  }
}


#######################################################
## New Resource Internal ALB 
#######################################################

resource "aws_lb" "alb_anc" {
  name               = "${var.service_name}-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups = [aws_security_group.anc-alb.id, data.aws_security_group.sg-common-microservices-alb.id]
  subnets         = [data.aws_subnet.snet-amber-eu-central-1a.id, data.aws_subnet.snet-amber-eu-central-1b.id, data.aws_subnet.snet-amber-eu-central-1c.id]

  enable_deletion_protection = false

  access_logs {
    bucket  = "${var.environment_prefix}-elb-logs"
    prefix  = lower(format("%s-%s-ap-lb", var.environment_prefix, var.service_name))
    enabled = true
  }

  tags = merge(
    #local.tags,
    #local.global_common_tags,
    tomap({
      Name = lower(format("%s-%s-ap-lb", var.environment_prefix, var.service_name)),
      Side                     = "alb"
      Terraform                = "True"
      Project                  = var.project
      Environment              = var.environment
      Cluster                  = local.anc_cluster_name
      "Application:GroupId"    = "com.ib.ancillaries"
      "Application:ArtifactId" = "${var.service_name}-core"
      "tf:Used"                = "True"
    })
  )
}

