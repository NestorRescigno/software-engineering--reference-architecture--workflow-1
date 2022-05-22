# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************

# output id new instance
output "target_group_arn" {
  value = aws_alb_target_group.alb.arn
}
