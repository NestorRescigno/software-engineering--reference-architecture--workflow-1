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
SONAR_CLI       = %5
REF             = %6
GROUPID         = %7
ARTIFACTID      = %8
VERSION         = %9

# if url isn't empty then allow sonar for scanner code
if [ ${SONAR_URL} != "" && ${{ startsWith(${ REF }, 'refs/heads/main') }} == true ] then  
 
  echo "***************************************************"
  echo "Sonar scanner started..."
  echo "***************************************************"
  
  # install client version
  apt-get update
  apt-get install unzip wget nodejs
  mkdir /downloads/sonarqube -p
  cd /downloads/sonarqube
  wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_CLI}-linux.zip
  unzip sonar-scanner-cli-${SONAR_CLI}-linux.zip
  mv sonar-scanner-${SONAR_CLI}-linux /opt/sonar-scanner
  rm -r -f /downloads/sonarqube
  export PATH="$PATH:/opt/sonar-scanner/bin"
  # env | grep PATH
  sonar-scanner -v 

  if [${SONAR_LANGUAGE}=="java"] then

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
  
  elif [${SONAR_LANGUAGE}=="angular"] then
  
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
