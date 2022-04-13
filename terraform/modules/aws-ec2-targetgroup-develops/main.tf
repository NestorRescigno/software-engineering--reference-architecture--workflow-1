# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

###########################
### Resource Target Group
###########################
resource "aws_alb_target_group" "alb_anc" {
  name                 = local.alb_tg_service_name
  port                 = local.targetgroup_port
  protocol             = local.targetgroup_protocol
  vpc_id               = data.aws_vpc.vpc-ancill.id
  deregistration_delay = 30
  slow_start           = 30

  health_check {
    path                = "/management/health"
    matcher             = "200"
    timeout             = "12"
    interval            = "30"
    healthy_threshold   = "2"
    unhealthy_threshold = "6"
  }

  tags = merge(
    #local.tags,
    #local.global_common_tags,
    tomap({
      Name                     = lower(format("%s-%s-alb-tg", var.environment_prefix, var.service_name)),
      Side                     = "alb"
      Terraform                = "True"
      Project                  = var.project
      Environment              = var.environment
      Cluster                  = local.anc_cluster_name
      "tf:Used"                = "True"
      "Application:ArtifactId" = "${var.service_name}-core"
      "Application:GroupId"    = "com.ib.ancillaries"
    })
  )
}

######################################################
### Resource autoscaling attachment to Target Group
######################################################

resource "aws_autoscaling_attachment" "alb_autoscale-anc" {
  alb_target_group_arn   = aws_alb_target_group.alb_anc.arn
  autoscaling_group_name = aws_autoscaling_group.anc.id
}
