# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
user_name           = %1
user_departament    = %2
instance_type       = %3   
artifact            = %4
lenguage            = %5

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
-var "ref=${artifact}" 
-var "lenguage_code=${lenguage}"

# apply plan terrafom
terraform apply -auto-approve
-var "user_name=${user_name}"
-var "user_departament=${user_departament}" 
-var "instance_type=${instance_type}" 
-var "ref=${artifact}" 
-var "lenguage_code=${lenguage}"


echo "***************************************************"
echo "Created image"
echo "***************************************************"
