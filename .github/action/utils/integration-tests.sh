echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Integration tests executing"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
cd ${{ github.workspace }}/.github/SoapUI-5.6.0/bin
./testrunner.sh -a -r ${{ github.workspace }}/integration-tests/*.xml
