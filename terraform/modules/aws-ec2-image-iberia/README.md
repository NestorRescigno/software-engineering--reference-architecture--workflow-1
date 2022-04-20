AWS EC2 create image module from ec2 instance
---
This module allows you to create an aws image from ec2 instance.

**steps:**
* create image from instance: tag name of image start with "ms-" (microservice) or "web-" (angular application) continous with "{project name}-{service name}-{service version}-{date format: YYMMMDDhhmmss}"


**variable**
* aws_region:               "region of priveder"
>default: "us-east-1"
* service_name:             "The name of service"
* service_version:          "The version of service"
* project_name:             "The name of project"
* segurity_group:           "The segurity group to deploy"
* source_instance_id:       "The instance ec2 id from create image"

**output**
* instance_id: "aws instance id"
>  