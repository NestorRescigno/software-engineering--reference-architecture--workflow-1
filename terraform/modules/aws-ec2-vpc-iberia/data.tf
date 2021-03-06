data "aws_region" "current" {}

# Determine all of the available availability zones in the
# current AWS region.
data "aws_availability_zones" "available" {

  state = "available"
}

# This additional data source determines some additional
# details about each VPC, including its suffix letter.
data "aws_availability_zone" "all" {
  for_each = toset(data.aws_availability_zones.available.names) 
  name = each.key
  # test
}
