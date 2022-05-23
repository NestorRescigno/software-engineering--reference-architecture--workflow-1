# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************

# output id new instance
output "instance_ids" {
  value = toset([for s in aws_instance.app : s.id])
}


output "instance_ips" {
  value = toset([for s in aws_instance.app : s.*.private_ip])
}

# output "instance_id_zoneA" {
#   value = values(aws_instance.app).1.id

#   [for s in aws_instance.app : s.id]
# }
