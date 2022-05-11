AWS EC2 Simple VPC module
---
This module create de simple vpc

**steps:**
* create aws ec2 vpc and create subneta, subnetb, subnetc for available zone in region
* this code create subnet in diference zone eu-center-1a, eu-center-1b, eu-center-1c
* create IAM role

**variable**
* aws_region:           "region of priveder"
>default: "us-east-1"
* project:              "The reference name project, use in vpc name"
* service_name:         "the service name"
* environment:          "The environment name to create vpc, use name in tag"
* environment_prefix:   "The environment prefix name to create vpc, use name in tag"
