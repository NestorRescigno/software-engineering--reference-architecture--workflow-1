# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************

# ##############################
# ## IAM Role
# ##############################

resource "aws_iam_role" "service" {
  # asign name role iam example: demo-dev-role
  name        = join("-",[var.service_name,var.environment_prefix,"role"])
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
      "Action": "sts:AssumeRole",
      "Principal": {
          "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
      }
  ]
}
EOF

  tags = local.global_common_tags
}
  

# ##############################
# ## IAM Instance profile Role
# ##############################

resource "aws_iam_instance_profile" "service" {
  # asign name profile IAM example: demo-instanceprofile-dev
  name = join("-"[var.service_name,"instanceprofile",var.environment_prefix])
  role = aws_iam_role.service.name
}

##########################################################
# Attach the policy cloudwatch_agent to the role

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.service.name
  policy_arn = data.aws_iam_policy.cloudwatch_agent.arn
}

# Attach the policy ssm to the role
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.service.name
  policy_arn = data.aws_iam_policy.ssm.arn
}

# Attach the policy common-microservices to the role
resource "aws_iam_role_policy_attachment" "common-microservices" {
  role       = aws_iam_role.service.name
  policy_arn = data.aws_iam_policy.common-microservices.arn

    
################################
### New Resource launch Template
################################

# Provides an EC2 launch template resource. 
# Can be used to create instances or auto scaling groups.

resource "aws_launch_template" "launch" { 
  
  # Decision Server launch template
  
  name          = format("lt-%s-${var.service_name}", var.environment_prefix)
  image_id      = var.ami_id
  instance_type = local.instance_type
  vpc_security_group_ids = var.security_group
  
  # The IAM Instance Profile to launch the instance with.
  iam_instance_profile {
    name = data.aws_iam_instance_profile.ip.name
  }

  # The tags to apply to the resources during launch. 
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      local.global_common_tags,
      tomap({ 
        #AWSInspector = "True",
        Version = var.version
      })
    )
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(
      local.global_common_tags,
      tomap({
        Name    = var.environment_prefix,
        Version = var.version
      })
    )
  }

  tags = merge(
    local.global_common_tags,
    tomap({
      Name = var.environment_prefix
    })
  )
}


#############################################################
### New Resource AutoScaling Group   
#############################################################

resource "aws_autoscaling_group" "asg" { 
  
  # Decision Server ASG
  
  name             = join("-",[var.environment_prefix,var.service_name,"asg"])
  min_size         = local.asg_min
  max_size         = local.asg_max
  desired_capacity = local.asg_desired
  
  launch_template {
    id      = aws_launch_template.launch.id
    # version = aws_launch_template.launch.last_version
  }
  
  #vpc_zone_identifier       = [data.aws_subnet.snet_amber_eu_central_1a.id, data.aws_subnet.snet_amber_eu_central_1b.id, data.aws_subnet.snet_amber_eu_central_1c.id]
  vpc_zone_identifier       = var.subnet_target
  target_group_arns         = [var.aws_alb_target_group_arn]
  
  health_check_grace_period = local.health_check_grace_period
  default_cooldown          = local.default_cooldown
  health_check_type         = local.health_check_type
  wait_for_capacity_timeout = local.wait_for_capacity_timeout
 
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
      value               = join("-",[var.environment_prefix,var.service_name,"asg"])
      propagate_at_launch = true
    }
  ]
  # destroy is disable, can't new create with other param.
  lifecycle { create_before_destroy = false }
}


# ##############################
# ## New resource ASG CPU Policy
# ##############################

# Provides an Application AutoScaling Policy resource.

resource "aws_autoscaling_policy" "cpu" {
  # count = var.asg.autoscaling_policy_cpu_value != null ? 1 : 0
  
  # asign name example: dev-demo-cpu-scaling

  name                      = lower(format("%s-%s-cpu-scaling", var.environment_prefix, var.service_name))
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 130

  # A target tracking policy, requires 
  target_tracking_configuration {
    # The metric type.
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }

  autoscaling_group_name = aws_autoscaling_group.asg.name
}

# ##############################
# ## New resource ASG Request Policy
# ##############################

# Provides an Application AutoScaling Policy resource.
resource "aws_autoscaling_policy" "requests" {
  #count = var.asg.autoscaling_policy_requests_value != null ? 1 : 0

  # asign name example: dev-demo-requests-scaling
  name                      = lower(format("%s-%s-requests-scaling", var.environment_prefix, var.service_name))
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 130

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = format("%s/%s", var.aws_lb_alb_arn_suffix, var.aws_alb_target_group_arn_suffix)
    }
    target_value = 1200.0
  }

  autoscaling_group_name = aws_autoscaling_group.asg.name

  depends_on = [aws_autoscaling_attachment.alb_autoscale]
}

# autoscaling attachment 
resource "aws_autoscaling_attachment" "alb_autoscale" {
  alb_target_group_arn   = var.aws_alb_target_group_arn
  autoscaling_group_name = aws_autoscaling_group.asg.id
}
