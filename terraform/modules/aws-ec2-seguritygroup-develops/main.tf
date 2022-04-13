# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

#####################################
### New resources ALB SG 
######################################
resource "aws_security_group" "anc-alb" {
  name        = "${var.service_name}-alb-${var.environment_prefix}-sg"
  description = "SG for ${var.service_name} cluster ALB"
  vpc_id      = data.aws_vpc.vpc-ancill.id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [data.aws_security_group.sg-svc-instances.id]
    description     = "From ${var.service_name} ALB"
  }
  tags = merge(
    local.global_common_tags,
    tomap({
      Name = "${var.service_name}-alb-${var.environment_prefix}-sg"
    })
  )
}

#####################################
### New resources ALB SG Instances 
######################################
resource "aws_security_group" "anc-instances" {
  depends_on = [
    aws_security_group.anc-alb
  ]
  name        = "${var.service_name}-instances-${var.environment_prefix}-sg"
  description = "SG for ${var.service_name} cluster instances"
  vpc_id      = data.aws_vpc.vpc-ancill.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.anc-alb.id]
    description = "From ${var.service_name} ALB"
  }

  tags = merge(
    local.global_common_tags,
    tomap({
      Name = "${var.service_name}-instances-${var.environment_prefix}-sg"
    })
  )
}
