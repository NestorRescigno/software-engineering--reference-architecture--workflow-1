AWS EC2 instance up module
---
This module allows you to up an aws instance from a base image. use sharedlinux

**steps:**
* create aws ami form lasted shared linux image base ( for change image is necesary modify datasource in https://github.com/Iberia-Ent/software-engineering--reference-architecture--workflow/blob/main/terraform/modules/aws-ec2-instance-iberia/data.tf). use de filter for query image.

````
# #########################
# ## data source base ami
# #########################
# 
data "aws_ami" "base_ami" {
    
    most_recent = true
    owners = ["self"]

    filter {
      name   = "name"
      values = ["iaggbs-shared-amzn2-base-arm64-v2.2.0-*"]
    }
    
  #  filter {
  #    name  = "virtualization - type"
  #    value = ["hvm"]
  #  }

}
````
* instance image and run script template [user_data.tftpl](https://github.com/Iberia-Ent/software-engineering--reference-architecture--workflow/blob/main/terraform/modules/aws-ec2-image-iberia/user_data.tftpl)
* create load balancer , segurity group, traffic route53,  template launch.

**variable**
* aws_region:           "region of priveder"
>default: "us-east-1"
* user_name:            "The user creating this infrastructure"   
>default: "ec2-user"
* user_departament:     "The organization the user belongs to: dev, prod, qa"
>default: "dev"
* instance_type:        "The instance aws type"
* lenguage_code:        "lenguage code origin for example java, angular , go , etc."
> default:              "t4g.micro"
> t2.micro reduce cost: 1 Gb RAM and 1 CPU. [see more type](https://aws.amazon.com/ec2/instance-types/)  
* ref:                  "The reference register artifact"
* package :             "The reference type of package artifact. example: jar"
* artifact_user:        "The user access to read register artifact. example: Nexus"
* artifact_secret:      "The secret key access to read register artifact. example: Nexus"
* security_group:       "The security group to deploy"
* subnet_target:        "The subnet id target to deploy ec2 instance"

**Other configuration**

To allow cloudwatch to retrieve the metrics from the instance, it is necessary to install the agent. This agent requires a manual configuration of the json. the json file must be hosted in the instance and parameterized by service. see [config Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html)
