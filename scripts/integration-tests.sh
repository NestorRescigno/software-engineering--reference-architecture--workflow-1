#!/bin/bash
# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
VERSIONSOAPUI = "5.6.0"

echo "**************************************************"
echo "Integration tests executing"
echo "**************************************************"

if $ACTIVE
then
  echo "**************************************************"
  echo "Getting SoapUI ${VERSION}..."
  echo "**************************************************"
  
  wget http://s3.amazonaws.com/downloads.eviware/soapuios/${VERSIONSOAPUI}/SoapUI-${VERSIONSOAPUI}-linux-bin.tar.gz -O ${WORKSPACE}/.github/SoapUI-${VERSIONSOAPUI}-linux-bin.tar.gz
  cd ${WORKSPACE}/.github
  tar -zxvf SoapUI-${VERSIONSOAPUI}-linux-bin.tar.gz
  rm SoapUI-${VERSIONSOAPUI}-linux-bin.tar.gz
 
  echo "**************************************************"
  echo "find test..."  
  echo "**************************************************"

  # find file xml soapui with define endpoint.
  cd ${WORKSPACE}/.github/SoapUI-${VERSIONSOAPUI}/bin 
  ./testrunner.sh -a -r ${WORKSPACE}/integration-tests/*.xml # Note of developer: may be it have more file, find all or select one. discution progress...
  
  echo "**************************************************"
  echo "complete test runner..." 
  echo "**************************************************"
if
