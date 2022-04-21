# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
#
# This script performs the action of creating an instance 
# from a base image for a vpc as a development environment 
# when it executes a pull request on the develop branch. 
# while for the main branch it performs both 
# the action of creating an instance and generating an image from it.
     
# USER_NAME           = %1
# USER_DEPARTAMENT    = %2


# INSTANCE_TYPE     = %3

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

# access key cloud
aws_access_key_op          = ${{ env.AWS_ACCESS_KEY_OP }}
aws_access_key_op          = ${{ env.AWS_SECRETE_ACCESS_KEY_OP }} 

aws_access_key_dev          = ${{ env.AWS_ACCESS_KEY_DEV }}
aws_secret_access_key_dev   = ${{ env.AWS_SECRETE_ACCESS_KEY_DEV }} 


# the path repository is present in var  
ARTIFACTREF        = "http://${HOST}/nexus/service/local/artifact/maven/redirect?r=${REPOSITORY}&g=${GROUP}&a=${ARTIFACT}&v=${VERSION}&p=${PACKAGE}"
 

# pull request to develop event create instance in aws but it don't registry image of snapshot
if [ ${ startsWith(${ REF }, 'refs/heads/main') } == true ] then  
     echo "***************************************************"
     echo "Creating image"
     echo "***************************************************"
      
     . could-configure.sh ${aws_access_key_op} ${aws_secret_access_key_op }  # configure operational account, generate image and shared with instance 
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
     # apply plan terrafom
     # terraform apply -auto-approve
     #-var "lenguage_code=${LANGUAGE}"
     #-var "instance_type=${INSTANCE_TYPE}" 
     #-var "ref=${ARTIFACTREF}" 
     #-var "package=${PACKAGE}"
     #-var "project_name=${PROJECT}"
     #-var "service_name=${ARTIFACT}"
     #-var "service_version=${VERSION}"
     #-var "artifact_user=${USER}"
     #-var "artifact_secret=${SECRET}"
     #-var "security_group=${SG}" # array 
     #-var "subnet_target=${SUBNET}" 

     cd ${workspace}/terraform/module/aws-ec2-image-iberia

     echo "::set-output name=instance-id::$(terraform output instance_id)" # Note to develop: verify pass var
     # init terraform module
     terraform init

     # create plan terrafom 
     #Note of developer: control module for shared image to diference environment account, this generate in operational account.
     terraform plan 
     -var "project_name=${PROJECT}"
     -var "service_name=${ARTIFACT}"
     -var "service_version=${VERSION}"
     -var "source_instance_id=${instance-id}" # Note to develop: verify pass var

     # apply plan terrafom
     terraform apply
     #terraform apply -auto-approve
     #-var "project_name=${PROJECT}"
     #-var "service_name=${ARTIFACT}"
     #-var "service_version=${VERSION}"
     #-var "source_instance_id=${instance-id}" # Note to develop: verify pass var


     echo "::set-output name=image-id::$(terraform output ami_id)"

     echo "***************************************************"
     echo "Created image"
     echo "***************************************************"

elif [ ${ startsWith(${ REF }, 'refs/heads/develop') } == true ] then 

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
     #-auto-approve
     #terraform apply -auto-approve
     #-var "lenguage_code=${LANGUAGE}"
     #-var "instance_type=${INSTANCE_TYPE}" 
     #-var "ref=${ARTIFACTREF}" 
     #-var "package=${PACKAGE}"
     #-var "project_name=${PROJECT}"
     #-var "service_name=${ARTIFACT}"
     #-var "service_version=${VERSION}"
     #-var "artifact_user=${USER}"
     #-var "artifact_secret=${SECRET}"
     #-var "security_group=${SG}" # array 
     #-var "subnet_target=${SUBNET}" 

     echo "***************************************************"
     echo " instance_id: $(terraform output instance_id)"
     echo "***************************************************"
     
if
     


