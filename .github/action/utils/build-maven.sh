# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
# setting variable
workspace = $1
lenguage = $2
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
  echo "***************************************************"
  echo "End Building"
  echo "***************************************************"
else
  echo "***************************************************"
  echo "Artifact Agular Building"
  echo "***************************************************"
  if [ ${{ startsWith(github.ref, 'refs/heads/main') }} = true ]
  then 
   # not implement
   ng build ${ workspace }/package.json
  else
   # not implemen, in other reference may be have other build action commands
   ng build ${ workspace }/package.json
  fi
  echo "***************************************************"
  echo "End Angular Building"
  echo "***************************************************"
fi
