# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

# setting variable
PROJECT=${{ env.PROJECT }} 
AMI_VERSION=${{ env.AMI_VERSION }}
AMI_ID=${{ env.AMI_ID }}
WORKSPACE=${{ github.workspace }}
REF=${{ github.ref }}
SECURITY_GROUPS}=${{ env.SECURITY_GROUPS }} 
SUBNETS=${{ env.SUBNETS }}
ALB_TARGET_GROUP_ARN=${{ env.ALB_TARGET_GROUP}} 
ALB_TARGET_GROUP_ARN_SUFFIX= ${{ env.ALB_TARGET_GROUP_SUFFIX}}                
LB_ARN_SUFFIX=${{ env.LB_SUFFIX}} 

aws_access_key=${{ env.AWS_ACCESS_KEY }}
aws_secret_access_key=${{ env.AWS_SECRETE_ACCESS_KEY }}

# setting enviroment and prefix with conditional reference branchs
# pull request event from action
if [ ${ startsWith(${ REF }, 'refs/heads/main') } == true ] then  
    ENVIROMENT="integration"  # may be change to preproduction or production 
    PREFIX="int"
    . could-configure.sh ${aws_access_key} ${aws_secret_access_key } 


    cd ${ WORKSPACE }/terraform/module/aws-ec2-deploy-iberia

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
    -var "security_group=${SECURITY_GROUPS}"
    -var "subnet_target=${SUBNETS}"
    -var "aws_alb_target_group_arn=${ALB_TARGET_GROUP_ARN}"
    -var "aws_alb_target_group_arn_suffix=${ALB_TARGET_GROUP_ARN_SUFFIX}"
    -var "aws_lb_alb_arn_suffix=${LB_ARN_SUFFIX}"

    # apply plan terrafom
    terraform apply 
    #-auto-approve
    #-var "ami_id=${AMI_ID}" 
    #-var "version=${AMI_VERSION}" 
    #-var "project=${PROJECT}" 
    #-var "environment=${ENVIROMENT}" 
    #-var "environment_prefix=${PREFIX}"


    # set terrafom arn aws target group output to environment
    echo "aws_alb_target_group_arn=$(terraform output aws_alb_target_group_arn)" >> $GITHUB_ENV  #test in shell or move to run action

    echo "***************************************************"
    echo "Deploying complete..."
    echo "***************************************************"

if 