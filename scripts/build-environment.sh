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

export STATE=$(aws ec2 describe-vpcs --filters "Name=tag-key, Values=${PROJECT}-${PREFIX_TEMP}" --query 'Vpcs[0].State')



if [ $STATE == "null" ] ; then 
  echo "vpc not available: $STATE"
  # This module have lifecycle { create_before_destroy = false }
  cd ${WORKSPACE}/.github/cicd/terraform/modules/aws-ec2-vpc-iberia/simple_vpc
  terraform init
  # apply plan terrafom
  terraform apply -auto-approve -var "project=${PROJECT}" -var "service_name=${SERVICE}" -var "environment=${ENVIROMENT_TEMP}" -var "environment_prefix=${PREFIX_TEMP}"
fi

# This module have lifecycle { create_before_destroy = false }
cd ${WORKSPACE}/.github/cicd/terraform/modules/aws-ec2-vpc-iberia

# init terraform module
terraform init

echo "group by id: ${GROUP}" 
# create plan terrafom
# terraform plan -var "project=${PROJECT}" -var "service_name=${SERVICE}" -var "environment=${ENVIROMENT_TEMP}" -var "environment_prefix=${PREFIX_TEMP}" -var "service_groupid=${GROUP}"

# apply plan terrafom
terraform apply -auto-approve -var "project=${PROJECT}" -var "service_name=${SERVICE}" -var "environment=${ENVIROMENT_TEMP}" -var "environment_prefix=${PREFIX_TEMP}" -var "service_groupid=${GROUP}" -var "state=${STATE}"

echo "::set-output name=security-group-ids:$(terraform output aws_security_groups)" 
echo "::set-output name=subnets-ids::$(terraform output aws_subnets_ids)" 
echo "::set-output name=shared-ids::$(terraform output account_id)" 
echo "::set-output name=alb-target-group-arn::$(terraform output aws_alb_target_group_arn)" 
echo "::set-output name=lb-arn-suffix::$(terraform output lb_arn_suffix)" 
echo "::set-output name=alb-target-group-arn-suffix::$(terraform output aws_alb_target_group_arn_suffix)" 

echo "***************************************************"
echo " Enviroment ${ENVIROMENT_TEMP}"
echo " with Prefix ${PREFIX_TEMP}" 
echo " is complete... "
echo "***************************************************"
