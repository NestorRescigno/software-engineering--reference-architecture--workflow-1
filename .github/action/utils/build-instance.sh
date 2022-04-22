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

LANGUAGE            = ${{ env.LANGUAGE }}

# artifact param
GROUP               = ${{ env.GROUP }}     
ARTIFACT            = ${{ env.ARTIFACT }} 
VERSION             = ${{ env.VERSION }} 
PACKAGE             = ${{ env.PACKAGE}}

# get artifact image of differente type for lenguage
HOST                = ${{ env.REPOSITORY_HOST }} 
USER                = ${{ env.REPOSITORY_USER }} 
SECRET              = ${{ env.REPOSITORY_SECRET }}
REPOSITORY          = ${{ env.REPOSITORY_PATH }} 

# product name      
PROJECT             = ${{ env.PROJECT }}

# repository reference
workspace           = ${{ github.workspace }}
REF                 = ${{ github.ref }}

SG                  = ${{ env.SECURITY_GROUPS }}      # NOTE OF DEVELOP : Pending find in code or workflow
SUBNET              = ${{ env.SUBNETS }}      # NOTE OF DEVELOP : Pending find in code or workflow
SHARED              = ${{ env.SHARED }}

# access key cloud
aws_access_key_dev          = ${{ env.AWS_ACCESS_KEY_DEV }}
aws_secret_access_key_dev   = ${{ env.AWS_SECRETE_ACCESS_KEY_DEV }} 

echo "***************************************************"
echo "create instance form image base to develoment"
echo "***************************************************"

. could-configure.sh ${aws_access_key_dev } ${aws_secret_access_key_dev } # create instance in developmente enviroment, need this account access.

cd ${workspace}/terraform/module/aws-ec2-instance-iberia
# init terraform module
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

echo "***************************************************"
echo " instance_id: $(terraform output instance_id)"
echo "***************************************************"
     