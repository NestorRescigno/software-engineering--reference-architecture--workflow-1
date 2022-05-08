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

#################################
# create uri artifact reference 
################################
if [[ $LENGUAGE -eq "java" ]] ; then
   FORMAT= "maven"  
else
   FORMAT= "npm"
fi
# example uri aws
if $CODEARTIFACT
then     
# GET /v1/package/version/asset?asset=asset&domain=domain&domain-owner=domainOwner&format=format&namespace=namespace&package=package&repository=repository&revision=packageVersionRevision&version=packageVersion HTTP/1.1     
     ARTIFACTREF = "https://${REPOSITORY_HOST}/v1/package/version/asset?asset=asset&domain=${PROJECT}&domain-owner=${REPOSITORY_OWNER}&format=${FORMAT}&namespace=${GROUP}&package=${ARTIFACT}&repository=${REPOSITORY_PATH}&version=${VERSION} HTTP/1.1"
else
     ARTIFACTREF = "https://${REPOSITORY_HOST}/nexus/service/local/artifact/maven/redirect?r=${REPOSITORY_PATH}&g=${GROUP}&a=${ARTIFACT}&v=${VERSION}&p=${PACKAGE}" 
fi

# pull request to develop event create instance in aws but it don't registry image of snapshot
echo "***************************************************"
echo "Creating image"
echo "***************************************************"

###########################################################################
##################### NOT IMPLEMENT PROFILE ###############################
# if [[ $AWS_PROFILE  -eq "" ]] ; then
#     echo "****************************************"
#     echo "**  profile connect: $AWS_PROFILE     **"
#     echo "****************************************"
#     export AWS_PROFILE= $AWS_PROFILE
# else
#     . could-configure.sh "aws" $AWS_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
# fi 

# init terraform module
cd ${WORKSPACE}/terraform/modules/aws-ec2-instance-iberia
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
     -var "artifact_user=${REPOSITORY_USER}"
     -var "artifact_secret=${REPOSITORY_SECRET}"
     -var "security_group=${SECURITY_GROUPS}" # array 
     -var "subnet_target=${SUBNET}" 

# apply plan terrafom
# terraform apply # temporal comment to test

 

cd ${WORKSPACE}/terraform/modules/aws-ec2-image-iberia

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
# terraform apply # temporal comment to test

echo "::set-output name=image-id::$(terraform output ami_id)"

echo "***************************************************"
echo "Created image"
echo "***************************************************"




