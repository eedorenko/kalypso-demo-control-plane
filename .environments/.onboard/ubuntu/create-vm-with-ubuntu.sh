#!/bin/bash

set -euo pipefail

RG_NAME="hello-world-rg"
VM_NAME="AnsibleVm"
IMAGE="Ubuntu2204"
USER_NAME="azureuser"
PASSWORD=Password12345!
LOCATION="centralus"

az vm create \
--resource-group $RG_NAME \
--name  $VM_NAME \
--image $IMAGE \
--admin-username $USER_NAME \
--admin-password $PASSWORD \
--location $LOCATION

az vm show -d -g $RG_NAME -n $VM_NAME --query publicIps -o tsv

ssh azureuser@<vm_ip_address>

# Install Ansible on Ubuntu

sudo apt update

sudo apt install software-properties-common

sudo add-apt-repository --yes --update ppa:ansible/ansible

sudo apt install ansible

# Install Ansible az collection for interacting with Azure. (optional)
ansible-galaxy collection install azure.azcollection --force 

# Install Ansible modules for Azure (optional)
sudo pip3 install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements.tx