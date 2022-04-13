# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************
echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Getting SoapUI 5.6.0..."
echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
wget http://s3.amazonaws.com/downloads.eviware/soapuios/5.6.0/SoapUI-5.6.0-linux-bin.tar.gz -O ${{ github.workspace }}/.github/SoapUI-5.6.0-linux-bin.tar.gz
cd ${{ github.workspace }}/.github
tar -zxvf SoapUI-5.6.0-linux-bin.tar.gz

echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Getting sonar cli..."
echo "++++++++++++++++++++++++++++++++++++++++++++++++++"


echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Getting jp..."
echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
