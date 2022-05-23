# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************

# Module create build image in EC2 aws

# Define provider aws
# provider "aws" {
#  project     = var.project_name
#  access_key  = var.access_key
#  region      = var.availability_zone_name
#  secret_key  = var.secret_key
# }

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

  lifecycle {
    create_before_destroy = true
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
  # security_groups = [aws_security_group.alb.id, data.aws_security_group.sg_common_microservices_alb.id]
  security_groups = [data.aws_security_group.alb.id]

  # A list of subnet IDs to attach to the LB. 
  # Subnets cannot be updated for Load Balancers of type network. 
  # Changing this value for load balancers of type network will force a recreation of the resource.
  subnets         = [data.aws_subnet.snet_amber_eu_central_1a.id, data.aws_subnet.snet_amber_eu_central_1b.id, data.aws_subnet.snet_amber_eu_central_1c.id]
  
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
    target_group_arn = aws_alb_target_group.alb.arn
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


################################
### New Resource launch Template
################################

# Provides an EC2 launch template resource. 
# Can be used to create instances or auto scaling groups.
# Note of developer: use lanch template with script 
# resource "aws_launch_template" "launch" { 
  
#   # Decision Server launch template
  
#   name          = format("lt-%s-${var.service_name}", var.environment_prefix)
#   image_id      = data.aws_ami.base_ami.id
#   instance_type = local.instance_type
#   vpc_security_group_ids = [aws_security_group.alb.id, aws_security_group.instances.id] 
  
#   # monitoring enabled
#   monitoring {
#     enabled = true
#   }



#   # The IAM Instance Profile to launch the instance with.
#   iam_instance_profile {
#     name = data.aws_iam_instance_profile.ip.name
#   }

#   # The tags to apply to the resources during launch. 
#   tag_specifications {
#     resource_type = "instance"
#     tags = merge(
#       local.global_common_tags,
#       tomap({ 
#         #AWSInspector = "True",
#         Version = "${var.service_version}"
#       })
#     )
#   }

#   tag_specifications {
#     resource_type = "volume"
#     tags = merge(
#       local.global_common_tags,
#       tomap({
#         Name    = "${var.environment_prefix}",
#         Version = "${var.service_version}"
#       })
#     )
#   }

#   # configure bash param to script template
#   user_data  = base64encode(templatefile("user_data.tftpl", {
#     department = "${var.user_departament}", 
#     name = "${var.user_name}", 
#     lenguage= "${var.lenguage_code}",
#     artifact= "${var.ref}" , 
#     package = "${var.package}" , 
#     user   = "${var.artifact_user}",
#     secret = "${var.artifact_secret}"
#   }))

#   tags = merge(
#     local.global_common_tags,
#     tomap({
#       Name ="${var.environment_prefix}"
#     })
#   )

  
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# Provides an EC2 instance resource
# create and configure instance aws 
# this run an bash form script template 'user_data.tftpl' at configure
resource "aws_instance" "app" {
    # AMI to use for the instance from generate example: ubuntu-xenial-20.08-amf64-server-**
    for_each                = toset(data.aws_subnets.snet_amber_eu_central_1_subnets.ids)
    ami                     = data.aws_ami.base_ami.id
    # launch_template {
    #   id      = aws_launch_template.launch.id
    #   # version = aws_launch_template.launch.last_version
    # }
  
    # The IAM Instance Profile to launch the instance with.
    iam_instance_profile    = data.aws_iam_instance_profile.iam_instance_profile.name

    # key pair name 
    key_name                = var.pem
    instance_type           = var.instance_type
    # number launch
    # count                   = 1
    # VPC Subnet ID to launch in.
    subnet_id               = each.value # test with id because data not get id
    # A list of security grou[p IDs to associate with.
    vpc_security_group_ids  = [data.aws_security_group.instances.id] 

    # configure bash param to script template
    user_data               = templatefile("user_data.tftpl", {
        aws_region = "${var.aws_region}"
        department = "${var.user_departament}", 
        name = "${var.user_name}", 
        lenguage= "${var.lenguage_code}",
        artifact= "${var.ref}" , 
        package = "${var.package}" , 
        user   = "${var.artifact_user}",
        secret = "${var.artifact_secret}"
      })

    tags = {
        #Name = join("-",["i",var.service_name, var.service_version])
        Name = join("-",[var.service_name, var.environment_prefix]) # remove version un tag for service @ lastVersion
    }

    
  # destroy instance and reemplace with new configuration.  
  lifecycle { create_before_destroy = false }  
}

# #################################
# ### create private key
# #################################
# resource "tls_private_key" "pk" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "kp" {
#   key_name   = "myKey"       # Create a "myKey" to AWS!!
#   public_key = tls_private_key.pk.public_key_openssh
# }

# resource "local_file" "ssh_key" {
#   filename = "${aws_key_pair.kp.key_name}.pem"
#   content = tls_private_key.pk.private_key_pem
# }



######################################################
# attach target group ALB to Instance
#####################################################

resource "aws_lb_target_group_attachment" "albtogrouptarget" {
    for_each = aws_instance.app
    target_group_arn  = aws_alb_target_group.alb.arn
    target_id         = aws_instance.app[each.key].id
    port              = 80

}


