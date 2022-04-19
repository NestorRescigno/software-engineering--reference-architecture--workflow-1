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

# the path repository is present in var  
artifact_ref        = "http://${HOST}/nexus/service/local/artifact/maven/redirect?r=${REPOSITORY}&g=${GROUP}&a=${ARTIFACT}&v=${VERSION}&p=${PACKAGE}"
 
# return url for lenguar in artifact_ref: terraform have script shell use curl -u by download file

echo "***************************************************"
echo "Creating image"
echo "***************************************************"

cd ${{ github.workspace }}/terraform/module/aws-ec2-image-iberia

echo "***************************************************"
echo "Deploying with terraform..."
echo "***************************************************"

# init terraform module
terraform init

# create plan terrafom
terraform plan 
-var "user_name=${user_name}"
-var "user_departament=${user_departament}" 
-var "instance_type=${instance_type}" 
-var "lenguage_code=${lenguage}"
-var "ref=${artifact_ref}" 
-var "artifact_user=${artifact_user}"
-var "artifact_secret=${artifact_secret}"

# apply plan terrafom
terraform apply -auto-approve
-var "lenguage_code=${lenguage}"
-var "user_name=${user_name}"
-var "user_departament=${user_departament}" 
-var "instance_type=${instance_type}" 
-var "ref=${artifact_ref}" 
-var "artifact_user=${artifact_user}"
-var "artifact_secret=${artifact_secret}"

echo "::set-output name=image-id::$(terraform output ami_id)"

echo "***************************************************"
echo "Created image"
echo "***************************************************"
