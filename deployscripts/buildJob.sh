#!/bin/bash

# This script runs build job and saves the artifact to local folder.
buildId=$1
echo $(Build.BuildId)
echo $(Build.BuildNumber)
echo $buildNumber $buildDir

artifactsPath="/home/azadmin/agent/artifacts"

mkdir -p $artifactsPath
# Compiling the Appliction with Maven.
mvn package     

# Save the file to the Artifacts here   
echo "Saving Artifact to Artifcats folder"   
cp $buildDir/s/target/petclinic.war $artifactsPath/petclinic_$buildId.war

