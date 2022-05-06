#!/bin/bash
# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
# sh ./setup.sh
# setting credencials 
if $CODEARTIFACT
then
    echo "***************************************************"
    echo "use codeArtifact"
    echo "***************************************************"
    REPOSITORY_OWNER=$REPOSITORY_USER
   
    export CODEARTIFACT_AUTH_TOKEN=`aws codeartifact get-authorization-token --domain $PROJECT --domain-owner $REPOSITORY_OWNER --query authorizationToken --output text`
    REPOSITORY_USER='aws'
    REPOSITORY_SECRET=$CODEARTIFACT_AUTH_TOKEN 
    
   
   
else 
    echo "***************************************************"
    echo "use Nexus"
    echo "***************************************************"
    REPOSITORY_USER=$REPOSITORY_USER
    REPOSITORY_SECRET=$REPOSITORY_SECRET   
fi    

# return user and token access to repository because token auto generate in this jobs, phase build image download form codeartifact or nexus.
echo "::set-output name=registry-repository-owner::$(echo ${REPOSITORY_OWNER})" 
echo "::set-output name=registry-repository-usr::$(echo ${REPOSITORY_USER})"
echo "::set-output name=registry-repository-key::$(echo ${REPOSITORY_SECRET})"
  
# setting variable
LANGUAGE=$LANGUAGE 
REF=$REF
GROUPID=$GROUP
ARTIFACTID=$ARTIFACT 
VERSION=$VERSION
PACKAGE_TYPE=$PACKAGE
# setting contants
SNAPSHOTS="snapshots"
RELEASES="releases"
PATH_NPM_PRIVATE="/npm-private/releases/"
PATH_RELEASE="/maven/releases/" 
PATH_SNAPSHOTS="/maven/snapshots/"

################################################################################
## No implement with codeartifact, use api: get url
# REPOSITORY_URL="https://${REPOSITORY_USER}:${REPOSITORY_SECRET}@${REPOSITORY_DNS}"      # DNS can't content http or https, is necesary certificate 
# REPOSITORY_URL=$REPOSITORY_DNS
################################################################################ 
   
echo "***************************************************"
echo "Registy artifact to repository"
echo "***************************************************"

# set path work and move default setting, setting has env authenticate token.
cp settings.xml $WORKSPACE
cd $WORKSPACE

echo "branch to work: $REF"

if [ $LANGUAGE=="java" ] ; then
    echo "***************************************************"
    echo "artifact type java"
    echo "***************************************************"
    if [[ $REF == refs/heads/develop* ]] ; then
        echo "***************************************************"
        echo "upload snapshop"
        echo "***************************************************"
        
        ################################################################################
        # referece line 48: if use then after line 48 can't comment 
        # SNAPSHOTS_REPOSITORY_URL="${REPOSITORY_URL}${PATH_SNAPSHOTS}"
        ################################################################################
        
        # get URL 
        export URL=`aws codeartifact get-repository-endpoint --domain $PROJECT --repository $SNAPSHOTS --format maven --output text`
        # example deploy file with maven
        mvn -s settings.xml --batch-mode deploy:deploy-file -DgroupId=$GROUPID -DartifactId=$ARTIFACTID -Dversion=$VERSION -DgeneratePom=true -Dpackaging=$PACKAGE_TYPE -Dfile=target/$ARTIFACTID-$VERSION.$PACKAGE_TYPE -DrepositoryId=codeartifact -Durl=$URL
        
        echo "::set-output name=registry-repository-id::$(echo ${PATH_SNAPSHOTS})" 
        echo "***************************************************"
        echo "upload complete"
        echo "***************************************************"
    elif [[ $REF == refs/heads/main* ]] ; then
        echo "***************************************************"
        echo "upload release"
        echo "***************************************************"
        ################################################################################
        ## No implement with codeartifact, use api: get url
        # RELEASE_REPOSITORY_URL="${REPOSITORY_URL}${PATH_RELEASE}"
        ################################################################################
        
        # get URL 
        export URL=`aws codeartifact get-repository-endpoint --domain $PROJECT --repository $RELEASES --format maven --output text`
        # example deploy file with maven
        mvn -s settings.xml --batch-mode deploy:deploy-file -DgroupId=$GROUPID -DartifactId=$ARTIFACTID -Dversion=$VERSION -DgeneratePom=true -Dpackaging=$PACKAGE_TYPE -Dfile=target/$ARTIFACTID-$VERSION.$PACKAGE_TYPE -DrepositoryId=codeartifact -Durl=$URL
               
        echo "::set-output name=registry-repository-id::$(echo ${PATH_RELEASE})" 
        
        echo "***************************************************"
        echo "upload complete"
        echo "***************************************************"
    fi
elif [ $LANGUAGE=="angular"] ; then
    echo "***************************************************"
    echo "Artifact type angular"
    echo "***************************************************"
    if [ $REF=='refs/heads/main'* ] ; then
        echo "***************************************************"
        echo "upload npm private release"
        echo "***************************************************"
        
        NPM_REPOSITORY_URL="${REPOSITORY_URL}${PATH_NPM_PRIVATE}"  
        
        # node compile method
        # ng build
        
        # copy package.json to dist
        # cp package.json \dist
        # cd \dist
        
        # add publish registry in package.json ( note: find other method becuase url and token is present on registry. )
        # sed "s/\('publishConfig':\)/\1\""registry": "${NPM_REPOSITORY_URL}"\"\,/g" package.json
        
        # run npm publish
        npm publish --registry "${NPM_REPOSITORY_URL}"   # Nexus configure npm proxy and private registry.

        echo "::set-output name=registry-repository-id::$(echo ${PATH_NPM_PRIVATE})" 
        echo "***************************************************"
        echo "upload complete"
        echo "***************************************************"
    fi
else
    echo "***************************************************"
    echo "Error lenguage select, options [java, angular]"
    echo "***************************************************"
    exit -1
fi
echo "***************************************************"
echo "Registy complete"
echo "***************************************************"
