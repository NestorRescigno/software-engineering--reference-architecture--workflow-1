# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

# setting variable
AMI_VERSION=%1
AMI_ID=%2
PROJECT=%3
ENVIROMENT=%4
PREFIX=%5

cd ${{ github.workspace }}/terraform/module/aws-ec2-vpc-iberia

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

# apply plan terrafom
terraform apply -auto-approve
-var "ami_id=${AMI_ID}" 
-var "version=${AMI_VERSION}" 
-var "project=${PROJECT}" 
-var "environment=${ENVIROMENT}" 
-var "environment_prefix=${PREFIX}"

cd ${{ github.workspace }}/terraform/module/aws-ec2-depoly-iberia

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

# apply plan terrafom
terraform apply -auto-approve
-var "ami_id=${AMI_ID}" 
-var "version=${AMI_VERSION}" 
-var "project=${PROJECT}" 
-var "environment=${ENVIROMENT}" 
-var "environment_prefix=${PREFIX}"

# set terrafom arn aws target group output to environment
echo "aws_alb_target_group_arn=$(terraform output aws_alb_target_group_arn)" >> $GITHUB_ENV  #test in shell or move to run action

echo "***************************************************"
echo "Deploying end..."
echo "***************************************************"

# *********************************************************************
# *************           NOTE FOR DEVELOPER              *************
# *************  the module terrafom is location in       *************
# *************     ./module/terraform/                   *************
# *************  define vpn, subnet, and other            *************
# *************  firt time                                *************
# *********************************************************************
