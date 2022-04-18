# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************

# output id new ami
output "ami_id" {
  value = resource.aws_ami_from_instance.app_ami.id
}