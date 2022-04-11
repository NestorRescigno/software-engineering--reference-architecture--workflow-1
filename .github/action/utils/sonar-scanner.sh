# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
# Setting variable
SONAR_URL = $1
SONAR_USER = $2
SONAR_PASS = $3
SONAR_PROJECT_ID = $4
SONAR_TARGET_PATH = $5
SONAR_LANGUAGE = $6
# if url isn't empty then allow sonar for scanner code
if [ ${SONAR_URL} != ""]
then  
  echo "***************************************************"
  echo "Sonar scanner started..."
  echo "***************************************************"
  sonar-scanner
    -Dsonar.login=${SONAR_USER}
    -Dsonar.password=${SONAR_PASS}
    -Dsonar.host.url=${SONAR_URL}
    -Dsonar.projectKey=${SONAR_PROJECT_ID}
    -Dsonar.java.binaries={SONAR_TARGET_PATH}
    -DDsonar.language=${SONAR_LANGUAGE}
  echo "***************************************************"
  echo "Sonar scanner complete..."
  echo "***************************************************"
else
  echo "***************************************************"
  echo "Sonar scanner is disable..."
  echo "***************************************************"
fi
