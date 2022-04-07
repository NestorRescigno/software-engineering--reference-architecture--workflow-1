
sonar-scanner
  -Dsonar.login=${{ env.SONAR_USER }}
  -Dsonar.password=${{ env.SONAR_PASS }}
  -Dsonar.host.url=${{ env.SONAR_URL }}
  -Dsonar.projectKey=${{ env.SONAR_PROJECT_ID }}
  -Dsonar.java.binaries=**/target/classes
  -DDsonar.language=java
