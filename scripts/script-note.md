# the scripts shell use direct or inderect next clients commands

Action sonarQube
----
Action sonarQube use binary script from next site 
````
https://binaries.sonarsource.com/?prefix=Distribution/sonar-scanner-cli/
````
Build image
-----

boh!

HashiCorp [Packer](https://learn.hashicorp.com/collections/packer/aws-get-started) automates the creation of any type of machine image, including AWS AMIs. You'll build an Ubuntu machine image on AWS in this tutorial.

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

action checkout 
----
action checkout use simple git with diferente stage.
value:
* this.tokenPlaceholderConfigValue = `AUTHORIZATION: basic ***`
* this.tokenConfigValue = `AUTHORIZATION: basic ${basicCredential}`

command:
- this settings with persist credentials
git config --local '${this.tokenConfigKey}' '${this.tokenPlaceholderConfigValue}' 
git config --local --show-origin --name-only --get-regexp remote.origin.url`,
- this settings ssh Key
git config --local '${SSH_COMMAND_KEY}' '${this.sshCommand}
- this configure HTTPS instead of SSH
git config --local --add '${this.insteadOfKey}' '${insteadOfValue}
- this git submodule Foreach
git config --local --name-only --get-regexp '${pattern}'
git config --local --unset-all '${configKey}'


for use codeartifact to write package

Example publish with curl.
´´´´
        # Adapter variable:
        # 1 - remove substring snapshot on version because codeartifact can't accept snapshot word
        VERSIONTEMP=${VERSION%-SNAPSHOT}
        # 2 - reemplace point to slash in groupid for it use on path uri
        oldstr="\."
        newstr="\/"
        GROUPID=$(echo $GROUP | sed "s/$oldstr/$newstr/g")
        echo $GROUPID
        
        echo $SNAPSHOTS_REPOSITORY_URL$GROUPID/$ARTIFACTID/${VERSIONTEMP}/$VERSION
        curl --request PUT $SNAPSHOTS_REPOSITORY_URL$GROUPID/$ARTIFACTID/${VERSIONTEMP}/$VERSION \
        --user "aws:${CODEARTIFACT_AUTH_TOKEN}" --header "Content-Type: application/octet-stream" \
        --data-binary "@target/$ARTIFACTID-$VERSION.$PACKAGE_TYPE"
´´´´
