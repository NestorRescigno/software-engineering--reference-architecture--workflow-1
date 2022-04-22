# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
echo "***************************************************"
echo " Setup                                             "
echo "***************************************************"
version-jdk=11
version-node=14 #no implement download last 
# node js
node -v
if echo $? = 128 ; then
    echo "The program 'node' is currently not installed."
    echo "install program 'node'..."
    sudo apt-get update && sudo apt-get install nodejs
    node -v
else
    echo "Continuing with node."
fi

# java runtime 11
java -v
if echo $? = 128 ; then
    echo "The program 'java openjdk' is currently not installed."
    echo "install program 'java openjdk'..."
    sudo apt-get update && sudo apt-get install openjdk-${version-jdk}-jdk
    java -v
else
    echo "Continuing with java openjdk."
fi

echo "***************************************************"
echo " setup complete"
echo "***************************************************"
