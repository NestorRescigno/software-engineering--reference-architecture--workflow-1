# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************


###########################
### Provider
###########################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.29" # chnage version because the data zone isn't available after version.
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  alias = "aws"
  region = var.aws_region
}

########################################################################################
# VPC Endpoint connect vpc with other vpc or service aws
########################################################################################
##############################################
# Securización del Security group por defecto
##############################################

resource "aws_default_security_group" "default" {
  vpc_id = data.aws_vpc.vpc_product.id


  ingress {
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"]
  }

 ## outbound all traffic
  egress {
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
     # If your requirement is to allow all the traffic from internet you can use
    security_groups = [ data.aws_security_group.alb.id, data.aws_security_group.instances.id ]
   }

   tags = merge(
    local.global_common_tags,
    # converts to map { Name = demo-alb-dev-sg}
    tomap({
      Name = join("-",[var.service_name,"default",var.environment_prefix,"sg"])
    })
  )
}



##########################
# VPC Endpoint for Config
##########################
resource "aws_vpc_endpoint" "config" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.config.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids = data.aws_subnets.snet_amber_eu_central_1_subnets.ids

  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true

  tags = merge(var.common_tags, tomap({ "Name" = "config-${local.data.vpc.vpc_product}-endpoint" }))
}


#########################
# VPC Endpoint for Lambda

resource "aws_vpc_endpoint" "lambda" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.lambda.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids =  data.aws_subnets.snet_amber_eu_central_1_subnets.ids
  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true
  tags = merge(var.common_tags, tomap({ "Name" = "lambda-${local.data.vpc.vpc_product}-endpoint" }))
}


#######################
# VPC Endpoint for SSM
#######################
resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.ssm.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids =  data.aws_subnets.snet_amber_eu_central_1_subnets.ids

  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true
  tags                = merge(var.common_tags, tomap({ "Name" = "ssm-${local.data.vpc.vpc_product}-endpoint" }))
}

###############################
# VPC Endpoint for SSMMESSAGES
###############################
resource "aws_vpc_endpoint" "ssmmessages" {

  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.ssmmessages.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids = data.aws_subnets.snet_amber_eu_central_1_subnets.ids
  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true
  tags                = merge(var.common_tags, tomap({ "Name" = "ssmmessages-${local.data.vpc.vpc_product}-endpoint" }))
}

#######################
# VPC Endpoint for EC2
#######################
resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.ec2.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids = data.aws_subnets.snet_amber_eu_central_1_subnets.ids
  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true
  tags                = merge(var.common_tags, tomap({ "Name" = "ec2-${local.data.vpc.vpc_product}-endpoint" }))
}


resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.ec2messages.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids = data.aws_subnets.snet_amber_eu_central_1_subnets.ids

  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true
  tags                = merge(var.common_tags, tomap({ "Name" = "ec2messages-${local.data.vpc.vpc_product}-endpoint" }))
}

###############################
# VPC Endpoint for EC2 Autoscaling
###############################

resource "aws_vpc_endpoint" "ec2_autoscaling" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.ec2_autoscaling.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids =  data.aws_subnets.snet_amber_eu_central_1_subnets.ids
  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true
  tags                = merge(var.common_tags, tomap({ "Name" = "autoscaling-${local.data.vpc.vpc_product}-endpoint" }))
}



#######################
# VPC Endpoint for API Gateway
#######################
resource "aws_vpc_endpoint" "apigw" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.apigw.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids =  data.aws_subnets.snet_amber_eu_central_1_subnets.ids
 
  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true
  tags                = merge(var.common_tags, tomap({ "Name" = "execute-api-${local.data.vpc.vpc_product}-endpoint" }))
}

#######################
# VPC Endpoint for KMS
#######################
resource "aws_vpc_endpoint" "kms" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.kms.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids =  data.aws_subnets.snet_amber_eu_central_1_subnets.ids

  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true
  tags                = merge(var.common_tags, tomap({ "Name" = "kms-${local.data.vpc.vpc_product}-endpoint" }))
}

#######################
# VPC Endpoint for ECS
#######################

