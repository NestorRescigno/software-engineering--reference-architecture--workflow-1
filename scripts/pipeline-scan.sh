#!/bin/bash
# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
#
# Setting variable
VERACODE_API_ID =
VERACODE_API_SECRET =
CI_TIMEOUT =
CI_BASELINE_PATH =
CI_PROJECT_PATH =
CI_REPOSITORY_URL =
CI_COMMIT_REF_NAME = $(echo ${{ github.ref}} | cut -c -63 | sed -E 's/[^a-z0-9-]+/-/g' | sed -E 's/^-*([a-z0-9-]+[a-z0-9])-*$$/\1/g')

. setup.sh

curl -O https://downloads.veracode.com/securityscan/pipeline-scan-LATEST.zip
unzip pipeline-scan-LATEST.zip pipeline-scan.jar
rm pipeline-scan-LATEST.zip

# run vera code with java.
# java -jar pipeline-scan.jar
#      --veracode_api_id "${VERACODE_API_ID}"
#      --veracode_api_key "${VERACODE_API_SECRET}"
#      --file "build/libs/sample.jar"
#      --fail_on_severity="Very High, High"
#      --fail_on_cwe="80"
#      --baseline_file "${CI_BASELINE_PATH}"
#      --timeout "${CI_TIMEOUT}"
#      --project_name "${CI_PROJECT_PATH}"
#      --project_url "${CI_REPOSITORY_URL}"
#      --project_ref "${CI_COMMIT_REF_NAME}"
#      --gl_vulnerability_generation true
#      añadir sanbox param. 