#!/bin/bash
# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by software Engineering             *************
# *********************************************************************
# setting variable
# ${{ env.SCRIPT }}/build.sh ${{ github.workspace }} ${{ env.LANGUAGE }} ${{ github.ref }}
sh ./setup.sh
 
# WORKSPACE=${{ github.workspace }}
LENGUAGE="java"
REF="refs/heads/develop"

if [ $LENGUAGE=="java" ] ; then
  echo "***************************************************"
  echo "Artifact java Building with maven"
  echo "***************************************************"

  if [[${REF} == 'refs/heads/main'* ]] ; then 
  
    mvn -B package --batch-mode --file ${WORKSPACE}/pom.xml

  elif [[${REF} == 'refs/heads/develop'* ]]  ; then
   
    mvn -B package --batch-mode --file ${WORKSPACE}/pom.xml
  
  fi

  # get information from pom.xml and create package name 
  echo "::set-output name=package-group::$(sed -n 's,.*<groupId>\(.*\)</groupId>.*,\1,p' ${WORKSPACE}/pom.xml | head -1)"  
  echo "::set-output name=package-artifact::$(sed -n 's,.*<artifactId>\(.*\)</artifactId>.*,\1,p' ${WORKSPACE}/pom.xml | head -1)"  
  echo "::set-output name=package-version::$(sed -n 's,.*<version>\(.*\)</version>.*,\1,p' ${WORKSPACE}/pom.xml | head -1)"  
  echo "::set-output name=package-type-id::$(sed -n 's,.*<packaging>\(.*\)</packaging>.*,\1,p' ${WORKSPACE}/pom.xml | head -1)"

  echo "***************************************************"
  echo "End Building"
  echo "***************************************************"
elif [ $LENGUAGE=="angular" ] ; then
  echo "***************************************************"
  echo "Artifact Angular Building"
  echo "***************************************************"
  
   if [[${REF} == 'refs/heads/main'* ]] ; then 

    ng build --Prod ${workspace}/package.json  # implement build configure production --Prod
    
   elif [[${REF} == 'refs/heads/develop'* ]] ; then

    ng build ${workspace}/package.json 

  fi
  
  # get information from package.json and create package name 
  echo "::set-output name=package-artifact::$(sed -n 's,.*"name":"\([^"]*\)".*,\1,p' ${WORKSPACE}/package.json)"  
  echo "::set-output name=package-version::$(sed -n 's,.*"version":"\([^"]*\)".*,\1,p' ${WORKSPACE}/package.json)"  
  
  # node deploy is simple package to web /dist. so it isn't library, check packaging type angular
  package = "zip"
  echo "::set-output name=package-type-id::$(echo ${package})"



  echo "***************************************************"
  echo "End Angular Building"
  echo "***************************************************"
else
  echo "***************************************************"
  echo "Error lenguage select, options [java, angular]"
  echo "***************************************************"
  exit -1
fi
