

# Provides an EC2 instance resource
# create and configure instance aws 
# this run an bash form script template 'user_data.tftpl' at configure
resource "aws_instance" "app" {
    # AMI to use for the instance from generate example: ubuntu-xenial-20.08-amf64-server-**
    for_each                = toset(data.aws_subnets.snet_amber_eu_central_1_subnets.ids)
    ami                     = data.aws_ami.base_ami.id
    # launch_template {
    #   id      = aws_launch_template.launch.id
    #   # version = aws_launch_template.launch.last_version
    # }
  
    # The IAM Instance Profile to launch the instance with.
    iam_instance_profile    = data.aws_iam_instance_profile.iam_instance_profile.name

    instance_type           = var.instance_type
    # number launch
    # count                   = 1
    # VPC Subnet ID to launch in.
    subnet_id               = each.value # test with id because data not get id
    # A list of security grou[p IDs to associate with.
    vpc_security_group_ids  = [data.aws_security_group.instances.id] 


    # configure bash param to script template
    user_data               = templatefile("user_data.tftpl", {
        aws_region = "${var.aws_region}"
        department = "${var.user_departament}", 
        name = "${var.user_name}", 
        lenguage= "${var.lenguage_code}",
        artifact= "${var.ref}" , 
        package = "${var.package}" , 
        user   = "${var.artifact_user}",
        secret = "${var.artifact_secret}"
      })

    tags = {
        #Name = join("-",["i",var.service_name, var.service_version])
        Name = join("-",[var.service_name, var.environment_prefix]) # remove version un tag for service @ lastVersion
    }

    
  # destroy instance and reemplace with new configuration.  
  lifecycle { create_before_destroy = false }  
}

######################################################
# create loadbalancer and target group
#####################################################

module "loadbalancer" {
  source = "./loadbalancer"
}

module "targetgroup" {
  source = "./targetgroup"
}

######################################################
# attach target group ALB to Instance
#####################################################

resource "aws_lb_target_group_attachment" "albtogrouptarget" {
    for_each = aws_instance.app
    target_group_arn  = module.targetgroup.target_group_arn
    target_id         = aws_instance.app[each.key].id
    port              = 80
}