resource "aws_vpc_endpoint" "ecs" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.ecs.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids =  data.aws_subnets.snet_amber_eu_central_1_subnets.ids
  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true
  tags                = merge(var.common_tags, tomap({ "Name" = "ecs-${local.data.vpc.vpc_product}-endpoint" }))
}


#######################
# VPC Endpoint for ECS Agent
#######################
resource "aws_vpc_endpoint" "ecs_agent" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.ecs_agent.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids =  data.aws_subnets.snet_amber_eu_central_1_subnets.ids

  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true
  tags                = merge(var.common_tags, tomap({ "Name" = "ecs-agent-${local.data.vpc.vpc_product}-endpoint" }))
}




#######################
# VPC Endpoint for CloudWatch Monitoring
#######################
resource "aws_vpc_endpoint" "monitoring" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.monitoring.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids = data.aws_subnets.snet_amber_eu_central_1_subnets.ids

  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true
  tags                = merge(var.common_tags, tomap({ "Name" = "monitoring-${local.data.vpc.vpc_product}-endpoint" }))
}


#######################
# VPC Endpoint for CloudWatch Logs
#######################

resource "aws_vpc_endpoint" "logs" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.logs.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids =  data.aws_subnets.snet_amber_eu_central_1_subnets.ids
  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true
  tags                = merge(var.common_tags, tomap({ "Name" = "logs-${local.data.vpc.vpc_product}-endpoint" }))
}


#######################
# VPC Endpoint for CloudWatch Events
#######################
resource "aws_vpc_endpoint" "events" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.events.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids =  data.aws_subnets.snet_amber_eu_central_1_subnets.ids
  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true
  tags                = merge(var.common_tags, tomap({ "Name" = "events-${local.data.vpc.vpc_product}-endpoint" }))
}


#######################
# VPC Endpoint for Elastic Load Balancing

resource "aws_vpc_endpoint" "elasticloadbalancing" {

  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.elasticloadbalancing.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids =  data.aws_subnets.snet_amber_eu_central_1_subnets.ids
  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true
  tags                = merge(var.common_tags, tomap({ "Name" = "elasticloadbalancing-${local.data.vpc.vpc_product}-endpoint" }))
}



#######################
# VPC Endpoint for Auto Scaling Plans
#######################
resource "aws_vpc_endpoint" "auto_scaling_plans" {

  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.auto_scaling_plans.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids =  data.aws_subnets.snet_amber_eu_central_1_subnets.ids
  security_group_ids  = [aws_default_security_group.default.id]


  tags = merge(var.common_tags, tomap({ "Name" = "autoscaling-plans-${local.data.vpc.vpc_product}-endpoint" }))
}



#######################
# VPC Endpoint for EBS
#######################
resource "aws_vpc_endpoint" "ebs" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.ebs.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids =  data.aws_subnets.snet_amber_eu_central_1_subnets.ids
  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true

  tags = merge(var.common_tags, tomap({ "Name" = "ebs-${local.data.vpc.vpc_product}-endpoint" }))
}



#############################################
# VPC Endpoint for Codeartifact API
#############################################


resource "aws_vpc_endpoint" "codeartifact_api" {

  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.codeartifact_api.service_name
  vpc_endpoint_type = "Interface"
 # subnet_ids = data.aws_subnets.snet_amber_eu_central_1_subnets.ids
  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true

  tags = merge(var.common_tags, tomap({ "Name" = "codeartifact-api-${local.data.vpc.vpc_product}-endpoint" }))
}


resource "aws_vpc_endpoint" "codeartifact_repositories" {

  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = data.aws_vpc_endpoint_service.codeartifact_repositories.service_name
  vpc_endpoint_type = "Interface"
 # subnet_ids =  data.aws_subnets.snet_amber_eu_central_1_subnets.ids
  security_group_ids  = [aws_default_security_group.default.id]
  private_dns_enabled = true

  tags = merge(var.common_tags, tomap({ "Name" = "codeartifact-repo-${local.data.vpc.vpc_product}-endpoint" }))
}



