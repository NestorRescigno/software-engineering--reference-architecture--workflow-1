# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************
ACTIVE = %1
WORKSPACE=%2

# client aws download without action github
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# sudo ./aws/install 
# aws --version
# aws 

if [${ ACTIVE }==true] then
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo "Getting SoapUI 5.6.0..."
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
  wget http://s3.amazonaws.com/downloads.eviware/soapuios/5.6.0/SoapUI-5.6.0-linux-bin.tar.gz -O ${WORKSPACE}/.github/SoapUI-5.6.0-linux-bin.tar.gz
  cd ${WORKSPACE}/.github
  tar -zxvf SoapUI-5.6.0-linux-bin.tar.gz

  echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo "Getting sonar cli..."
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++"


  echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo "Getting jp..."
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
if
