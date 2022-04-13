################################
### New Resource launch Template
################################
resource "aws_launch_template" "anc" { // Decision Server launch template
  name          = format("lt-%s-${var.service_name}", var.environment_prefix)
  image_id      = var.anc_ins_ami_id
  instance_type = local.anc_instance_type
  vpc_security_group_ids = [aws_security_group.anc-instances.id, data.aws_security_group.sg-common-microservices.id]
  user_data              = filebase64("files/int_env.sh")
  iam_instance_profile {
    name = data.aws_iam_instance_profile.ip-ancill.name
  }
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      local.global_common_tags,
      tomap({ #AWSInspector = "True",
        Version = var.anc_ins_version
      })
    )
  }
  tag_specifications {
    resource_type = "volume"
    tags = merge(
      local.global_common_tags,
      tomap({
        Name    = "${var.environment_prefix}",
        Version = var.anc_ins_version
        # "Name", format("lt-%s-${var.service_name}", var.environment_prefix),
        # "BackupDaily", "true",
      })
    )
  }
  tags = merge(
    local.global_common_tags,
    tomap({
      Name = "${var.environment_prefix}"
      # "Name", format("lt-%s-${var.service_name}", var.environment_prefix),
      # "BackupDaily", "true",
    })
  )
}


# not implement module in main core - working progress
