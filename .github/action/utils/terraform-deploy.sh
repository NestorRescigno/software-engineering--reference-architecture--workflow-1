# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

# setting variable
PROJECT=%1
AMI_VERSION=%2
AMI_ID=%3
WORKSPACE=%4
REF=%5
SECURITY_GROUPS}=%6
SUBNETS=%7
ALB_TARGET_GROUP_ARN=%8

# setting enviroment and prefix with conditional reference branchs
# pull request event from action
if [ ${ startsWith(${ REF }, 'refs/heads/main') } == true ] then  
    ENVIROMENT="integration"  # may be change to preproduction or production 
    PREFIX="int"
    # elif [${{ startsWith(${ REF }, 'refs/heads/develop') }} == true ] then  
    #    PREFIX="dev"
    #    ENVIROMENT="develoment"
if 

#cd ${WORKSPACE }/terraform/module/aws-ec2-vpc-iberia

#echo "***************************************************"
#echo "Deploying with terraform..."
#echo "***************************************************"
# This module have lifecycle { create_before_destroy = false }

# init terraform module
#terraform init

# create plan terrafom
#terraform plan 
#-var "version=${AMI_VERSION}"
#-var "ami_id=${AMI_ID}" 
#-var "project=${PROJECT}" 
#-var "environment=${ENVIROMENT}" 
#-var "environment_prefix=${PREFIX}"

# apply plan terrafom 
#terraform apply 
#-auto-approve
#-var "ami_id=${AMI_ID}" 
#-var "version=${AMI_VERSION}" 
#-var "project=${PROJECT}" 
#-var "environment=${ENVIROMENT}" 
#-var "environment_prefix=${PREFIX}"

cd ${ WORKSPACE }/terraform/module/aws-ec2-deploy-iberia

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

# apply plan terrafom
terraform apply 
#-auto-approve
#-var "ami_id=${AMI_ID}" 
#-var "version=${AMI_VERSION}" 
#-var "project=${PROJECT}" 
#-var "environment=${ENVIROMENT}" 
#-var "environment_prefix=${PREFIX}"


# set terrafom arn aws target group output to environment
echo "aws_alb_target_group_arn=$(terraform output aws_alb_target_group_arn)" >> $GITHUB_ENV  #test in shell or move to run action

echo "***************************************************"
echo "Deploying complete..."
echo "***************************************************"

