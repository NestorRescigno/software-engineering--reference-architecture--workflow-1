AWS EC2 Deploy Module
----
This module allows you to deploy an aws image with template_lanch.

**steps:**
* create aws autoscaling group
* launch template with image 
* asigne AIM and create tag especification for instance and volume
* deploy

**variable**

* ami_id:                   "aws magine image id"
* version:                  "Version ID"
* service_groupid:          "The name of groupid application service."
* service_name:             "The name of the service to be created"
* aws_region:               "Region"
* project:                  "Project"
* instance_type:            "type of instance up" 
> default: "t2.micro"
* environment:              "Environment name"
* environment_prefix:       "Environment Prefix."
* global_dns:               "Main domain dns default: "
> default: "cloud.iberia.local"
* bucket_name:              "bucket aws name."
* bucket_key:               "bucket aws key."
* dynamodb_table:           "dynamo db table."
* kms_key_id:               "kms key id."
* role_arn:                 "aws role aim arn."
* aws_alb_target_group_arn: "aws loadbalancer target group arn"
