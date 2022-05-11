data "aws_region" "current" {}

# Determine all of the available availability zones in the
# current AWS region.
data "aws_availability_zones" "available" {
  all_availability_zones = true
  state = "available"
}

# This additional data source determines some additional
# details about each VPC, including its suffix letter.
data "aws_availability_zone" "all" {
  for_each = data.aws_availability_zones.available.all
  name = each.key
  # test
}
