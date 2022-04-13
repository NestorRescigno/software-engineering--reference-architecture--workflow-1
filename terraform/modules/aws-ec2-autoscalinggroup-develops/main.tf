# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

#############################################################
### Resource AutoScaling Group   
#############################################################
resource "aws_autoscaling_group" "anc" { // Decision Server ASG
  name             = "${var.environment_prefix}-${var.service_name}-asg"
  min_size         = local.anc_asg_min
  max_size         = local.anc_asg_max
  desired_capacity = local.anc_asg_desired
  launch_template {
    id      = aws_launch_template.anc.id
    version = aws_launch_template.anc.latest_version
  }
  vpc_zone_identifier       = [data.aws_subnet.snet-amber-eu-central-1a.id, data.aws_subnet.snet-amber-eu-central-1b.id, data.aws_subnet.snet-amber-eu-central-1c.id]
  health_check_grace_period = local.health_check_grace_period
  default_cooldown          = local.default_cooldown
  health_check_type         = local.health_check_type
  wait_for_capacity_timeout = local.wait_for_capacity_timeout
  target_group_arns         = [aws_alb_target_group.alb_anc.arn]
  termination_policies      = ["OldestInstance"]
  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tags"]
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.environment_prefix}-${var.service_name}-asg"
      propagate_at_launch = true
    }
  ]

  lifecycle { create_before_destroy = false }
}
