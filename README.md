# hetzner-docker-deploy

This project uses Terraform to provision a virtual server on Hetzner Cloud, configure DNS via Cloudflare, and deploy a Docker image.

## Project Structure

- **terraform/main.tf**: Main configuration file defining resources and providers.
- **terraform/dns.tf**: Configuration for managing DNS records with Cloudflare.
- **terraform/terraform.tfvars**: Variables file specifying configurable options (based on __terraform/sample.tfvars__).
- **scripts/cloudflare.sh**: Install cloudflared and configure with your account.
- **templates/cloud-init.yaml**: Provision VM with everything you need.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- Hetzner Cloud API Token
- Cloudflare API Token

## Usage

### 1. Clone the repository

```bash
git clone https://github.com/eliagenini/hetzner-docker-deploy.git
cd hetzner-docker-deploy/terraform
```

### 2. Configure the variables

Update the terraform.tfvars file with your Hetzner and Cloudflare API tokens and any other required values.

### 3. Initialize Terraform

Run the following command to initialize Terraform:
```bash
terraform init
```

### 4. Deploy the Infrastructure

To create the server, configure DNS, and deploy the Docker image:
```bash
terraform apply -auto-approve
```

### 5. Destroy the Infrastructure

When done, you can destroy all the resources with:
```bash
terraform destroy -auto-approve
```

## Variables

Key variables you can configure in terraform/variables.tf include:

- **hetzner_token**: Hetzner Cloud API token.
- **cloudflare_email**: Cloudflare account email.
- **cloudflare_api_key**: Cloudflare API token.
- **domain_name**: Domain name to configure on Cloudflare.
- **docker_image**: Docker image to deploy.

## Outputs

After applying the Terraform configuration, outputs like the server's IP address and configured domain will be provided.