#!/bin/bash
# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
ACTIVE = ${{ env.TEST }}
WORKSPACE = ${{ github.workspace }}
VERSION = "5.6.0"

echo "**************************************************"
echo "Integration tests executing"
echo "**************************************************"

if [${ ACTIVE }==true] then
  echo "**************************************************"
  echo "Getting SoapUI ${VERSION}..."
  echo "**************************************************"
  
  wget http://s3.amazonaws.com/downloads.eviware/soapuios/${VERSION}/SoapUI-${VERSION}-linux-bin.tar.gz -O ${WORKSPACE}/.github/SoapUI-${VERSION}-linux-bin.tar.gz
  cd ${WORKSPACE}/.github
  tar -zxvf SoapUI-${VERSION}-linux-bin.tar.gz
  rm SoapUI-${VERSION}-linux-bin.tar.gz
 
  echo "**************************************************"
  echo "find test..."  
  echo "**************************************************"

  # find file xml soapui with define endpoint.
  cd ${WORKSPACE}/.github/SoapUI-${VERSION}/bin 
  ./testrunner.sh -a -r ${WORKSPACE}/integration-tests/*.xml # Note of developer: may be it have more file, find all or select one. discution progress...
  
  echo "**************************************************"
  echo "complete test runner..." 
  echo "**************************************************"
if
