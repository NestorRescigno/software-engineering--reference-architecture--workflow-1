# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************


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
  vpc_id               = data.aws_vpc.vpc_product.id
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
}


###########################
## New Resource listener
###########################

# Provides a Load Balancer Listener resource
resource "aws_lb_listener" "lb_listener" {
  # ARN of the load balancer.
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
    target_group_arn = aws_alb_target_group.alb.arn
    # Type of routing action. 
    # Valid values are forward, redirect, fixed-response, authenticate-cognito and authenticate-oidc.
    type             = "forward"
  }
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
  security_groups = [aws_security_group.alb.id, data.aws_security_group.sg_common_microservices_alb.id]
  
  # A list of subnet IDs to attach to the LB. 
  # Subnets cannot be updated for Load Balancers of type network. 
  # Changing this value for load balancers of type network will force a recreation of the resource.
  subnets         = [data.aws_subnet.snet_amber_eu_central_1a.id, data.aws_subnet.snet_amber_eu_central_1b.id, data.aws_subnet.snet_amber_eu_central_1c.id]
  
  # If true, deletion of the load balancer will be disabled via the AWS API. 
  # This will prevent Terraform from deleting the load balancer. Defaults to false.
  enable_deletion_protection = false

  # An Access Logs block. Access Logs documented below.
  access_logs {
    # The S3 bucket name to store the logs in. example dev-alb-logs
    bucket  = join("-",[var.environment_prefix,"alb","logs"])
    
    # The S3 bucket prefix. Logs are stored in the root if not configured. example: dev-demo-ap-lb
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
      Project                  = "${var.project}"
      Environment              = "${var.environment}"
      Cluster                  = "${local.cluster_name}"
      "tf:Used"                = "True"
      "Application:ArtifactId" = join("-",[var.service_name,"core"])      
      "Application:GroupId"    = "${var.service_groupid}"   # Note of develops: use other var
    })
  )
}

#####################################
### New resources ALB SG 
######################################

# Provides a security group resource for cluster ALB

resource "aws_security_group" "alb" {

  # asign name: demo-alb-dev-sg
  name        = join("-",[var.service_name,"alb",var.environment_prefix,"sg"])
  description = "SG for ${var.service_name} cluster ALB"
  
  # asign vpc id to apply security group 
  vpc_id      = data.aws_vpc.vpc_product.id

  # Configuration block for ingress rules. 
  # Can be specified multiple times for each ingress rule. 
  # Each ingress block supports fields documented below. 
  # This argument is processed in attribute-as-blocks mode.
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [ data.aws_security_group.sg_instances.id ]
    description     = "From ${var.service_name} ALB"
  }

  # asign tag use marge takes an arbitrary number of maps or objects, 
  # and returns a single map or object that contains 
  # a merged set of elements from all arguments.
  # tag:{
  #    Project = "bestpractice"
  #    Name = "demo-alb-dev-sg"
  #    Environment = "developer"
  #    Cluster = "demo"
  #    Side = "demo"
  #    "tf:Used"                = "True"
  #    "Application:ArtifactId" = "demo-core"      
  # }
  tags = merge(
    local.global_common_tags,
    # converts to map { Name = demo-alb-dev-sg}
    tomap({
      Name = join("-",[var.service_name,"alb",var.environment_prefix,"sg"])
    })
  )
}

resource "aws_security_group" "instances" {

  depends_on = [
    aws_security_group.alb
  ]

  # asign name: demo-instances-dev-sg
  name        = join("-",[var.service_name,"instances",var.environment_prefix,"sg"])
  description = "SG for ${var.service_name} cluster instances"
  vpc_id      = data.aws_vpc.vpc_product.id

  ingress {
    from_port       = 8080
    to_port         = 8080     
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description = "From ${var.service_name} ALB"
  }

  tags = merge(
    local.global_common_tags,
    tomap({
      Name = join("-",[var.service_name,"instances",var.environment_prefix,"sg"])
    })
  )
}

###########################
## New resource Route53 
###########################

# Manages a Route53 Hosted Zone. 
# For managing Domain Name System Security Extensions (DNSSEC), 
# see the aws_route53_key_signing_key 
# and aws_route53_hosted_zone_dnssec resources.
resource "aws_route53_zone" "main_domain_local" {

  # asign name - example: bestpractice.cloud.iberia.com
  name = join(".",[var.project,var.global_dns])  
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
  name    = join(".",[var.service_name, var.environment, var.project. var.global_dns])
  
  # use an A record to route traffic to a resource, such as a web server, 
  # using an IPv4 address in dotted decimal notation. example: 192.0.2.1
  # see other type to https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/ResourceRecordTypes.html#AFormat
  type    = "A"
 
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

# Modified blue record to new ALB endpoint
resource "aws_route53_record" "blue-record" {
  zone_id = aws_route53_zone.main_domain_local.zone_id

  # asign name - example: demo.blue.development.bestpractice.cloud.iberia.com 
  name    = join(".",[var.service_name, "blue",var.environment, var.project. var.global_dns])
  type    = "A"
  allow_overwrite = true
 
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}

# Modified green record to new ALB endpoint
resource "aws_route53_record" "green-record" {
  zone_id = aws_route53_zone.main_domain_local.zone_id
  
  # asign name - example: demo.green.development.bestpractice.cloud.iberia.com 
  name    = join(".",[var.service_name, "green",var.environment, var.project. var.global_dns])
  type    = "A"
  allow_overwrite = true
 
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}

# ##############################
# ## IAM Instance profile Role
# ##############################

resource "aws_iam_instance_profile" "service" {
  name = "${var.service_name}-instanceprofile-${var.environment_prefix}"
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
# NOTE OF DEVELOPERS :resource module VPC and subnet (I fail! remove!!) 
