# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

# set load balancer and
ALB_ARN: ${{ env.aws_alb_target_group_arn }}

echo "***************************************************"
echo "Health Checking..."
echo "***************************************************"

sleep 30
echo "1st instance state:"
HEALTH_STATUS=0
while [ ${HEALTH_STATUS} == 0 ];
do 
  aws elbv2 describe-target-health --target-group-arn ${{ env.ALB_ARN }} --query 'TargetHealthDescriptions[*].[Target.Id, TargetHealth.State]' --output json | grep draining || HEALTH_STATUS=$?
  sleep 10
done
  HEALTH_STATUS=0
while [ ${HEALTH_STATUS} == 0 ];
do 
  aws elbv2 describe-target-health --target-group-arn ${{ env.ALB_ARN }} --query 'TargetHealthDescriptions[*].[Target.Id, TargetHealth.State]' --output json | grep initial || HEALTH_STATUS=$?
  sleep 10
done
  HEALTH_STATUS=0
  aws elbv2 describe-target-health --target-group-arn ${{ env.ALB_ARN }} --query 'TargetHealthDescriptions[*].[Target.Id, TargetHealth.State]' --output json | grep unhealthy || HEALTH_STATUS=$?
if [  ${HEALTH_STATUS} == 0 ]
then
  echo "Unhealthy"
  echo "Deployment failed"
exit 1
else
  echo "Healthy"
  echo "Deployment Completed"
fi
echo "***************************************************"
echo "End Health Checking"
echo "***************************************************"
