#!/bin/bash


RESOURCE_GROUP=$1
ARTIFACT_PATH=$2
chmod 400 id_rsa

echo $ARTIFACT_PATH
ls -al $ARTIFACT_PATH

ARTIFACT_NAME=$(realpath $ARTIFACT_PATH/*.war)

echo $ARTIFACT_NAME

echo -e "Host 10.*\n \tStrictHostKeyChecking no" > ~/.ssh/config

sed -i "s,\#warfilePath\#,$warfilePath,g" deployscripts/vars.yaml

cat deployscripts/vars.yaml

echo "Create hosts file"
echo "[webservers]" > hosts 
az vm list --resource-group $RESOURCE_GROUP --show-details \
           --query "[?contains(name, 'web')].privateIps" -otsv >> hosts  

echo "Run Ansible Playbook"
ansible-playbook -i hosts deployscripts/tomcat_deploy.yaml --private-key id_rsa

