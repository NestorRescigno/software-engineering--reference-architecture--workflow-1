# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************


################################
### New Resource launch Template
################################
resource "aws_launch_template" "launch" { 
  
  # Decision Server launch template
  
  name          = format("lt-%s-${var.service_name}", var.environment_prefix)
  image_id      = var.ami_id
  instance_type = local.instance_type
  vpc_security_group_ids = [aws_security_group.instances.id, data.aws_security_group.sg_common_microservices.id]
  # user_data              = filebase64("files/prelive_env.sh")       # use to set enviroment var for arcoservices
  iam_instance_profile {
    name = data.aws_iam_instance_profile.ip.name
  }
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      local.global_common_tags,
      tomap({ #AWSInspector = "True",
        Version = var.version
      })
    )
  }
  tag_specifications {
    resource_type = "volume"
    tags = merge(
      local.global_common_tags,
      tomap({
        Name    = "${var.environment_prefix}",
        Version = var.version
      })
    )
  }
  tags = merge(
    local.global_common_tags,
    tomap({
      Name = "${var.environment_prefix}"
    })
  )
}
#############################################################
### New Resource AutoScaling Group   
#############################################################
resource "aws_autoscaling_group" "asg" { 
  
  # Decision Server ASG
  
  name             = "${var.environment_prefix}-${var.service_name}-asg"
  min_size         = local.asg_min
  max_size         = local.asg_max
  desired_capacity = local.asg_desired
  launch_template {
    id      = aws_launch_template.launch.id
    version = aws_launch_template.launch.latest_version
  }
  vpc_zone_identifier       = [data.aws_subnet.snet_amber_eu_central_1a.id, data.aws_subnet.snet_amber_eu_central_1b.id, data.aws_subnet.snet_amber_eu_central_1c.id]
  health_check_grace_period = local.health_check_grace_period
  default_cooldown          = local.default_cooldown
  health_check_type         = local.health_check_type
  wait_for_capacity_timeout = local.wait_for_capacity_timeout
  target_group_arns         = [aws_alb_target_group.alb.arn]
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