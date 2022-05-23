#########################
## VPC 
#########################

data "aws_vpc" "vpc_product" {
  tags = {
      Name = "${var.project}-${var.environment_prefix}"
  }
}

data "aws_iam_role" "role" {
   name = join("-", [var.project, var.environment, "role"])
}


# Determine all of the available availability zones in the
# current AWS region.
data "aws_availability_zones" "available" {

  state = "available"
}

# This additional data source determines some additional
# details about each VPC, including its suffix letter.
data "aws_availability_zone" "all" {
  for_each = toset(data.aws_availability_zones.available.names) 
  name = each.key
  # test
}

#######################
# Security default group
######################
data "aws_default_security_group" "default" {
  tags = {
    Name = "${var.service_name}-default-${var.environment_prefix}-sg"
  }
}

#######################
# VPC Endpoint 
#######################

data "aws_vpc_endpoint_service" "lambda" {
  service = "lambda"
}

##########################
data "aws_vpc_endpoint_service" "config" {
  service = "config"
}


data "aws_vpc_endpoint_service" "ssmmessages" {
  service = "ssmmessages"
}

data "aws_vpc_endpoint_service" "ssm" {
  service = "ssm"
}

data "aws_vpc_endpoint_service" "ec2" {
  service = "ec2"
}

data "aws_vpc_endpoint_service" "ec2messages" {
  service = "ec2messages"
}

data "aws_vpc_endpoint_service" "ec2_autoscaling" {
  service = "autoscaling"
}

data "aws_vpc_endpoint_service" "apigw" {
  service = "execute-api"
}

data "aws_vpc_endpoint_service" "kms" {
  service = "kms"
}

data "aws_vpc_endpoint_service" "ecs" {
  service = "ecs"
}

data "aws_vpc_endpoint_service" "ecs_agent" {
  service = "ecs-agent"
}

data "aws_vpc_endpoint_service" "monitoring" {
  service = "monitoring"
}

data "aws_vpc_endpoint_service" "logs" {
  service = "logs"
}

data "aws_vpc_endpoint_service" "events" {
  service = "events"
}

data "aws_vpc_endpoint_service" "elasticloadbalancing" {
  service = "elasticloadbalancing"
}

data "aws_vpc_endpoint_service" "codeartifact_api" {
  service = "codeartifact.api"
}

data "aws_vpc_endpoint_service" "codeartifact_repositories" {
  service = "codeartifact.repositories"
}

data "aws_vpc_endpoint_service" "ebs" {
  service = "ebs"
}

data "aws_vpc_endpoint_service" "auto_scaling_plans" {
  service = "autoscaling-plans"
}


