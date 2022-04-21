# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
# ************* Type cloud  [azure, aws, google]          *************
# *********************************************************************
echo "***************************************************"
echo " configure cloud credentials..."
echo "***************************************************"
TYPE=$1
ID_KEY_ACCESSS=$2
ID_KEY_SECRET=$3

echo "***************************************************"
echo " configure terraform                               "
echo "***************************************************"

terraform -v
if echo $? = 128 ; then
    echo "The program 'terraform' is currently not installed."
    echo "install program 'terraform'..."
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update && sudo apt-get install terraform
    terraform -v
else
    echo "Continuing with terraform."
fi


if [${TYPE} == "aws"]
then
  echo "***************************************************"
  echo " configure aws cloud                               "
  echo "***************************************************"

  aws --version
  if echo $? = 128 ; then
      echo "The program 'aws' is currently not installed."
      echo "install program 'aws'..."
      # client aws download 
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      unzip awscliv2.zip
      sudo ./aws/install 
      aws --version
     
  else
      echo "Continuing with aws."
  fi
    # get credencial access to aws cloud  
    # Note of developer: is good to file ? boh! depends path and access privilage to magine. find more information.
    # test enviroment param
     aws configure -Daws_access_key_id=${ID_KEY_ACCESSS} -Daws_secret_access_key=${ID_KEY_SECRET} && clear
  
  echo "***************************************************"
  echo "configure complete"
  echo "***************************************************"
elif [${TYPE} == "azure"] then
  echo "***************************************************"
  echo "configure azure cloud isn't implement"
  echo "***************************************************"
  exit -1
elif [${TYPE} == "google"] then 
  echo "***************************************************"
  echo "configure google cloud isn't implement"
  echo "***************************************************"
  exit -1
else
  echo "***************************************************"
  echo "configure cloud credentials isn't correct"
  echo "***************************************************"
  exit -1
fi
