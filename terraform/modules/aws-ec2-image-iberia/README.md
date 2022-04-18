AWS EC2 build image module
---
This module allows you to create an aws image from a base image.

**steps:**
* create aws ami form ubuntu image base
````
ubuntu/image/hvm-ssd/ubuntu-xenial-20.08-amf64-server-**
````
* instance image and run script template [user_data.tftpl](https://github.com/Iberia-Ent/software-engineering--reference-architecture--workflow/blob/main/terraform/modules/aws-ec2-image-iberia/user_data.tftpl)
* create image from instance: name started image is "ms_" (microservice) or "web_" (angular application)



