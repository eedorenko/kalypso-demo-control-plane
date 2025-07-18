#!/bin/bash

# See https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/secret-store-extension?tabs=arc-k8s
# It is necessarily to create federated identity credentials for each service account that accesses resources on the cluster (maximum 20)
# Flexible federated identity (https://learn.microsoft.com/en-us/entra/workload-id/workload-identities-flexible-federated-identity-credentials?tabs=github) 
# is not supported for K8s service accounts yet. It is supported for GitHub, GitLab and Terraform Cloud only

# Usage: ./add-identity0credentials.sh <CLUSTER_NAME> <RESOURCE_GROUP> <KUBERNETES_NAMESPACE> <SERVICE_ACCOUNT_NAME> <USER_ASSIGNED_IDENTITY_NAME>
# Example: ./add-identity0credentials.sh my-cluster hello-world-rg my-namespace my-service-account k3s-cluster-identity




CLUSTER_NAME=$1
RESOURCE_GROUP=$2
KUBERNETES_NAMESPACE=$3
SERVICE_ACCOUNT_NAME=$4
USER_ASSIGNED_IDENTITY_NAME=$5

FEDERATED_IDENTITY_CREDENTIAL_NAME="${CLUSTER_NAME}-${SERVICE_ACCOUNT_NAME}"
SERVICE_ACCOUNT_ISSUER="$(az connectedk8s show \
                            --name ${CLUSTER_NAME} \
                            --resource-group ${RESOURCE_GROUP} \
                            --query "oidcIssuerProfile.issuerUrl" --output tsv)"


az identity federated-credential create \
    --name ${FEDERATED_IDENTITY_CREDENTIAL_NAME} \
    --identity-name ${USER_ASSIGNED_IDENTITY_NAME} \
    --resource-group ${RESOURCE_GROUP} \
    --issuer ${SERVICE_ACCOUNT_ISSUER} \
    --subject system:serviceaccount:${KUBERNETES_NAMESPACE}:${SERVICE_ACCOUNT_NAME} \
    --audience api://AzureADTokenExchange
