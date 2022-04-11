# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
# Setting variable
SONAR_URL = $1
SONAR_USER = $2
SONAR_PASS = $3
SONAR_PROJECT_ID = $4
SONAR_LANGUAGE = $6
# if url isn't empty then allow sonar for scanner code
if [ ${SONAR_URL} != ""]
then  
  echo "***************************************************"
  echo "Sonar scanner started..."
  echo "***************************************************"
  if [${SONAR_LANGUAGE}="java"]
  then
    # sonar scannar java setup
    sonar-scanner
      -Dsonar.login=${SONAR_USER}
      -Dsonar.password=${SONAR_PASS}
      -Dsonar.host.url=${SONAR_URL}
      -Dsonar.projectKey=${SONAR_PROJECT_ID}
      -Dsonar.java.binaries=**/target/classes
      -Dsonar.language=java
  elif [${SONAR_LANGUAGE}="angular"]
  then
    # sonar scannar angular setup
    sonar-scanner
      -Dsonar.login=${SONAR_USER}
      -Dsonar.password=${SONAR_PASS}
      -Dsonar.host.url=${SONAR_URL}
      -Dsonar.projectKey=${SONAR_PROJECT_ID}
      -Dsonar.projectName=${SONAR_PROJECT_ID}
      -Dsonar.sourceEncoding=UTF-8
      -Dsonar.exclusions=**/node_modules/**
      -Dsonar.tests=src
      -Dsonar.test.inclusions=**/*.spec.ts
      -Dsonar.typescript.lcov.reportPaths=coverage/lcov.info
  else 
    echo "***************************************************"
    echo "Error lenguage select, options [java, angular]"
    echo "***************************************************"
    exit -1
  fi
  echo "***************************************************"
  echo "Sonar scanner complete..."
  echo "***************************************************"
else
  echo "***************************************************"
  echo "Sonar scanner is disable..."
  echo "***************************************************"
fi
