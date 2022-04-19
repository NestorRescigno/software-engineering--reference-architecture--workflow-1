# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
# setting variable
workspace = %1
lenguage = %2
if [${lenguage}="java"]
then
  echo "***************************************************"
  echo "Artifact java Building with maven"
  echo "***************************************************"

  if [ ${{ startsWith(github.ref, 'refs/heads/main') }} = true ] then 
  
    mvn -B package --file ${ workspace }/pom.xml    
  
  elif [ ${{ startsWith(github.ref, 'refs/heads/develop') }} = true ]
   
    mvn -B package --file ${ workspace }/pom.xml    
  
  fi

  # get information from pom.xml and create package name 
  echo "::set-output name=package-group::$(sed -n 's,.*<groupId>\(.*\)</groupId>.*,\1,p' ${ WORKSPACE }/pom.xml | head -1)"  
  echo "::set-output name=package-artifact::$(sed -n 's,.*<artifactId>\(.*\)</artifactId>.*,\1,p' ${ WORKSPACE }/pom.xml | head -1)"  
  echo "::set-output name=package-version::$(sed -n 's,.*<version>\(.*\)</version>.*,\1,p' ${ WORKSPACE }/pom.xml | head -1)"  

  echo "***************************************************"
  echo "End Building"
  echo "***************************************************"
elif [${lenguage}="angular"]
then
  echo "***************************************************"
  echo "Artifact Angular Building"
  echo "***************************************************"
  
   if [ ${{ startsWith(github.ref, 'refs/heads/main') }} = true ] then 

    ng build --Prod ${ workspace }/package.json  # implement build configure production --Prod

  elif [ ${{ startsWith(github.ref, 'refs/heads/develop') }} = true ]

    ng build ${ workspace }/package.json 

  fi
  
  # get information from package.json and create package name 
  echo "::set-output name=package-artifact::$(sed -n 's,.*"name":"\([^"]*\)".*,\1,p' ${ WORKSPACE }/package.json)"  
  echo "::set-output name=package-version::$(sed -n 's,.*"version":"\([^"]*\)".*,\1,p' ${ WORKSPACE }/package.json)"  

  echo "***************************************************"
  echo "End Angular Building"
  echo "***************************************************"
else
  echo "***************************************************"
  echo "Error lenguage select, options [java, angular]"
  echo "***************************************************"
  exit -1
fi
