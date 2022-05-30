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
  # set provice assume role: set stage in line command "terraform workspace new staging"
  # No credentials explicitly set here because they come from either the
  # environment or the global credentials file.

  # assume_role = {
  #  role_arn = "${var.workspace_iam_roles[terraform.workspace]}"
  # }

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
    self = true
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
    description = "From ${var.service_name} ALB"
    self = true
  }

  # inbound
  ingress {
    from_port      = 22
    to_port        = 22
    protocol       = "TCP"
    cidr_blocks      = ["10.200.177.169"] 
   #ipv6_cidr_blocks = ["::/0"]
  }

  ## outbound all traffic
  egress {
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
     # If your requirement is to allow all the traffic from internet you can use
    self = true
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

#####################################
### New commons resource
######################################

# # commons service access to-from microservice
# resource "aws_security_group" "sg-commons-microservices" {
#   # asign name: demo-alb-dev-sg
#   name        = join("-",[var.project, var.environment_prefix, "sg", "common", "microservice"])
#   description = "SG for common access to-from microservices"
#   vpc_id      = data.aws_vpc.vpc_product.id
#   ## outbound all traffic
#   egress {
#     from_port      = 0
#     to_port        = 0
#     protocol       = "-1"
#     prefix_list_ids = []
#      # If your requirement is to allow all the traffic from internet you can use
#     cidr_blocks      = ["0.0.0.0/0"] 
#     ipv6_cidr_blocks = ["::/0"]
#   }

# }


# # commons service access to-from microservice
# resource "aws_security_group" "sg-commons-microservices-alb" {
#   # asign name: demo-alb-dev-sg
#   name        = join("-", [var.project, var.environment_prefix, "sg", "common", "microservice","alb"])
#   description = "SG for common access to-from microservices ALBs"
#   vpc_id      = data.aws_vpc.vpc_product.id
#   ## outbound all traffic
#   egress {
#     from_port      = 8080
#     to_port        = 8080
#     protocol       = "tpc"
    
#   }

 
# }


##################################
# create private key for access 
# to instance in ssh from runner
# runner key need of private key
##################################
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = var.pem  # Create a "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "/opt/ssh/${aws_key_pair.kp.key_name}.pub"
  content = tls_private_key.pk.private_key_pem
}
