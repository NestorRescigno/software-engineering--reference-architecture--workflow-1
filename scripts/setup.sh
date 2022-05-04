#!/bin/bash
# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
echo "***************************************************"
echo " Setup                                             "
echo "***************************************************"
versionjdk=11
versionnode=14 #no implement download last 
# node js
node -v
if [ $?==128 ] ; then
    echo "The program 'node' is currently not installed."
    echo "install program 'node'..."
    sudo apt-get update && sudo apt-get install nodejs
    node -v
else
    echo "Continuing with node."
fi

# java runtime 11
java -version
if [ $?==128 ] ; then
    echo "The program 'java openjdk' is currently not installed."
    echo "install program 'java openjdk'..."
    sudo apt-get update && sudo apt-get install openjdk-${versionjdk}-jdk
    java -v
else
    echo "Continuing with java openjdk."
fi

echo "***************************************************"
echo " setup complete"
echo "***************************************************"
