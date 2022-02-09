#!/bin/bash


RESOURCE_GROUP=$1

chmod 400 id_rsa

ARTIFACT_NAME=$(ls -Art /home/azadmin/agent/artifacts/*.war | tail -n 1)
echo $ARTIFACT_NAME

ARTIFACT_PATH=$(realpath $ARTIFACT_NAME)
echo $ARTIFACT_PATH

echo -e "Host 10.*\n \tStrictHostKeyChecking no" > ~/.ssh/config

sed -i "s,\#warfilePath\#,$ARTIFACT_PATH,g" deployscripts/vars.yaml

cat deployscripts/vars.yaml

echo "Create hosts file"
echo "[webservers]" > hosts 
az vm list --resource-group $RESOURCE_GROUP --show-details \
           --query "[?contains(name, 'web')].privateIps" -otsv >> hosts  

echo "Run Ansible Playbook"
ansible-playbook -i hosts deployscripts/tomcat_deploy.yaml --private-key id_rsa

