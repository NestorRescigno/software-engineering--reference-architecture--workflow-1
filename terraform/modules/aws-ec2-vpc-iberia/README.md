AWS EC2 VPC Module
----
The vpc module creates the entire infrastructure of an amazon virtual private network on EC2 with 3 subnets (blue, green, amber)
set segurity group, domain, load balancer, target group, etc.

> The module doesn't currently create a private subnet for the data models connected by tcp to the subnets of the application server

> The provider has configured the backet S3 where it will host the logs

It is possible to implement the module in a parent module to use the vpn creation in other infrastructure processes by code. more information with [modules](https://www.terraform.io/language/modules/syntax)

````
module "vpc" {
  source = "./terraform/modules/aws-ec2-vpc-iberia"
  
  ....
}
````

or configure the variables for use directly through the tfvars file

````
## Global variables
service_name       = "<service name>"
environment_prefix = "<environment prefix name>"
project            = "<project name>"                     # this name is present in domain
environment        = "<enviroment name>"
aws_region         = "<regione name>"                     # default: "eu-central-1"
global_dns         = "<domain>"                           # default: "cloud.iberia.local"
bucket_name        = "<bucket name>"                      # set s3 backet for log
bucket_key         = "<bucket key>"                       # set s3 backet for log
dynamodb_table     = "<dynamo db>"
kms_key_id         = "<kms id>" 
role_arn           = "<regione name>"                     # AIM role aws
````

**outputs**
* aws_alb_target_group_arn:  "loadbalancer group target arn" 
* aws_security_groups:       "security groups ids"
* aws_subnets_ids:           "subnets ids"