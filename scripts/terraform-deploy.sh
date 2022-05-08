#!/bin/bash
# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

# setting variable
# ENVIROMENT=${{env.ENVIROMENT}}  # may be change to preproduction or production 
# PREFIX=${{env.ENVIROMENT_PREFIX}} 
# aws_access_key=${{ env.AWS_ACCESS_KEY }}
# aws_secret_access_key=${{ env.AWS_SECRETE_ACCESS_KEY }}

# access enviroment profile 
# aws-profile                = ${{ env.AWS_PROFILE }}

# setting enviroment and prefix with conditional reference branchs
# pull request event from action
if [[ $REF == refs/heads/main* ]] ; then
    
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


    cd ${ WORKSPACE }/terraform/modules/aws-ec2-deploy-iberia

    echo "***************************************************"
    echo "Deploying with terraform..."
    echo "***************************************************"

    # init terraform module
    terraform init

    # create plan terrafom
    terraform plan 
    -var "version=${AMI_VERSION}"
    -var "ami_id=${AMI_ID}" 
    -var "project=${PROJECT}" 
    -var "environment=${ENVIROMENT}" 
    -var "environment_prefix=${PREFIX}"
    -var "security_group=${SECURITY_GROUPS}"
    -var "subnet_target=${SUBNETS}"
    -var "aws_alb_target_group_arn=${ALB_TARGET_GROUP_ARN}"
    -var "aws_alb_target_group_arn_suffix=${ALB_TARGET_GROUP_ARN_SUFFIX}"
    -var "aws_lb_alb_arn_suffix=${LB_ARN_SUFFIX}"

    # apply plan terrafom
    terraform apply 
    #-auto-approve
    #-var "ami_id=${AMI_ID}" 
    #-var "version=${AMI_VERSION}" 
    #-var "project=${PROJECT}" 
    #-var "environment=${ENVIROMENT}" 
    #-var "environment_prefix=${PREFIX}"


    # set terrafom arn aws target group output to environment
    # echo "aws_alb_target_group_arn=$(terraform output aws_alb_target_group_arn)" >> $GITHUB_ENV  #test in shell or move to run action

    echo "***************************************************"
    echo "Deploying complete..."
    echo "***************************************************"
    
    echo "***************************************************"
    echo "create cloudwatch alarm and log subcription..."
    echo "***************************************************"
    
    cd ${ WORKSPACE }/terraform/modules/aws-ec2-monitoring
    
    # init terraform module
    terraform init

    # create plan terrafom
    terraform plan 
    -var "service_name=${SERVICE}"
    -var "project=${PROJECT}" 
    -var "environment=${ENVIROMENT}"
    -var "environment_prefix=${PREFIX}"
    -var "aws_autoscaling_group_name=$(terraform output aws_autoscaling_group_name)"
    -var "aws_autoscaling_policy_arn=$(terraform output aws_autoscaling_policy_arn_cpu)"
  
    # apply plan terrafom
    terraform apply 
   
    echo "***************************************************"
    echo "Complete cloudwatch..."
    echo "***************************************************"
if 
