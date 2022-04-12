# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************

if [${REPOSITORY_URL} != ""] 
then
    echo "***************************************************"
    echo "Registy artifact to nexus repository"
    echo "***************************************************"

    # setting variable
    
    REPOSITORY_URL="https://"+%2+":"+%3+"@"+%1      # DNS can't content http or https, is necesary certificate 
    LANGUAGE=%4
    ref = %5
    
    if [${LANGUAGE} = "java"]
    then
    echo "***************************************************"
    echo "artifact type java"
    echo "***************************************************"
      if [ ${{ startsWith(${ ref }, 'refs/heads/develop') }} = true ]
      then
        echo "***************************************************"
        echo "upload snapshop"
        echo "***************************************************"
        SNAPSHOTS_REPOSITORY_URL = ${ REPOSITORY_URL } + "/repository/snapshots/"
        mvn deploy -DaltSnapshotDeploymentRepository=ibis-snapshots::default::${ SNAPSHOTS_REPOSITORY_URL } 
        # --batch-mode
        echo "***************************************************"
        echo "upload complete"
        echo "***************************************************"
      elif [${{ startsWith(${ ref }, 'refs/heads/main') }} = true ]
        echo "***************************************************"
        echo "upload release"
        echo "***************************************************"
        RELEASE_REPOSITORY_URL = ${ REPOSITORY_URL } + "/repository/releases/"
        mvn deploy -DaltSnapshotDeploymentRepository=ibis-release::default::${ RELEASE_REPOSITORY_URL } 
        # --batch-mode
        echo "***************************************************"
        echo "upload complete"
        echo "***************************************************"
      fi
    elif [${LANGUAGE} = "angular"]
      echo "***************************************************"
      echo "artifact type angular"
      echo "***************************************************"
      if [ ${{ startsWith(${ ref }, 'refs/heads/develop') }} = true ]
      then
        echo "***************************************************"
        echo "upload snapshop"
        echo "***************************************************"
        
         # pending implement deploy to repository
         
        echo "***************************************************"
        echo "upload complete"
        echo "***************************************************"
         
      elif [${{ startsWith(${ ref }, 'refs/heads/main') }} = true ]
        echo "***************************************************"
        echo "upload release"
        echo "***************************************************"
        
        # pending implement deploy to repository
        
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
