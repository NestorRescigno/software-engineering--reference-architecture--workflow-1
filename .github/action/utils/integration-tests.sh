# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
ACTIVE = %1
echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Integration tests executing"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
if [${ ACTIVE }==true] then
  cd ${{ github.workspace }}/.github/SoapUI-5.6.0/bin
  ./testrunner.sh -a -r ${{ github.workspace }}/integration-tests/*.xml
if
