# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

# setting variable
PROJECT     =${{ env.PROJECT }}
GROUP       =${{ env.GROUP }} 
SERVICE     =${{ env.SERVICE }} 
WORKSPACE   =${{ github.workspace }}
REF         =${{ github.ref }}

# access key cloud
aws_access_key_int          = ${{ env.AWS_ACCESS_KEY }}
aws_secret_access_key_int   = ${{ env.AWS_SECRETE_ACCESS_KEY }}

aws_access_key_dev          = ${{ env.AWS_ACCESS_KEY_DEV }}
aws_secret_access_key_dev   = ${{ env.AWS_SECRETE_ACCESS_KEY_DEV }}  

# setting enviroment and prefix with conditional reference branchs
# pull request event from action
if [ ${ startsWith(${ REF }, 'refs/heads/main') } == true ] then  
    ENVIROMENT="integration"  # may be change to preproduction or production 
    PREFIX="int"

    . could-configure.sh ${aws_access_key_int } ${aws_secret_access_key_int } 

elif [${ startsWith(${ REF }, 'refs/heads/develop') } == true ] then  
    ENVIROMENT="development"
    PREFIX="dev"

    . could-configure.sh ${aws_access_key_dev} ${aws_secret_access_key_dev } 
if 


echo "***************************************************"
echo "prepare enviroment with terraform..."
echo "***************************************************"

cd ${WORKSPACE }/terraform/module/aws-ec2-vpc-iberia  # This module have lifecycle { create_before_destroy = false }
# init terraform module
terraform init

# create plan terrafom
terraform plan 
-var "project=${PROJECT}" 
-var "service_name=${SERVICE}"
-var "environment=${ENVIROMENT}" 
-var "environment_prefix=${PREFIX}"  
-var "service_groupid=${GROUP}"

# apply plan terrafom 
terraform apply 
#-auto-approve
#-var "project=${PROJECT}" 
#-var "environment_prefix=${PREFIX}"
#-var "environment=${ENVIROMENT}" 

echo "::set-output name=security-group-ids:$(terraform output aws_security_groups)" 
echo "::set-output name=subnets-ids::$(terraform output aws_subnets_ids)" 
echo "::set-output name=alb-target-group-arn::$(terraform output aws_alb_target_group_arn)" 
               

echo "***************************************************"
echo "Enviroment ${ENVIROMENT} "
echo "with Prefix ${PREFIX}" 
echo "is complete ..."
echo "***************************************************"
