#!/bin/bash
# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
sh ./setup.sh

# setting credencials 
if [ $CODEARTIFACT==false ] then
    REPOSITORY_USER=$REPOSITORY_USER
    REPOSITORY_SECRET=$REPOSITORY_SECRET   
else 
    REPOSITORY_OWNER=$REPOSITORY_USER
    export CODEARTIFACT_AUTH_TOKEN='aws codeartifact get-authorization-token --domain $PROJECT --domain-owner $REPOSITORY_OWNER --query authorizationToken --output text'
    REPOSITORY_USER='aws'
    REPOSITORY_SECRET=$CODEARTIFACT_AUTH_TOKEN 
fi
REPOSITORY_DNS=$REPOSITORY_DNS    
REPOSITORY_URL="https://${REPOSITORY_USER}:${REPOSITORY_SECRET}@${REPOSITORY_DNS}"      # DNS can't content http or https, is necesary certificate 

# return user and token access to repository because token auto generate in this jobs, phase build image download form codeartifact or nexus.
echo "::set-output name=registry-repository-owner::$(echo ${REPOSITORY_OWNER})" 
echo "::set-output name=registry-repository-usr::$(echo ${REPOSITORY_USER})"
echo "::set-output name=registry-repository-key::$(echo ${REPOSITORY_SECRET})"
  
# setting variable
LANGUAGE          =$LANGUAGE 
REF               =$REF
GROUPID           =$GROUP
ARTIFACTID        =$ARTIFACT 
VERSION           =$VERSION
PACKAGE-TYPE      =$PACKAGE
# setting contants
PATH-SNAPSHOTS="/repository/snapshots/"
PATH-RELEASE="/repository/releases/"
PATH-NPM-PRIVATE="/npm-private/releases/" 
    
echo "***************************************************"
echo "Registy artifact to nexus repository"
echo "***************************************************"

if [$LANGUAGE=="java"] ; then
    echo "***************************************************"
    echo "artifact type java"
    echo "***************************************************"
    if [[$REF=='refs/heads/develop'* ]] ; then
        echo "***************************************************"
        echo "upload snapshop"
        echo "***************************************************"
            
        SNAPSHOTS_REPOSITORY_URL=${REPOSITORY_URL}+${PATH-SNAPSHOTS} # --batch-mode
        # example deploy file with maven
        mvn deploy:deploy-file 
            -DgroupId=${GROUPID}
            -DartifactId=${ARTIFACTID} 
            -Dversion=${VERSION}
            -DgeneratePom=true 
            -Dpackaging=${PACKAGE-TYPE} 
             # -DrepositoryId=nexus 
            -Durl=${ SNAPSHOTS_REPOSITORY_URL }
            -Dfile=target/${ARTIFACTID}-${VERSION}.${PACKAGE-TYPE}
            
        echo "::set-output name=registry-repository-id::$(echo ${PATH-SNAPSHOTS})" 
        echo "***************************************************"
        echo "upload complete"
        echo "***************************************************"
    elif [[$REF=='refs/heads/main'* ]] ; then
        echo "***************************************************"
        echo "upload release"
        echo "***************************************************"
            
        RELEASE_REPOSITORY_URL=${REPOSITORY_URL}+${PATH-RELEASE}
        # example deploy file with maven
        mvn deploy:deploy-file 
            -DgroupId=${GROUPID}
            -DartifactId=${ARTIFACTID} 
            -Dversion=${VERSION}
            -DgeneratePom=true 
            -Dpackaging=${PACKAGE-TYPE} 
            # -DrepositoryId=nexus 
            -Durl=${RELEASE_REPOSITORY_URL}
            -Dfile=target/${ARTIFACTID}-${VERSION}.${PACKAGE-TYPE}
            
        echo "::set-output name=registry-repository-id::$(echo ${PATH-RELEASE})" 
        echo "***************************************************"
        echo "upload complete"
        echo "***************************************************"
    fi
elif [$LANGUAGE=="angular"] ; then
    echo "***************************************************"
    echo "Artifact type angular"
    echo "***************************************************"
    if [[$REF=='refs/heads/main'* ]] ; then
        echo "***************************************************"
        echo "upload npm private release"
        echo "***************************************************"
        
        NPM_REPOSITORY_URL=${REPOSITORY_URL}+${PATH-NPM-PRIVATE}   
        
        # node compile method
        # ng build
        
        # copy package.json to dist
        # cp package.json \dist
        # cd \dist
        
        # add publish registry in package.json ( note: find other method becuase url and token is present on registry. )
        # sed "s/\('publishConfig':\)/\1\""registry": "${NPM_REPOSITORY_URL}"\"\,/g" package.json
        
        # run npm publish
        npm publish --registry "${NPM_REPOSITORY_URL}"   # Nexus configure npm proxy and private registry.

        echo "::set-output name=registry-repository-id::$(echo ${PATH-NPM-PRIVATE})" 
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
