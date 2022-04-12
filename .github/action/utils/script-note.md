# the scripts shell use direct or inderect next clients commands

Action sonarQube
----
Action sonarQube use binary script from next site 
````
https://binaries.sonarsource.com/?prefix=Distribution/sonar-scanner-cli/
````
Build image
-----

HashiCorp [Packer](https://learn.hashicorp.com/collections/packer/aws-get-started) automates the creation of any type of machine image, including AWS AMIs. You'll build an Ubuntu machine image on AWS in this tutorial.
script packer (may be change) 

>use ami base to create new ami - standar aws producedure - this ami is shared with other account.
````
iaggbs-shared-amzn2-base-arm64-v2.2.0-*
ami-07544e2d119d2361f	
account aws "shared-services"
````
> usage [reference amazon](https://docs.aws.amazon.com/cli/latest/reference/ec2/copy-image.html) 
**Example:** To copy an AMI to another Region and encrypt the backing snapshot
The following copy-image command copies the specified AMI from the us-west-2 Region to the current Region and encrypts the backing snapshot using the specified KMS key.
````
aws ec2 copy-image \
    --source-region us-west-2 \
    --name ami-name \
    --source-image-id ami-066877671789bd71b \
    --encrypted \
    --kms-key-id alias/my-kms-key
````
Output:
````
{
    "ImageId": "ami-066877671789bd71b"
}
````
