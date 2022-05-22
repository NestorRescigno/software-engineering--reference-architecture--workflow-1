terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.13"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  alias = "aws"
  region = var.aws_region
}

###########################
### New Resource Target Group
###########################

# Provides a Target Group resource for use with Load Balancer resources.
# Each target group is used to route requests to one or more registered targets. 
# When you create each listener rule, you specify a target group and conditions. 
# When a rule condition is met, traffic is forwarded to the corresponding target group.
resource "aws_alb_target_group" "alb" {
  name                 = local.alb_tg_service_name
  port                 = local.targetgroup_port
  protocol             = local.targetgroup_protocol
  vpc_id               = var.vpc_id
  deregistration_delay = 30
  slow_start           = 30

  # Application Load Balancer periodically sends requests 
  # to its registered targets to test their status. 
  # These tests are called health checks. 
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
      Project                  = "${var.project}"
      Environment              = "${var.environment}"
      Cluster                  = "${local.cluster_name}"
      "tf:Used"                = "True"
      "Application:ArtifactId" = join("-",[var.service_name,"core"])      
      "Application:GroupId"    = "${var.service_groupid}"
    })
  )

  lifecycle {
    create_before_destroy = true
  }

}