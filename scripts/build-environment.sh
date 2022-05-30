#!/bin/bash
# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

# setting variable


# access key cloud
# AWS_ACCESS_KEY=$AWS_ACCESS_KEY
# AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

# AWS_ACCESS_KEY_DEV=$AWS_ACCESS_KEY_DEV
# AWS_SECRET_ACCESS_KEY_DEV=$AWS_SECRET_ACCESS_KEY_DEV  

# access enviroment profile 
# AWS_PROFILE=AWS_PROFILE

# setting enviroment and prefix with conditional reference branchs
# pull request event from action
  if [[ $REF == refs/heads/main* ]] ; then 
    ENVIROMENT_TEMP=$ENVIROMENT  # may be change to preproduction or production 
    PREFIX_TEMP=$ENVIROMENT_PREFIX 
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
elif [[ $REF == refs/heads/develop* ]] ; then  
    ENVIROMENT_TEMP=$ENVIROMENT_DEV  # may be change to preproduction or production 
    PREFIX_TEMP=$ENVIROMENT_PREFIX_DEV
    ###########################################################################
    ##################### NOT IMPLEMENT PROFILE ###############################
    # if [[ $AWS_PROFILE  -eq "" ]] ; then
    #     echo "****************************************"
    #     echo "**  profile connect: $AWS_PROFILE     **"
    #     echo "****************************************"
    #     export AWS_PROFILE= $AWS_PROFILE
    # else
    #     . could-configure.sh "aws" $AWS_ACCESS_KEY_DEV $AWS_SECRET_ACCESS_KEY_DEV
    # fi 
fi 

echo "***************************************************"
echo " prepare enviroment with terraform... "
echo "***************************************************"

echo $(aws ec2 describe-availability-zones --region eu-central-1)

export STATE=$(aws ec2 describe-vpcs --filters "Name=tag-value, Values=${PROJECT}-${PREFIX_TEMP}" --query 'Vpcs[0].State')

echo "vpc state: $STATE"

if [ $STATE == "null" ] ; then 
  
  # This module have lifecycle { create_before_destroy = false }
  echo "***************************************************"
  echo " Init terraform VPC.                               "
  echo "***************************************************"
  cd ${WORKSPACE}/.github/cicd/terraform/modules/aws-ec2-vpc-iberia
  terraform init
  # apply plan terrafom
  terraform apply -auto-approve -var "az_number=${ZONE}" -var "project=${PROJECT}" -var "service_name=${SERVICE}" -var "environment=${ENVIROMENT_TEMP}" -var "environment_prefix=${PREFIX_TEMP}"
  rc=$?
  if [ $rc -eq 1 ] ; then 
   echo "***************************************************"
   echo " Error terrafom apply resource "
   echo " stop workflow progess... "
   echo "***************************************************"
   exit -1
  fi




##################################
# init terraform module api gateway
##################################
echo "***************************************************"
echo " Init terraform module gateway.                   "
echo "***************************************************"
cd ${WORKSPACE}/.github/cicd/terraform/modules/aws-ec2-gateway-iberia

terraform init
terraform plan -var "az_number=${ZONE}"  -var "project=${PROJECT}"  -var "environment=${ENVIROMENT_DEV}" -var "environment_prefix=${ENVIROMENT_PREFIX_DEV}" -out create.plan
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

else
  echo "***************************************************"
  echo " VPC exists.                                       "
  echo "***************************************************"
fi

echo "***************************************************"
echo " Enviroment ${ENVIROMENT_TEMP}"
echo " with Prefix ${PREFIX_TEMP}" 
echo " is complete... "
echo "***************************************************"

