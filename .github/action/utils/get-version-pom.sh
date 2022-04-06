echo "***************************************************"
echo "Getting version.."
echo "***************************************************"
POM_VERSION=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.version}' -s ${{ env.SETTINGS }} --non-recursive exec:exec)
echo POM_VERSION: $POM_VERSION
# echo "POM_VERSION=$POM_VERSION" >> $GITHUB_ENV
ARTIFACT_VERSION=$(echo $POM_VERSION | grep -o '^[0-9]\+\.[0-9]\+\.[0-9]\+')
echo ARTIFACT_VERSION: $ARTIFACT_VERSION
echo "ARTIFACT_VERSION=$ARTIFACT_VERSION" >> $GITHUB_ENV
MICROSERVICE_NAME=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.artifactId}' -s ${{ env.SETTINGS }} --non-recursive exec:exec)
echo MICROSERVICE_NAME: $MICROSERVICE_NAME
echo "MICROSERVICE_NAME=$MICROSERVICE_NAME" >> $GITHUB_ENV
ARTIFACT_ID="${MICROSERVICE_NAME}-core"
echo ARTIFACT_ID: $ARTIFACT_ID
echo "ARTIFACT_ID=$ARTIFACT_ID" >> $GITHUB_ENV
ARTIFACT_GROUP_ID=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.groupId}' -s ${{ env.SETTINGS }} --non-recursive exec:exec)
echo ARTIFACT_GROUP_ID: $ARTIFACT_GROUP_ID
echo "ARTIFACT_GROUP_ID=$ARTIFACT_GROUP_ID" >> $GITHUB_ENV
CI_COMMIT_SHORT_SHA=$(echo ${GITHUB_SHA} | cut -c1-8)
echo CI_COMMIT_SHORT_SHA: $CI_COMMIT_SHORT_SHA
# echo CI_COMMIT_SHORT_SHA=$CI_COMMIT_SHORT_SHA >> $GITHUB_ENV
PACT_VERSION=$ARTIFACT_VERSION-$CI_COMMIT_SHORT_SHA
echo PACT_VERSION: $PACT_VERSION
echo "PACT_VERSION=$PACT_VERSION" >> $GITHUB_ENV
CI_COMMIT_REF_SLUG=$(echo ${{ github.ref}} | cut -c -63 | sed -E 's/[^a-z0-9-]+/-/g' | sed -E 's/^-*([a-z0-9-]+[a-z0-9])-*$$/\1/g')
echo CI_COMMIT_REF_SLUG: $CI_COMMIT_REF_SLUG
echo "CI_COMMIT_REF_SLUG=$CI_COMMIT_REF_SLUG" >> $GITHUB_ENV
