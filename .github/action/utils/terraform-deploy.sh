# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
echo "***************************************************"
echo "Deploying with terraform..."
echo "***************************************************"
cd ${{ github.workspace }}/${{ env.MICROSERVICE_NAME }}-iac/int/${{ env.MICROSERVICE_NAME }}-svc
terraform init
terraform plan 
-var "anc_ins_version=${{ needs.init.outputs.AMI_VERSION }}" 
-var "project=ancill" 
-var "environment=int" 
-var "anc_ins_ami_id=${{ env.IMAGE_ID }}" 
-var "environment_prefix=ancill-int"
terraform apply -auto-approve 
-var "anc_ins_version=${{ needs.init.outputs.AMI_VERSION }}" 
-var "project=ancill" 
-var "environment=int" 
-var "anc_ins_ami_id=${{ env.IMAGE_ID }}" 
-var "environment_prefix=ancill-int"
echo "***************************************************"
echo "Deploying end..."
echo "***************************************************"
