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

#######################################################
## New Resource Internal ALB 
#######################################################

# Provides a Load Balancer resource.
# A load balancer distributes incoming application 
# traffic across multiple EC2 instances in multiple Availability Zones.

resource "aws_lb" "alb" {

  # Provides a Load Balancer resource. example: demo-alb
  name               = join("-",[var.service_name,"alb"])
  internal           = true
  load_balancer_type = "application"

  # asign segurity group to loadbalancer
  # security_groups = [aws_security_group.alb.id, data.aws_security_group.sg_common_microservices_alb.id]
  security_groups = [var.securitygroups]

  # A list of subnet IDs to attach to the LB. 
  # Subnets cannot be updated for Load Balancers of type network. 
  # Changing this value for load balancers of type network will force a recreation of the resource.
  subnets         = [var.subnets]
  
  # If true, deletion of the load balancer will be disabled via the AWS API. 
  # This will prevent Terraform from deleting the load balancer. Defaults to false.
  enable_deletion_protection = false

  ########################################################################################################################
  # Note of developer: comment line 208 to 215, pending test create resource
  # An Access Logs block. Access Logs documented below.
  #access_logs {
  #  # The S3 bucket name to store the logs in. example dev-alb-logs
  #  bucket  = join("-",[var.environment_prefix,"alb","logs"])
    
    # The S3 bucket prefix. Logs are stored in the root if not configured. example: dev-demo-ap-lb
  #  prefix  = lower(format("%s-%s-ap-lb", var.environment_prefix, var.service_name))
  #  enabled = true
  #}
  ############################################################################################################################
  
  tags = merge(
    #local.tags,
    #local.global_common_tags,
    tomap({
      Name = lower(format("%s-%s-ap-lb", var.environment_prefix, var.service_name)),
      Side                     = "alb"
      Terraform                = "True"
      Project                  = "${var.project}"
      Environment              = "${var.environment}"
      Cluster                  = "${local.cluster_name}"
      "tf:Used"                = "True"
      "Application:ArtifactId" = join("-",[var.service_name,"core"])      
      "Application:GroupId"    = "${var.service_groupid}"   # Note of develops: use other var
    })
  )

  lifecycle {
    create_before_destroy = true
  }
}

######################################################
## New Resource listener
######################################################

# Provides a Load Balancer Listener resource
resource "aws_lb_listener" "lb_listener" {
  # ARN of the load balancer.
  #load_balancer_arn = aws_lb.alb.arn 
  load_balancer_arn = aws_lb.alb.arn
  # Port on which the load balancer is listening. Not valid for Gateway Load Balancers.
  port              = "80"
  # Protocol for connections from clients to the load balancer. 
  # For Application Load Balancers, valid values are HTTP and HTTPS, with a default of HTTP. 
  # For Network Load Balancers, valid values are TCP, TLS, UDP, and TCP_UDP. 
  # Not valid to use UDP or TCP_UDP if dual-stack mode is enabled. Not valid for Gateway Load Balancers.
  protocol          = "HTTP"

  # Configuration block for default actions
  default_action {
    # ARN of the Target Group to which to route traffic. 
    # Specify only if type is forward and you want to route to a single target group. 
    # To route to one or more target groups, use a forward block instead.
    target_group_arn = var.aws_alb_target_group
    # Type of routing action. 
    # Valid values are forward, redirect, fixed-response, authenticate-cognito and authenticate-oidc.
    type             = "forward"
  }
}


# Manages a Route53 Hosted Zone. 
# For managing Domain Name System Security Extensions (DNSSEC), 
# see the aws_route53_key_signing_key 
# and aws_route53_hosted_zone_dnssec resources.
resource "aws_route53_zone" "main_domain_local" {

  # asign name - example: bestpractice.cloud.iberia.com
  name = join(".",[var.project, var.global_dns])  
}

# After you create a hosted zone for your domain, 
# such as example.com, you create records to tell 
# the Domain Name System (DNS) 
# how you want traffic to be routed for that domain.
# Provides a Route53 record resource. Other routing policies are configured similarly. 
# See AWS Route53 Developer Guide for details.
resource "aws_route53_record" "alb-record" {
  zone_id = aws_route53_zone.main_domain_local.zone_id
  # asign name - example: demo.development.bestpractice.cloud.iberia.com  
  name    = join(".",[var.service_name, var.environment, var.project, var.global_dns])
  
  # use an A record to route traffic to a resource, such as a web server, 
  # using an IPv4 address in dotted decimal notation. example: 192.0.2.1
  # see other type to https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/ResourceRecordTypes.html#AFormat
  type    = "A"
 
  alias {
    name                 = aws_lb.alb.dns_name
    zone_id              = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}