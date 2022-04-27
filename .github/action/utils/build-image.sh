#!/bin/bash
# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
#
# This script performs the action of creating an instance 
# from a base image for a vpc as a operational environment 
# when it executes a pull request on the main branch. 
# the action of creating an instance and generating an image.

     
# USER_NAME           = $1
# USER_DEPARTAMENT    = $2


# INSTANCE_TYPE     = $3

LANGUAGE            = ${{ env.LANGUAGE }}

# artifact param
GROUP               = ${{ env.GROUP }}     
ARTIFACT            = ${{ env.ARTIFACT }} 
VERSION             = ${{ env.VERSION }} 
PACKAGE             = ${{ env.PACKAGE}}

# get artifact image of differente type for lenguage
CODEARTIFACT        = ${{ env.CODEARTIFACT }}                    # active download artifact form aws codeartifact
HOST                = ${{ env.REPOSITORY_HOST }} 
OWNER               = ${{ env.REPOSITORY_OWNER }}    
USER                = ${{ env.REPOSITORY_USER }} 
SECRET              = ${{ env.REPOSITORY_SECRET }}
REPOSITORY          = ${{ env.REPOSITORY_PATH }} 


# product name      
PROJECT             = ${{ env.PROJECT }}

# repository reference
workspace           = ${{ github.workspace }}
REF                 = ${{ github.ref }}

SG                  = ${{ env.SECURITY_GROUPS }}      
SUBNET              = ${{ env.SUBNETS }}      
SHARED              = ${{ env.SHARED }}

# access key cloud
aws_access_key_op          = ${{ env.AWS_ACCESS_KEY_OP }}
aws_access_key_op          = ${{ env.AWS_SECRETE_ACCESS_KEY_OP }} 

# access enviroment profile 
aws-profile                = ${{ env.AWS_PROFILE }}

#################################
# create uri artifact reference 
################################
if [${LANGUAGE}=="java"] then
   FORMAT= "maven"  
else
   FORMAT= "npm"
fi

# example uri aws
if [ ${CODEARTIFACT}==true] then    
     # GET /v1/package/version/asset?asset=asset&domain=domain&domain-owner=domainOwner&format=format&namespace=namespace&package=package&repository=repository&revision=packageVersionRevision&version=packageVersion HTTP/1.1
     
     ARTIFACTREF = "https://${HOST}/v1/package/version/asset?asset=asset&domain=${PROJECT}&domain-owner=${OWNER}&format=${FORMAT}&namespace=${GROUP}&package=${ARTIFACT}&repository=${REPOSITORY}&version=${VERSION} HTTP/1.1"
else
     ARTIFACTREF = "https://${HOST}/nexus/service/local/artifact/maven/redirect?r=${REPOSITORY}&g=${GROUP}&a=${ARTIFACT}&v=${VERSION}&p=${PACKAGE}" 
fi

# pull request to develop event create instance in aws but it don't registry image of snapshot
echo "***************************************************"
echo "Creating image"
echo "***************************************************"

if [${aws-profile} != "" ] then
     echo "****************************************"
     echo "**  profile connect: ${aws-profile}   **"
     echo "****************************************"
     export AWS_PROFILE= ${aws-profile}
else
     # configure operational account, generate image and shared with instance       
     . could-configure.sh "aws" ${aws_access_key_op} ${aws_secret_access_key_op }  
fi

# init terraform module
cd ${workspace}/terraform/module/aws-ec2-instance-iberia
terraform init

# create plan terrafom
terraform plan 
     -var "lenguage_code=${LANGUAGE}"
     -var "instance_type=${INSTANCE_TYPE}" 
     -var "ref=${ARTIFACTREF}" 
     -var "package=${PACKAGE}"
     -var "project_name=${PROJECT}"
     -var "service_name=${ARTIFACT}"
     -var "service_version=${VERSION}"
     -var "artifact_user=${USER}"
     -var "artifact_secret=${SECRET}"
     -var "security_group=${SG}" # array 
     -var "subnet_target=${SUBNET}" 

# apply plan terrafom
terraform apply
# apply plan terrafom auto-approve
# terraform apply -auto-approve
 

cd ${workspace}/terraform/module/aws-ec2-image-iberia

echo "::set-output name=instance-id::$(terraform output instance_id)" # Note to develop: verify pass var
# init terraform module
terraform init

# create plan terrafom 
terraform plan 
     -var "project_name=${PROJECT}"
     -var "service_name=${ARTIFACT}"
     -var "service_version=${VERSION}"
     -var "source_instance_id=${instance-id}"
     -var "shareds_id=${SHARED}" # Note to develop: verify pass var

# apply plan terrafom
terraform apply
#terraform apply -auto-approve
  

echo "::set-output name=image-id::$(terraform output ami_id)"

echo "***************************************************"
echo "Created image"
echo "***************************************************"




