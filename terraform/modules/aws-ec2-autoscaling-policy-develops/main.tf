# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

# ##############################
# ## New resource ASG CPU Policy
# ##############################
resource "aws_autoscaling_policy" "anc-cpu" {
  #count = var.asg.autoscaling_policy_cpu_value != null ? 1 : 0

  name                      = lower(format("%s-%s-anc-cpu-scaling", var.environment_prefix, var.service_name))
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 130

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 90.0
  }

  autoscaling_group_name = aws_autoscaling_group.anc.name
}

# ##############################
# ## New resource ASG Request Policy
# ##############################

resource "aws_autoscaling_policy" "anc-requests" {
  #count = var.asg.autoscaling_policy_requests_value != null ? 1 : 0

  name                      = lower(format("%s-%s-anc-requests-scaling", var.environment_prefix, var.service_name))
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 130

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = format("%s/%s", aws_lb.alb_anc.arn_suffix, aws_alb_target_group.alb_anc.arn_suffix)
    }
    target_value = 1200.0
  }

  autoscaling_group_name = aws_autoscaling_group.anc.name

  depends_on = [aws_autoscaling_attachment.alb_autoscale-anc]
}
