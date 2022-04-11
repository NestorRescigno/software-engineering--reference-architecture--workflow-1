# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
#
# Setting variable
SONAR_URL = $1
SONAR_USER = $2
SONAR_PASS = $3
SONAR_LANGUAGE = $4
workspace = $5
# if url isn't empty then allow sonar for scanner code
if [ ${SONAR_URL} != ""]
then  
  echo "***************************************************"
  echo "Sonar scanner started..."
  echo "***************************************************"
  if [${SONAR_LANGUAGE}="java"]
  then
    # get information from pom
    groupId=$(sed -n 's,.*<groupId>\(.*\)</groupId>.*,\1,p' ${ workspace }/pom.xml | head -1)
    artifactId=$(sed -n 's,.*<artifactId>\(.*\)</artifactId>.*,\1,p' ${ workspace }/pom.xml | head -1)
    version=$(sed -n 's,.*<version>\(.*\)</version>.*,\1,p' ${ workspace }/pom.xml | head -1)
    SONAR_PROJECT_ID=${groupId}+":"+${artifactId}
    SONAR_VERSION_ID = ${version}
    
    # sonar scannar java setup
    sonar-scanner
      -Dsonar.login=${SONAR_USER}
      -Dsonar.password=${SONAR_PASS}
      -Dsonar.host.url=${SONAR_URL}
      -Dsonar.projectKey=${SONAR_PROJECT_ID}
      -Dsonar.projectName=${SONAR_PROJECT_ID}
      -Dsonar.projectVersion=${SONAR_VERSION_ID}
      -Dsonar.java.binaries=**/target/classes
      -Dsonar.language=java
  elif [${SONAR_LANGUAGE}="angular"]
  then
    # get information from package.json
    name=
    version=
    SONAR_PROJECT_ID = ${name}
    SONAR_VERSION_ID = ${version}
    
    # sonar scannar angular setup
    sonar-scanner
      -Dsonar.login=${SONAR_USER}
      -Dsonar.password=${SONAR_PASS}
      -Dsonar.host.url=${SONAR_URL}
      -Dsonar.projectKey=${SONAR_PROJECT_ID}
      -Dsonar.projectName=${SONAR_PROJECT_ID}
      -Dsonar.projectVersion=${SONAR_VERSION_ID}
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

# ************************** NOTE OF SEGURITY **********************************
# ***  sonar-scanner is script client by sonarqube to donwload                **    
# ***  form                                                                   **      
# *** https://binaries.sonarsource.com/?prefix=Distribution/sonar-scanner-cli/ *
# *** move this script on magine runner or create script                      **
# *** download in workflow process or call direct rest api                    **
# *** remove @action and reemplace with script download ( more segurity)      **
# ***  - name: Setup sonarqube                                                **
# ***  uses: warchant/setup-sonar-scanner@v3                                  **
# ******************************************************************************
