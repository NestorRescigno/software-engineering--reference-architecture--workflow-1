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
      version = "~> 4.13"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  alias = "aws"
  region = var.aws_region
}


#####################################
### New commons resource
######################################

# commons service access to-from microservice
resource "aws_security_group" "sg-commons-microservices" {
  # asign name: demo-alb-dev-sg
  name        = join("-",[var.project, var.environment_prefix, "sg", "common", "microservice"])
  description = "SG for common access to-from microservices"

  ## outbound all traffic
  egress {
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
  
     # If your requirement is to allow all the traffic from internet you can use
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"]
  }

}


# commons service access to-from microservice
resource "aws_security_group" "sg-commons-microservices-alb" {
  # asign name: demo-alb-dev-sg
  name        = join("-", [var.project, var.environment_prefix, "sg", "common", "microservice","alb"])
  description = "SG for common access to-from microservices ALBs"

  ## outbound all traffic
  egress {
    from_port      = 8080
    to_port        = 8080
    protocol       = "tpc"
    cidr_blocks    = []
  }

 
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
    # security_groups = [ aws_security_group.instances.id ]
    # data.aws_vpc.vpc_product
  }

  # configure load balancer to instance
  egress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
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


# create segurity group by instance
resource "aws_security_group" "instances" {

  depends_on = [
    aws_security_group.alb
  ]

  # asign name: demo-instances-dev-sg
  name        = join("-",[var.service_name, "instances",var.environment_prefix,"sg"])
  description = "SG for ${var.service_name} cluster instances"
  vpc_id      = data.aws_vpc.vpc_product.id
  
  # inbound
  ingress {
    from_port       = 8080
    to_port         = 8080 
    protocol        = "tcp"
    security_groups = [ aws_security_group.alb.id ]
    description = "From ${var.service_name} ALB"
  }

  ## outbound all traffic
  egress {
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
     # If your requirement is to allow all the traffic from internet you can use
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    local.global_common_tags,
    tomap({
      Name = join("-",[var.service_name,"instances",var.environment_prefix,"sg"])
    })
  )

}

# #################################
# ### add endpoint
# #################################

resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = join(".",["com","amazonaws",var.aws_region, "ec2"])
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    data.aws_security_group.instances.id
  ]

  private_dns_enabled = true
}

# resource "aws_vpc_endpoint" "s3" {
#   vpc_id            = data.aws_vpc.vpc_product.id
#   service_name      = join(".",["com","amazonaws",var.aws_region, "s3"])
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     data.aws_security_group.alb.id, data.aws_security_group.instances.id
#   ]

#   private_dns_enabled = true
# }

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      =  join(".",["com","amazonaws",var.aws_region, "ec2messages"])
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    data.aws_security_group.instances.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = join(".",["com","amazonaws",var.aws_region, "ssm"])
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    data.aws_security_group.instances.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = data.aws_vpc.vpc_product.id
  service_name      = join(".",["com","amazonaws",var.aws_region, "ssmmessages"])
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    data.aws_security_group.instances.id
  ]

  private_dns_enabled = true
}