# OCM utilities

OCM provisioning automation scripts

- [HyperShift Terraform Setup Script](#HyperShift-Terraform-Setup-Script)
- [ROSA Cluster Provisioning Script](#ROSA-Cluster-Provisioning-Script)


## HyperShift Terraform Setup Script

This script automates the process of setting up a Terraform environment for HyperShift. It will create a directory, fetch the necessary Terraform configuration from a remote source, initialize Terraform, and then plan and apply the Terraform changes.

### Requirements

- `bash` (The script is written in Bash)
- `curl` (For fetching remote content)
- `terraform` (For handling infrastructure as code)

### Usage

1. Ensure you have the required tools (`bash`, `curl`, and `terraform`) installed.

2. Clone this repository or download the script directly.

3. Make the script executable:

```commandline
chmod +x setup.sh
```

4. Run the script, providing the necessary arguments:

```commandline
./hypershift_terraform_setup.sh --region <AWS_REGION> --cluster-name <CLUSTER_NAME>
```


Replace `<AWS_REGION>` with your desired AWS region (e.g., `us-east-1`) and `<CLUSTER_NAME>` with your desired cluster name (e.g., `my-cluster`).

### Parameters

- `--region` or `-r`: The AWS region where you want to deploy.

- `--cluster-name` or `-c`: The name of the cluster.

### Example

To set up Terraform for a cluster named `my-cluster` in the `us-east-1` region, run:

```commandline
./hypershift_terraform_setup.sh --region us-east-1 --cluster-name my-cluster
```


### Troubleshooting

If you encounter any issues, ensure that:

- You have the necessary permissions to create resources in the specified AWS region.
- The `terraform` tool is installed and available in your `PATH`.
- The `curl` tool is installed and available in your `PATH`.

## ROSA Cluster Provisioning Script

This script helps automate the process of provisioning a Red Hat OpenShift (ROSA) cluster on AWS with specific configurations.

### Prerequisites

- `bash`
- `terraform` (The script retrieves AWS subnet information using Terraform)
- `rosa` CLI tool (Used for various cluster provisioning tasks)
- `jq` (Used for parsing JSON responses)

### Features

- Parses command-line arguments to get AWS region and cluster name.
- Retrieves private and public subnet information using Terraform.
- Automatically creates IAM roles for the OpenShift nodes.
- Sets up the OIDC configuration.
- Provisions the OpenShift cluster.
- Shows real-time installation logs.

### Usage

1. Make sure you've set up your environment with the required tools (`bash`, `terraform`, `rosa`, and `jq`).

2. Ensure your AWS credentials are configured either through environment variables or AWS configuration files.

3. Make the script executable:

```commandline
chmod +x script_name.sh
```



4. Execute the script, providing the necessary arguments:

```commandline
./hypershift_cluster_provisioning.sh --region <AWS_REGION> --cluster-name <CLUSTER_NAME>
```

Replace `<AWS_REGION>` with your desired AWS region (e.g., `us-east-1`) and `<CLUSTER_NAME>` with your desired cluster name.

### Parameters

- `--region` or `-r`: The AWS region where the OpenShift cluster will be provisioned.  
- `--cluster-name` or `-c`: The name you want for your OpenShift cluster.

### Example

To provision an OpenShift cluster named `my-rosa-cluster` in the `us-east-1` region:

```commandline
./hypershift_cluster_provisioning.sh --region us-east-1 --cluster-name my-rosa-cluster
```

### Troubleshooting

1. Ensure that the `terraform` configurations in the `hypershift-tf` directory are correctly set up and initialized.
2. Make sure you have adequate permissions in AWS to create the required resources.
3. Check if `rosa` is authenticated correctly.
4. Ensure `jq` is correctly installed and available in your `PATH`.

