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
        # "Name", format("lt-%s-${var.service_name}", var.environment_prefix),
        # "BackupDaily", "true",
      })
    )
  }
  tags = merge(
    local.global_common_tags,
    tomap({
      Name = "${var.environment_prefix}"
      # "Name", format("lt-%s-${var.service_name}", var.environment_prefix),
      # "BackupDaily", "true",
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
###########################
### New Resource Target Group
###########################
resource "aws_alb_target_group" "alb" {
  name                 = local.alb_tg_service_name
  port                 = local.targetgroup_port
  protocol             = local.targetgroup_protocol
  vpc_id               = data.aws_vpc.vpc_product.id
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
      Cluster                  = local.cluster_name
      "tf:Used"                = "True"
      "Application:ArtifactId" = "${var.service_name}-core"
      "Application:GroupId"    = "${var.service_groupid}"
    })
  )
}
resource "aws_autoscaling_attachment" "alb_autoscale" {
  alb_target_group_arn   = aws_alb_target_group.alb.arn
  autoscaling_group_name = aws_autoscaling_group.asg.id
}

###########################
## New Resource listener
###########################
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb.arn
    type             = "forward"
  }
}


#######################################################
## New Resource Internal ALB 
#######################################################

resource "aws_lb" "alb" {
  name               = "${var.service_name}-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb.id, data.aws_security_group.sg_common_microservices_alb.id]
  subnets         = [data.aws_subnet.snet_amber_eu_central_1a.id, data.aws_subnet.snet_amber_eu_central_1b.id, data.aws_subnet.snet_amber_eu_central_1c.id]

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
      Cluster                  = local.cluster_name
      "Application:GroupId"    = "${var.service_groupid}"
      "Application:ArtifactId" = "${var.service_name}-core"
      "tf:Used"                = "True"
    })
  )
}

#####################################
### New resources ALB SG 
######################################
resource "aws_security_group" "alb" {
  name        = "${var.service_name}-alb-${var.environment_prefix}-sg"
  description = "SG for ${var.service_name} cluster ALB"
  vpc_id      = data.aws_vpc.vpc_product.id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [data.aws_security_group.sg_instances.id]
    description     = "From ${var.service_name} ALB"
  }
  tags = merge(
    local.global_common_tags,
    tomap({
      Name = "${var.service_name}-alb-${var.environment_prefix}-sg"
    })
  )
}

resource "aws_security_group" "instances" {
  depends_on = [
    aws_security_group.alb
  ]
  name        = "${var.service_name}-instances-${var.environment_prefix}-sg"
  description = "SG for ${var.service_name} cluster instances"
  vpc_id      = data.aws_vpc.vpc_product.id

  ingress {
    from_port       = 8080
    to_port         = 8080        # control to tcp/ip: use other port.
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description = "From ${var.service_name} ALB"
  }

  tags = merge(
    local.global_common_tags,
    tomap({
      Name = "${var.service_name}-instances-${var.environment_prefix}-sg"
    })
  )
}

###########################
## New resource Route53 
###########################
resource "aws_route53_zone" "main_domain_local" {
  name = "${var.project}.${var.global_dns}"
}

resource "aws_route53_record" "alb-record" {
  zone_id = aws_route53_zone.main_domain_local.zone_id  
  # zone_id = data.aws_route53_zone.ancillaries_cloud_iberia_local.id
  name    = "${var.service_name}.${var.environment}.${var.project}.${var.global_dns}"
  type    = "A"
 
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

###########################################
## Modified blue record tonew ALB endpoint
###########################################
resource "aws_route53_record" "blue-record" {
  zone_id = aws_route53_zone.main_domain_local.zone_id
  # zone_id = data.aws_route53_zone.ancillaries_cloud_iberia_local.id
  name    = "${var.service_name}.blue.${var.environment}.${var.project}.${var.global_dns}"
  type    = "A"
  allow_overwrite = true
 
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}

############################################
## Modified green record to new ALB endpoint
############################################
resource "aws_route53_record" "green-record" {
  zone_id = aws_route53_zone.main_domain_local.zone_id
  # zone_id = data.aws_route53_zone.ancillaries_cloud_iberia_local.id
  name    = "${var.service_name}.green.${var.environment}.${var.project}.${var.global_dns}"
  type    = "A"
  allow_overwrite = true
 
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}

# ##############################
# ## New resource ASG CPU Policy
# ##############################
resource "aws_autoscaling_policy" "cpu" {
  #count = var.asg.autoscaling_policy_cpu_value != null ? 1 : 0

  name                      = lower(format("%s-%s-cpu-scaling", var.environment_prefix, var.service_name))
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 130

  target_tracking_configuration {
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

resource "aws_autoscaling_policy" "requests" {
  #count = var.asg.autoscaling_policy_requests_value != null ? 1 : 0

  name                      = lower(format("%s-%s-requests-scaling", var.environment_prefix, var.service_name))
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 130

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = format("%s/%s", aws_lb.alb.arn_suffix, aws_alb_target_group.alb.arn_suffix)
    }
    target_value = 1200.0
  }

  autoscaling_group_name = aws_autoscaling_group.asg.name

  depends_on = [aws_autoscaling_attachment.alb_autoscale]
}
