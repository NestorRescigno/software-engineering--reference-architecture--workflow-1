#!/bin/bash
# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
#
# This script performs the action of creating an instance 
# from a base image for a vpc as a development environment 
# when it executes a pull request on the develop branch. 
     
# USER_NAME           = $1
# USER_DEPARTAMENT    = $2
# INSTANCE_TYPE     = $3

# access key cloud
# aws_access_key_dev          = ${{ env.AWS_ACCESS_KEY_DEV }}
# aws_secret_access_key_dev   = ${{ env.AWS_SECRETE_ACCESS_KEY_DEV }} 

# access enviroment profile 
# aws-profile                = ${{ env.AWS_PROFILE }}

echo "***************************************************"
echo " create instance form image base to develoment     "
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

#################################
# create uri artifact reference 
################################
if [[ $LENGUAGE -eq "java" ]] ; then
   FORMAT="maven"  
else
   FORMAT="npm"
fi
# example uri aws
if $CODEARTIFACT
then     
# GET /v1/package/version/asset?asset=asset&domain=domain&domain-owner=domainOwner&format=format&namespace=namespace&package=package&repository=repository&revision=packageVersionRevision&version=packageVersion HTTP/1.1     
     ARTIFACTREF="${REPOSITORY_HOST}/v1/package/version/asset?asset=asset&domain=${PROJECT}&domain-owner=${REPOSITORY_OWNER}&format=${FORMAT}&namespace=${GROUP}&package=${ARTIFACT}&repository=${REPOSITORY_PATH}&version=${VERSION} HTTP/1.1"
else
     ARTIFACTREF="https://${REPOSITORY_HOST}/nexus/service/local/artifact/maven/redirect?r=${REPOSITORY_PATH}&g=${GROUP}&a=${ARTIFACT}&v=${VERSION}&p=${PACKAGE}" 
fi


##################################

# init terraform module
cd ${WORKSPACE}/.github/cicd/terraform/modules/aws-ec2-instance-iberia

if [ ${INSTANCE_TYPE} != ""] ; then 
   echo "force use new instance type: ${INSTANCE_TYPE}"
fi

terraform init
terraform plan -var "lenguage_code=${LENGUAGE}" -var "instance_type=${INSTANCE_TYPE}" -var "ref=${ARTIFACTREF}" -var "package=${PACKAGE}" -var "project=${PROJECT}" -var "service_name=${ARTIFACT}" -var "service_version=${VERSION}" -var "service_groupid=${GROUP}" -var "artifact_user=${REPOSITORY_USER}" -var "artifact_secret=${REPOSITORY_SECRET}"  -var "environment=${ENVIROMENT_DEV}" -var "environment_prefix=${ENVIROMENT_PREFIX_DEV}"
# create plan terrafom
terraform apply -auto-approve -var "lenguage_code=${LENGUAGE}" -var "instance_type=${INSTANCE_TYPE}" -var "ref=${ARTIFACTREF}" -var "package=${PACKAGE}" -var "project=${PROJECT}" -var "service_name=${ARTIFACT}" -var "service_version=${VERSION}" -var "service_groupid=${GROUP}" -var "artifact_user=${REPOSITORY_USER}" -var "artifact_secret=${REPOSITORY_SECRET}"  -var "environment=${ENVIROMENT_DEV}" -var "environment_prefix=${ENVIROMENT_PREFIX_DEV}"
rc=$?
if [ $rc -eq 1 ] ; then
   echo "***************************************************"
   echo " Error terrafom apply resource "
   echo " stop workflow progess... "
   echo "***************************************************"
   exit -1
fi

#apply plan terrafom
# terraform apply # temporal comment to test

echo "***************************************************"
echo " instance id: $(terraform output instance_id)"
echo "***************************************************"
export IDS=$(terraform output instance_id)
for IDS
do
echo "Number instance_id is $IDS"
export STATE=$(aws ec2 get-console-output --instance-id ${IDS} --output text)
echo $STATE
done

