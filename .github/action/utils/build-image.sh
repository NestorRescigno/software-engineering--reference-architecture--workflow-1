# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************


USER_NAME           = %1
USER_DEPARTAMENT    = %2

# INSTANCE_TYPE     = %3 
LANGUAGE            = %3

# artifact param
GROUP               = %4     
ARTIFACT            = %5
VERSION             = %6
PACKAGE             = %7

# get artifact image of differente type for lenguage
HOST                = %8
USER                = %9
SECRET              = %10
REPOSITORY          = %11 

# product name      
PROJECT             = %12     

# REF                 = %12

# the path repository is present in var  
ARTIFACTREF        = "http://${HOST}/nexus/service/local/artifact/maven/redirect?r=${REPOSITORY}&g=${GROUP}&a=${ARTIFACT}&v=${VERSION}&p=${PACKAGE}"
 
# return url for lenguar in artifact_ref: terraform have script shell use curl -u by download file

echo "***************************************************"
echo "Creating image"
echo "***************************************************"

# pull request to develop event create instance in aws but it don't registry image of snapshot
# if [ ${{ startsWith(${ REF }, 'refs/heads/main') }} == true ] then  
     cd ${{ github.workspace }}/terraform/module/aws-ec2-image-iberia
# else
#    cd ${{ github.workspace }}/terraform/module/aws-ec2-instance-iberia
# if

echo "***************************************************"
echo "Deploying with terraform..."
echo "***************************************************"

# init terraform module
terraform init

# create plan terrafom
terraform plan 
-var "lenguage_code=${LANGUAGE}"
-var "user_name=${USER_NAME}"
-var "user_departament=${USER_DEPARTAMENT}" 
-var "instance_type=${INSTANCE_TYPE}" 
-var "ref=${ARTIFACTREF}" 
-var "package=${PACKAGE}"
-var "project_name=${PROJECT}"
-var "service_name=${ARTIFACT}"
-var "service_version=${VERSION}"
-var "artifact_user=${USER}"
-var "artifact_secret=${SECRET}"

# apply plan terrafom
terraform apply -auto-approve
-var "lenguage_code=${LANGUAGE}"
-var "user_name=${USER_NAME}"
-var "user_departament=${USER_DEPARTAMENT}" 
-var "instance_type=${INSTANCE_TYPE}" 
-var "ref=${ARTIFACTREF}" 
-var "package=${PACKAGE}"
-var "project_name=${PROJECT}"
-var "service_name=${ARTIFACT}"
-var "service_version=${VERSION}"
-var "artifact_user=${USER}"
-var "artifact_secret=${SECRET}"

echo "::set-output name=image-id::$(terraform output ami_id)"

echo "***************************************************"
echo "Created image"
echo "***************************************************"
