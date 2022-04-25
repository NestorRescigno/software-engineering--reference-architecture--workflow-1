# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************

output "aws_alb_target_group_arn" {
  value = var.aws_alb_target_group_arn
}

output "aws_autoscaling_group_name" {
  value = aws_autoscaling_group.asg.name
}

output "aws_autoscaling_policy_arn_cpu" {
  value = aws_autoscaling_policy.cpu.arn
}

