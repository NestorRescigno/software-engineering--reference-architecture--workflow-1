############################
### create subnet in vpc 
### with aws availability zone
############################

# resource subnet
resource "aws_subnet" "subnets" {
  # interate array
  for_each                = data.aws_availability_zone.all
  # select vpc id
  vpc_id                  = var.aws_vpc_id
  # get key of item array
  availability_zone       = each.key

  # map ips public 
  map_public_ip_on_launch = var.hasPublicIpOnLaunch

  # set IP
  cidr_block              = cidrsubnet(var.cidr_block, var.hasPublicIpOnLaunch?4:3 , var.az_number[each.value.name_suffix])
  # set tag
  tags = merge({
      Name = join("-",[var.project,"snet", data.aws_region.current.name, each.value.name_suffix]),
      }, var.hasPublicIpOnLaunch?{Type = "public"}:{Type = "private"}  # Note of developer: test read var conditionla into map tag, find function terraform.
  )
}