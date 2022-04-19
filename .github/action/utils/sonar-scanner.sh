# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
#
# Setting variable
SONAR_URL       = %1
SONAR_USER      = %2
SONAR_PASS      = %3
SONAR_LANGUAGE  = %4
REF             = %5
GROUPID         = %6
ARTIFACTID      = %7
VERSION         = %8

# if url isn't empty then allow sonar for scanner code
if [ ${SONAR_URL} != "" && ${{ startsWith(${ REF }, 'refs/heads/main') }} = true ] then  
 
  echo "***************************************************"
  echo "Sonar scanner started..."
  echo "***************************************************"


  if [${SONAR_LANGUAGE}="java"] then

    # sonar scannar java setup
    sonar-scanner
      -Dsonar.login=${SONAR_USER}
      -Dsonar.password=${SONAR_PASS}
      -Dsonar.host.url=${SONAR_URL}
      -Dsonar.projectKey=${GROUPID}+":"+${ARTIFACTID}
      -Dsonar.projectName=${GROUPID}+":"+${ARTIFACTID}
      -Dsonar.projectVersion=${VERSION}
      -Dsonar.java.binaries=**/target/classes
      -Dsonar.language=java
  
  elif [${SONAR_LANGUAGE}="angular"] then
  
    # sonar scannar angular setup
    sonar-scanner
      -Dsonar.login=${SONAR_USER}
      -Dsonar.password=${SONAR_PASS}
      -Dsonar.host.url=${SONAR_URL}
      -Dsonar.projectKey=${ARTIFACTID}
      -Dsonar.projectName=${ARTIFACTID}
      -Dsonar.projectVersion=${VERSION}
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
