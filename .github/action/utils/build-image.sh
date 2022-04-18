# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
user_name           = %1
user_departament    = %2
instance_type       = %3 
lenguage            = %4  
artifact_ref        = %5
artifact_user       = %6
artifact_secret     = %7

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
-var "artifact_user=${artifact_secret}"

clear

# apply plan terrafom
terraform apply -auto-approve
-var "lenguage_code=${lenguage}"
-var "user_name=${user_name}"
-var "user_departament=${user_departament}" 
-var "instance_type=${instance_type}" 
-var "ref=${artifact_ref}" 
-var "artifact_user=${artifact_user}"
-var "artifact_user=${artifact_secret}"

clear

echo "***************************************************"
echo "Created image"
echo "***************************************************"
