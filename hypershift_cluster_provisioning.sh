#!/bin/bash

# Set default values for variables
AWS_REGION=""
CLUSTER_NAME=""

# Parse command line arguments for AWS region and cluster name
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -r|--region) AWS_REGION="$2"; shift ;;
        -c|--cluster-name) CLUSTER_NAME="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check if necessary arguments are provided
if [[ -z "$AWS_REGION" ]] || [[ -z "$CLUSTER_NAME" ]]; then
    echo "Usage: $0 --region <region> --cluster-name <cluster_name>"
    exit 1
fi

PRIVATE_SUBNET=`terraform -chdir=./hypershift-tf output -raw cluster-private-subnet`
PUBLIC_SUBNET=`terraform -chdir=./hypershift-tf output -raw cluster-public-subnet`

# Creates IAM roles that wiill be used by OpenShift nodes to interact with AWS
rosa create account-roles -f --mode auto --hosted-cp

# Creates oidc configuration
OIDC_ID=$(rosa create oidc-config --mode auto --yes -o json | jq -r '.id')

echo "Provisioning cluster with vars"
echo "CLUSTER_NAME " $CLUSTER_NAME
echo "PUBLIC_SUBNET " $PUBLIC_SUBNET
echo "PRIVATE_SUBNET " $PRIVATE_SUBNET
echo "REGION " $AWS_REGION
echo "OIDC_ID " $OIDC_ID

# Checking that all arguments provided
if [[ -z $CLUSTER_NAME ]] ||[[ -z $PUBLIC_SUBNET ]] || [[ -z $PRIVATE_SUBNET ]] || [[ -z $AWS_REGION ]] || [[ -z $OIDC_ID ]]; then
  echo 'Missing argument, check for the table before'
  return 1
fi

#Cluster creation
rosa create cluster --cluster-name $CLUSTER_NAME --sts --mode auto --hosted-cp --region us-east-1 --oidc-config-id $OIDC_ID --subnet-ids $PUBLIC_SUBNET,$PRIVATE_SUBNET -y

#Check out installation process in real time
rosa logs install -c $CLUSTER_NAME --region $AWS_REGION --watch

