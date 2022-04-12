# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
echo "***************************************************"
echo "Registy artifact to nexus repository"
echo "***************************************************"

# setting variable
REPOSITORY_URL=%1
LANGUAGE=%2
ref = %3
workspace=%4

if [${REPOSITORY_URL} != ""] 
then
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
    else
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
    fi
    echo "***************************************************"
    echo "Registy complete"
    echo "***************************************************"
else
  echo "***************************************************"
  echo "Registy disable"
  echo "***************************************************"
fi  
