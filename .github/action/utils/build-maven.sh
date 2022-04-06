echo "***************************************************"
echo "Artifact Building with maven"
echo "***************************************************"
if [ ${{ startsWith(github.ref, 'refs/heads/main') }} = true ]
then 
  echo ARTIFACT_TYPE: SNAPSHOT
  mvn clean deploy -s ${{ env.SETTINGS }} 
  -Dmaven.wagon.http.ssl.insecure=true 
  -DaltSnapshotDeploymentRepository=ibis-snapshots::default::${{ env.SNAPSHOTS_REPOSITORY_URL }} 
  -Ddocker.customTag=ci-${{ github.run_id }} 
  -Dpactbroker.auth.username=${{ env.IBIS_PACT_BROKER_USERNAME }} 
  -Dpactbroker.auth.password=${{ env.IBIS_PACT_BROKER_PASSWORD }} 
  -Dpactbroker.tags="latest,integration,qa,uat,prelive,beta,staging,live" 
  -Dpact.verifier.publishResults=true 
  -Dpact.consumer.tag=${{ env.CI_COMMIT_REF_SLUG }} 
  -Dpact.provider.tag=${{ env.CI_COMMIT_REF_SLUG }} 
  -Dpact.consumer.version=${{ env.PACT_VERSION }} 
  -Dpact.provider.version=${{ env.PACT_VERSION }} 
  --batch-mode
elif [ ${{ startsWith(github.ref, 'refs/heads/release') }} = true ]
then
  echo ARTIFACT_TYPE: RELEASE
  echo "***************************************************"
  echo "Setting version..."
  echo "***************************************************"
  mvn -s ${{ env.SETTINGS }} build-helper:parse-version versions:set 
  -DremoveSnapshot=true versions:commit 
  --batch-mode
  echo "***************************************************"
  echo "Building..."
  echo "***************************************************"               
  mvn clean deploy -s ${{ env.SETTINGS }} 
  -Dmaven.wagon.http.ssl.insecure=true 
  -DaltReleaseDeploymentRepository=ibis-releases::default::${{ env.RELEASES_REPOSITORY_URL }} 
  -Ddocker.customTag=ci-${{ github.run_id }} 
  -Dpactbroker.auth.username=${{ env.IBIS_PACT_BROKER_USERNAME }} 
  -Dpactbroker.auth.password=${{ env.IBIS_PACT_BROKER_PASSWORD }} 
  -Dpactbroker.tags="latest,integration,qa,uat,prelive,beta,staging,live" 
  -Dpact.verifier.publishResults=true -Dpact.consumer.tag=${{ env.CI_COMMIT_REF_SLUG }} 
  -Dpact.provider.tag=${{ env.CI_COMMIT_REF_SLUG }} -Dpact.consumer.version=${{ env.PACT_VERSION }} 
  -Dpact.provider.version=${{ env.PACT_VERSION }} --batch-mode
 elif [ ${{ startsWith(github.ref, 'refs/tags') }} = true ] then
  echo ARTIFACT_TYPE: RELEASE
  echo "***************************************************"
  echo "Setting version..."
  echo "***************************************************"
  mvn versions:set -DnewVersion=${{ env.ARTIFACT_VERSION }} -s ${{ env.SETTINGS }}
  echo "***************************************************"
  echo "Commit changes into project..."
  echo "***************************************************"
  mvn versions:commit -s ${{ env.SETTINGS }}
  echo "***************************************************"
  echo "Building..."
  echo "***************************************************"               
  mvn clean deploy -s ${{ env.SETTINGS }} 
  -Dmaven.wagon.http.ssl.insecure=true 
  -DaltReleaseDeploymentRepository=ibis-releases::default::${{ env.RELEASES_REPOSITORY_URL }} 
  -Ddocker.customTag=ci-${{ github.run_id }} 
  -Dpactbroker.auth.username=${{ env.IBIS_PACT_BROKER_USERNAME }} 
  -Dpactbroker.auth.password=${{ env.IBIS_PACT_BROKER_PASSWORD }} 
  -Dpactbroker.tags="latest,integration,qa,uat,prelive,beta,staging,live" 
  -Dpact.verifier.publishResults=true 
  -Dpact.consumer.tag=${{ env.CI_COMMIT_REF_SLUG }} 
  -Dpact.provider.tag=${{ env.CI_COMMIT_REF_SLUG }} 
  -Dpact.consumer.version=${{ env.PACT_VERSION }} 
  -Dpact.provider.version=${{ env.PACT_VERSION }} 
  --batch-mode
else
  mvn clean install -s ${{ env.SETTINGS }} 
  -Ddocker.customTag=ci-${{ github.run_id }} 
  --batch-mode
fi
  echo "***************************************************"
  echo "End Building"
  echo "***************************************************"  
