# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************

output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.alb.arn
}

output "aws_security_groups" {
  value = [aws_security_group.instances.id, data.aws_security_group.sg_common_microservices.id]
}

output "aws_subnets_ids" {
  value = [data.aws_subnet.snet_amber_eu_central_1a.id, data.aws_subnet.snet_amber_eu_central_1b.id, data.aws_subnet.snet_amber_eu_central_1c.id]
}

# Note of developer: verify this output
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}
