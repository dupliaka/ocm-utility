#!/bin/bash

# Check out if terraform exist and its executable listed in PATH
if command -v terraform &> /dev/null; then
    echo "Terraform is installed."
    terraform version
else
    echo "Terraform is not installed."
fi

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

# Create directory and navigate into it
DIR_NAME="hypershift-tf"
if ! mkdir -p "$DIR_NAME"; then
    echo "Failed to create directory $DIR_NAME."
    exit 1
fi
cd "$DIR_NAME"

# Download Terraform configuration
TF_FILE_URL="https://raw.githubusercontent.com/openshift-cs/OpenShift-Troubleshooting-Templates/master/rosa-hcp-terraform/setup-vpc.tf"
if ! curl -s -o setup-vpc.tf "$TF_FILE_URL"; then
    echo "Failed to download Terraform configuration."
    exit 1
fi

# Initialize Terraform
if ! terraform init; then
    echo "Terraform initialization failed."
    exit 1
fi

# Plan Terraform changes
if ! terraform plan -out rosa.plan -var "aws_region=$AWS_REGION" -var "cluster_name=$CLUSTER_NAME"; then
    echo "Terraform planning failed."
    exit 1
fi

# Apply Terraform changes
if ! terraform apply rosa.plan; then
    echo "Terraform apply failed."
    exit 1
fi

#terraform destroy -var 'aws_region=us-east-1'
echo "Script completed successfully!"
