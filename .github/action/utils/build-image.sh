# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
user_name           = %1
user_departament    = %2
instance_type       = %3 
lenguage            = %4  

# get artifact image of differente type for lenguage
artifact_host       = %8
artifact_user       = %9
artifact_secret     = %10

# setting contants
PATH-SNAPSHOTS      = "/repository/snapshots/"
PATH-RELEASE        = "/repository/releases/"
PATH-NPM-PRIVATE    = "/npm-private/release/" 

if [ ${lenguage} == "java"] then 
    # change repository by pull request event 
    if [ ${{ startsWith(${ REF }, 'refs/heads/develop') }} == true ] then
        artifact_ref        = "http://%8/nexus/service/local/artifact/maven/redirect?r=${PATH-SNAPSHOTS}&g=%5&a=%6&v=%7&p=jar"
    elif [ ${{ startsWith(${ REF }, 'refs/heads/main') }} == true ] then
        artifact_ref        = "http://%8/nexus/service/local/artifact/maven/redirect?r=${PATH-RELEASE}&g=%5&a=%6&v=%7&p=jar"
    if
elif [ ${lenguage} == "angular"] then 
    # use main
    if [ ${{ startsWith(${ REF }, 'refs/heads/main') }} == true ] then
        artifact_ref        = "http://%8/nexus/service/local/artifact/maven/redirect?r=${PATH-NPM-PRIVATE}&g=%5&a=%6&v=%7&p=zip"
    if

if

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
