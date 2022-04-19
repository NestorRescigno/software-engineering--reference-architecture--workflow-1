# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

if [${REPOSITORY_URL} != ""] then

    # setting variable
    REPOSITORY_URL  ="https://"+%2+":"+%3+"@"+%1      # DNS can't content http or https, is necesary certificate 
    LANGUAGE        =%4
    REF             =%5
    
    # setting contants
    PATH-SNAPSHOTS      = "/repository/snapshots/"
    PATH-RELEASE        = "/repository/releases/"
    PATH-NPM-PRIVATE    = "/npm-private/release/" 
    
    echo "***************************************************"
    echo "Registy artifact to nexus repository"
    echo "***************************************************"

    if [${LANGUAGE} == "java"] then
        echo "***************************************************"
        echo "artifact type java"
        echo "***************************************************"
        
        if [ ${{ startsWith(${ REF }, 'refs/heads/develop') }} == true ] then
            echo "***************************************************"
            echo "upload snapshop"
            echo "***************************************************"
            
            SNAPSHOTS_REPOSITORY_URL = ${ REPOSITORY_URL } + ${PATH-SNAPSHOTS}
            mvn deploy -DaltSnapshotDeploymentRepository=ibis-snapshots::default::${ SNAPSHOTS_REPOSITORY_URL } 
            # --batch-mode

             # example deploy file with maven
             # mvn deploy:deploy-file 
             # -DgroupId=com.somecompany 
             # -DartifactId=project 
             # -Dversion=1.0.0 
             # -DgeneratePom=true 
             # -Dpackaging=jar 
             # -DrepositoryId=nexus 
             # -Durl=http://localhost:8081/repository/maven-releases 
             # -Dfile=target/project-1.0.0.jar
            
            echo "***************************************************"
            echo "upload complete"
            echo "***************************************************"
        elif [${{ startsWith(${ ref }, 'refs/heads/main') }} == true ] then
            echo "***************************************************"
            echo "upload release"
            echo "***************************************************"
            
            RELEASE_REPOSITORY_URL = ${ REPOSITORY_URL } + ${PATH-RELEASE}
            mvn deploy -DaltSnapshotDeploymentRepository=ibis-release::default::${ RELEASE_REPOSITORY_URL } 
            # --batch-mode
            
             # example deploy file with maven
             # mvn deploy:deploy-file 
             # -DgroupId=com.somecompany 
             # -DartifactId=project 
             # -Dversion=1.0.0 
             # -DgeneratePom=true 
             # -Dpackaging=jar 
             # -DrepositoryId=nexus 
             # -Durl=http://localhost:8081/repository/maven-releases 
             # -Dfile=target/project-1.0.0.jar
            

            echo "***************************************************"
            echo "upload complete"
            echo "***************************************************"
        fi
   elif [${LANGUAGE} == "angular"] then
   
      echo "***************************************************"
      echo "Artifact type angular"
      echo "***************************************************"
      
      if [${{ startsWith(${ REF }, 'refs/heads/main') }} == true ] then
   
        echo "***************************************************"
        echo "upload npm private release"
        echo "***************************************************"
        
        NPM_REPOSITORY_URL = ${ REPOSITORY_URL } + ${PATH-NPM-PRIVATE}   
        
        # node compile method
        # ng build
        
        # copy package.json to dist
        # cp package.json \dist
        # cd \dist
        
        # add publish registry in package.json ( note: find other method becuase url and token is present on registry. )
        # sed "s/\('publishConfig':\)/\1\""registry": "${NPM_REPOSITORY_URL}"\"\,/g" package.json
        
        # run npm publish
        npm publish --registry "${NPM_REPOSITORY_URL}"   # Nexus configure npm proxy and private registry.

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
else
  echo "***************************************************"
  echo "Registy disable"
  echo "***************************************************"
fi  
