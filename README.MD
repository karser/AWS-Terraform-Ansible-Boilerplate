# AWS Infrastructure as Code with Terraform & Ansible

**API Deployment with Cognito Authentication and Private Database**

## Overview
This project demonstrates a cloud infrastructure deployment using Terraform and Ansible to create:
- Public-facing FastAPI web server with Cognito JWT authentication
- Private MySQL database instance
- AWS Cognito User Pool for authentication
- VPC architecture with NAT gateway
- IAM roles with permissions
- Credential management using AWS Secrets Manager

⚠️ **Important Notice**: This is a technical demonstration only. Use at your own risk. No guarantees of functionality or maintenance are provided.

## Features
- 🏗️ **VPC Architecture**: Public/private subnets with network access controls
- 🔑 **Cognito Integration**: JWT token validation for API endpoints
- 🔐 **Credential Management**: Database credentials stored/retrieved from AWS Secrets Manager
- 📦 **Infrastructure as Code**: Terraform configuration for AWS resources
- ⚙️ **Automated Provisioning**: Ansible playbooks for environment setup
- 🌐 **Network Isolation**: Database in private subnet with SSH access

## Architecture
```plaintext
                            +-----------------+
                            |   API Consumer  |
                            +--------+--------+
                                     |
                                     | HTTPS (Port 80)
                                     v
+------------------+        +--------+--------+        +------------------+
|   AWS Cognito    |        |  Public Subnet  |        |  Private Subnet  |
|  User Pool       +<-----> |  Web Server     +<-----> |  MySQL Database  |
|  (Auth)          | JWT    | (FastAPI)       | SSH    | (3306)           |
+------------------+        +-----------------+ Tunnel +------------------+

Access Rules:
- Web: Allow HTTP/80 and SSH/22
- DB: Allow MySQL/3306 from web server
```

## How to Use

### Prerequisites
- AWS account
- Terraform v1.10+
- Ansible v2.14+
- AWS CLI configured

### Deployment Steps
```bash
# Terraform Setup
cd terraform
cp terraform.tfvars.example terraform.tfvars  # Configure variables
terraform init
terraform plan
terraform apply -auto-approve

# Ansible Provisioning
cd ../ansible
ansible-playbook -i inventory/production/hosts.ini site.yml -v
```

## Cleanup
```bash
terraform destroy -auto-approve
```

## Important Notes
1. This is a demonstration project only
2. Not intended for production use
3. AWS resources may incur costs
4. Always verify resource deletion in AWS console
5. Configuration should be reviewed for your specific needs

## Cognito Example Workflow
```bash
# Create user (modify values accordingly)
aws cognito-idp sign-up \
  --region eu-west-3 \
  --client-id <CLIENT_ID> \
  --username user@example.com \
  --password TempPass123!

# Confirm user
aws cognito-idp admin-confirm-sign-up \
  --region eu-west-3 \
  --user-pool-id <POOL_ID> \
  --username user@example.com

# Set permanent password
aws cognito-idp admin-set-user-password \
  --region eu-west-3 \
  --user-pool-id <POOL_ID> \
  --username user@example.com \
  --password PermPass123! \
  --permanent

# Get JWT Token
aws cognito-idp initiate-auth \
  --auth-flow USER_PASSWORD_AUTH \
  --region eu-west-3 \
  --client-id <CLIENT_ID> \
  --auth-parameters USERNAME=user@example.com,PASSWORD=PermPass123!
```

## API Usage
```
# POST Request
curl -X POST \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{"value": "sample_data"}' \
  http://<WEB_PUBLIC_IP>/api/data

# GET Request
curl -X GET \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  http://<WEB_PUBLIC_IP>/api/data
```

## Contribution
This project is maintained as-is. Pull requests are welcome but no support is guaranteed.
