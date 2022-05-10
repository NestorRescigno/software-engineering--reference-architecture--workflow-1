# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************

# output id new ami
#output "ami_id" {
#  value = resource.aws_ami_from_instance.app_ami.id
#}

# output id new instance
output "instance_id" {
  value = [for s in aws_instance.app : s.id]
}

# NOTE OF DEVELOPERS: BOH! private or public, dns is necesary for test app.
output "instance_ip_addr" {
  value = [for s in aws_instance.app : s.private_dns]
}