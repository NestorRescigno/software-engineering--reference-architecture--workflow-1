# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************

# output id new instance
output "instance_ids" {
  value = [for s in aws_instance.app : s.id]
}

output "instance_id_zoneA" {
  value = values(aws_instance.app).1.id
}
