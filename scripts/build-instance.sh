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


if [[ "${INSTANCE_TYPE}" -ne "" ]]  ; then 
   echo "force use new instance type: ${INSTANCE_TYPE}"
fi

##################################
# init terraform module AIM
##################################
# echo "remove instance"
PROFILEINSTANCE="${PROJECT}-${ENVIROMENT_DEV}-instanceprofile-${ARTIFACT}"
aws sts get-caller-identity
echo $(aws iam list-instance-profiles | grep $PROFILEINSTANCE)
echo $(aws iam delete-instance-profile --instance-profile-name $PROFILEINSTANCE)

echo "***************************************************"
echo " Init terraform module profile..                   "
echo "***************************************************"
# service name
cd ${WORKSPACE}/.github/cicd/terraform/modules/aws-ec2-profile-iberia
terraform init
terraform plan  -var "project=${PROJECT}" -var "service_name=${ARTIFACT}"  -var "environment=${ENVIROMENT_DEV}" -var "environment_prefix=${ENVIROMENT_PREFIX_DEV}" -out create.plan
# create plan terrafom
terraform apply create.plan
rc=$?
if [ $rc -eq 1 ] ; then
   echo "***************************************************"
   echo " Continuos process..                               "
   echo "***************************************************"
fi

##################################
# init terraform module security
##################################
# SG="${ARTIFACT}-instances-${ENVIROMENT_PREFIX_DEV}-sg"
# echo $(aws ec2 delete-security-group --group-name $SG)
echo "***************************************************"
echo " Init terraform module securitygroup.              "
echo "***************************************************"
cd ${WORKSPACE}/.github/cicd/terraform/modules/aws-ec2-securitygroup-iberia
terraform init
terraform plan  -var "project=${PROJECT}" -var "service_name=${ARTIFACT}"  -var "environment=${ENVIROMENT_DEV}" -var "environment_prefix=${ENVIROMENT_PREFIX_DEV}" -out create.plan
# create plan terrafom
terraform apply create.plan
rc=$?
if [ $rc -eq 1 ] ; then
   echo "***************************************************"
   echo " Continuos process..                               "
   echo "***************************************************"
fi


##################################
# init terraform module endpoint connect
##################################
# SG="${ARTIFACT}-instances-${ENVIROMENT_PREFIX_DEV}-sg"
# echo $(aws ec2 delete-security-group --group-name $SG)
echo "***************************************************"
echo " Init terraform module endpoint connect.           "
echo "***************************************************"
cd ${WORKSPACE}/.github/cicd/terraform/modules/aws-ec2-endpoint-iberia
terraform init
terraform plan  -var "project=${PROJECT}" -var "service_name=${ARTIFACT}"  -var "environment=${ENVIROMENT_DEV}" -var "environment_prefix=${ENVIROMENT_PREFIX_DEV}" -out create.plan
# create plan terrafom
terraform apply create.plan
rc=$?
if [ $rc -eq 1 ] ; then
   echo "***************************************************"
   echo " Continuos process..                               "
   echo "***************************************************"
fi


##################################
# init terraform module instance
##################################
echo "***************************************************"
echo " Init terraform module Instance.                   "
echo "***************************************************"
cd ${WORKSPACE}/.github/cicd/terraform/modules/aws-ec2-instance-iberia

export INSTANCES=$(aws ec2 describe-instances --filters "Name=tag-value, Values=${ARTIFACT}-${ENVIROMENT_PREFIX_DEV}" --query 'Reservations[*].Instances[*].[InstanceId]' --output text)

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "${INSTANCES}"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


terraform init
terraform plan -var "lenguage_code=${LENGUAGE}" -var "instance_type=${INSTANCE_TYPE}" -var "ref=${ARTIFACTREF}" -var "package=${PACKAGE}" -var "project=${PROJECT}" -var "service_name=${ARTIFACT}" -var "service_version=${VERSION}" -var "service_groupid=${GROUP}" -var "artifact_user=${REPOSITORY_USER}" -var "artifact_secret=${REPOSITORY_SECRET}"  -var "environment=${ENVIROMENT_DEV}" -var "environment_prefix=${ENVIROMENT_PREFIX_DEV}" -out create.plan
# create plan terrafom
terraform apply create.plan
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
echo " instance id: $(terraform output instance_id)      "
echo "***************************************************"
export DataList=$(terraform output instance_ids)
export InstaceZoneA=$(terraform output instance_ips)

# test health
sleep 40
echo "instance state:"
HEALTH_STATUS=0
while [ ${HEALTH_STATUS} == 0 ];
do 
  # test from ALB 
  # aws elbv2 describe-target-health --target-group-arn $ALB_ARN --query 'TargetHealthDescriptions[*].[Target.Id, TargetHealth.State]' --output json | grep draining || HEALTH_STATUS=$?
  # test directly instance
  aws ec2 describe-instance-status --instance-ids $DataList --query InstanceStatuses[*].InstanceStatus.Details[*].Status --output json | grep "passed" || HEALTH_STATUS=$?
  sleep 10
done
if [  ${HEALTH_STATUS} == 0 ]
then
  echo "Unhealthy"
  echo "Deployment failed"
  exit (-1)
else
  echo "Healthy"
  echo "Deployment Completed"
  # copy ssh file to path in instance

  echo $InstaceZoneA
  scp ./target/$ARTIFACT-$VERSION.$PACKAGE ec2-user@$InstaceZoneA:/opt/services
fi




