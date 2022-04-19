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

  if [ ${{ startsWith(github.ref, 'refs/heads/main') }} = true ]
  then 
    #pom.xml maven compile, it's need present in root repository.  
    mvn -B package --file ${ workspace }/pom.xml    
  else
    #pom.xml maven compile, it's need present in root repository.
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
  
   if [ ${{ startsWith(github.ref, 'refs/heads/main') }} = true ]
  then 
    # not implement
    ng build ${ workspace }/package.json
  else
    # not implemen, in other reference may be have other build action commands
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
