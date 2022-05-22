

data "aws_caller_identity" "current" {}


##############################################
# security group default
##############################################

resource "aws_default_security_group" "default" {
  vpc_id = var.vpc_id

  ## inbound all traffic
  ingress {
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
     # If your requirement is to allow all the traffic from internet you can use
    security_groups = var.hasPrivateSubnet?[ aws_security_group.web_server_sg.id, aws_security_group.backend_server_sg.id, aws_security_group.db_server_sg.id ]:[ aws_security_group.web_server_sg.id ]
   }

  ## outbound all traffic
  egress {
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
     # If your requirement is to allow all the traffic from internet you can use
    security_groups = var.hasPrivateSubnet?[ aws_security_group.web_server_sg.id, aws_security_group.backend_server_sg.id, aws_security_group.db_server_sg.id ]:[ aws_security_group.web_server_sg.id ]
   }

   tags = merge(
    local.global_common_tags,
    # converts to map { Name = demo-alb-dev-sg}
    tomap({
      Name = join("-",[var.project, var.environment_prefix,"default", "sg"])
    })
  )
}



##########################################################################
### Segurity group web service on public subnet
###########################################################################

resource "aws_security_group" "web_server_sg" {

  name        = join("-",[var.project, var.environment_prefix, "web", "server", "sg"])
  description = "Security group web server in public subnet"
  vpc_id      = var.vpc_id
  
  tags = merge(
    local.global_common_tags,
    # converts to map { Name = demo-alb-dev-sg}
    tomap({
      Name = join("-",[var.project, var.environment_prefix, "web", "server", "sg"])
    })
  )

  ## inbound all traffic
  ingress {
    from_port      = 80
    to_port        = 80
    protocol       = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]    
  }
  ingress {
    from_port      = 443
    to_port        = 443
    protocol       = "TCP"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"]   
  }
  
  ingress {
    from_port      = 22
    to_port        = 22
    protocol       = "TCP"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"]   
  }
  
  ingress {
    from_port      = 3389
    to_port        = 3389
    protocol       = "TCP"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"]   
  }
  
  
  ## outbound all traffic
  egress {
    from_port      = 80
    to_port        = 80
    protocol       = "TCP"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"] 
  }

  egress {
    from_port      = 443
    to_port        = 443
    protocol       = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]  
  }

  egress {
    from_port      = 1433
    to_port        = 1433
    protocol       = "TCP"
    security_groups = [aws_security_group.db_server_sg.id]
  }

  egress {
    from_port      = 3306
    to_port        = 3306
    protocol       = "TCP"
    security_groups = [aws_security_group.db_server_sg.id]
  }  

    egress {
    from_port      = 8100
    to_port        = 8999
    protocol       = "TCP"
    security_groups = [aws_security_group.backend_server_sg.id]
  }
}


##########################################################################
### Segurity group web service on public subnet
###########################################################################

resource "aws_security_group" "backend_server_sg" {
  count       = var.hasPrivateSubnet?1:0 
  name        = join("-",[var.project, var.environment_prefix, "backend", "server", "sg"])
  description = "Security group bankend server in private subnet"
  vpc_id      = var.vpc_id
  
  tags = merge(
    local.global_common_tags,
    # converts to map { Name = demo-alb-dev-sg}
    tomap({
      Name = join("-",[var.project, var.environment_prefix, "backend", "server", "sg"])
    })
  )

  ## inbound all traffic
  ingress {
    from_port      = 8100
    to_port        = 8999
    protocol       = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]    
  }

  ingress {
    from_port      = 22
    to_port        = 22
    protocol       = "TCP"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"]   
  }
  
  ingress {
    from_port      = 3389
    to_port        = 3389
    protocol       = "TCP"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"]   
  }
  
  
  ## outbound all traffic
  egress {
    from_port      = 8100
    to_port        = 8999
    protocol       = "TCP"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"] 
  }

    
  ## outbound all traffic
  egress {
    from_port      = 80
    to_port        = 80
    protocol       = "TCP"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"] 
  }


  egress {
    from_port      = 1433
    to_port        = 1433
    protocol       = "TCP"
    security_groups = [aws_security_group.db_server_sg.id]
  }

  egress {
    from_port      = 3306
    to_port        = 3306
    protocol       = "TCP"
    security_groups = [aws_security_group.db_server_sg.id]
  }  


}



##########################################################################
### Segurity group db server on private subnet
###########################################################################

resource "aws_security_group" "db_server_sg" {
  count       = var.hasPrivateSubnet?1:0 
  name        = join("-",[var.project, var.environment_prefix, "db", "server", "sg"])
  description = "Security group db server in private subnet"
  vpc_id      =  var.vpc_id
  
  tags = merge(
    local.global_common_tags,
    # converts to map { Name = demo-alb-dev-sg}
    tomap({
      Name = join("-",[var.project, var.environment_prefix, "db", "server", "sg"])
    })
  )

  ## inbound all traffic
  ingress {
    from_port      = 1433
    to_port        = 1433
    protocol       = "TCP"
    security_groups = [aws_security_group.web_server_sg.id, aws_security_group.backend_server_sg]   
  }
  
  ingress {
    from_port      = 3389
    to_port        = 3389
    protocol       = "TCP"
    security_groups = [aws_security_group.web_server_sg.id, aws_security_group.backend_server_sg]  
  }
  
 
  ## outbound all traffic
  egress {
    from_port      = 8100
    to_port        = 8999
    protocol       = "TCP"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"] 
  }

  egress {
    from_port      = 80
    to_port        = 80
    protocol       = "TCP"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"] 
  }

  egress {
    from_port      = 443
    to_port        = 443
    protocol       = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]  
  }
}