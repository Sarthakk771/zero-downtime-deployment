# Automated Zero-Downtime Deployment Platform

A containerized CI/CD deployment platform that automates application deployment to multiple AWS EC2 instances using GitHub Actions, Docker, Terraform, and an AWS Application Load Balancer.

The platform performs health-check validation during deployment and supports automatic rollback when a deployment fails.

## Technologies

- Python
- Flask
- Docker
- GitHub Actions
- AWS EC2
- AWS Application Load Balancer (ALB)
- AWS VPC
- AWS IAM
- AWS Systems Manager (SSM)
- Terraform
- Linux
- AWS CLI
- PowerShell

## Features

- Containerized Flask application
- Docker image build and deployment
- Two AWS EC2 application instances
- Application Load Balancer for traffic distribution
- Automated CI/CD using GitHub Actions
- GitHub OIDC authentication with AWS
- Infrastructure provisioning using Terraform
- EC2 health-check validation
- ALB target health validation
- Rolling deployment across two application instances
- Deployment validation
- Automatic rollback to the previous Docker image
- Application health endpoint
- Deployment monitoring dashboard

## Architecture

```text
                         GitHub
                            |
                            v
                    GitHub Actions
                            |
                    +-------+-------+
                    |               |
                    v               v
                 Test          Docker Build
                    |               |
                    +-------+-------+
                            |
                            v
                     AWS SSM Command
                            |
                +-----------+-----------+
                |                       |
                v                       v
             EC2 App 1              EC2 App 2
                |                       |
             Docker                  Docker
                |                       |
                +-----------+-----------+
                            |
                            v
                Application Load Balancer
                            |
                            v
                         Users

                         AWS Infrastructure

## CI/CD Pipeline

The GitHub Actions pipeline performs:

1. Checkout source code
2. Set up Python
3. Configure AWS credentials using OIDC
4. Install application dependencies
5. Validate Python application syntax
6. Build Docker image
7. Deploy to AWS EC2 App 1
8. Validate App 1 through ALB health checks
9. Deploy to AWS EC2 App 2
10. Validate App 2 through ALB health checks

Deployment flow:

```text
Git Push
   |
   v
GitHub Actions
   |
   v
Application Test
   |
   v
Docker Build
   |
   v
Deploy App 1
   |
   v
ALB Health Check
   |
   v
Deploy App 2
   |
   v
ALB Health Check
   |
   v
Production

## Rolling Deployment

The application is deployed sequentially across two AWS EC2 instances.

```text
App 1
  |
  v
Deploy New Version
  |
  v
Health Check
  |
  v
Healthy
  |
  v
App 2
  |
  v
Deploy New Version
  |
  v
Health Check
  |
  v
Healthy
  |
  v
Deployment Complete

## Health Checks

The Flask application provides a health-check endpoint:

```text
/health

## Automatic Rollback

The deployment script saves the previous Docker image before deploying a new version.

If the new deployment fails its health check, the system automatically removes the failed container and starts the previous stable Docker image.

```text
Deploy New Version
        |
        v
   Health Check
        |
   +----+----+
   |         |
Healthy    Failed
   |         |
   v         v
Continue   Rollback
             |
             v
      Previous Docker Image
             |
             v
       Health Check
             |
             v
      ROLLBACK SUCCESSFUL

      ## AWS Infrastructure

The AWS infrastructure is provisioned using Terraform.

The infrastructure includes:

- VPC
- Internet Gateway
- Two public subnets
- Route table
- Security groups
- Two EC2 instances
- IAM role and instance profile
- Application Load Balancer
- ALB target group
- ALB listener
- GitHub Actions OIDC provider
- GitHub Actions IAM role

## Project Structure

```text
zero-downtime-deployment/
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── app/
│   ├── app.py
│   ├── Dockerfile
│   └── requirements.txt
│
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── network.tf
│   ├── security.tf
│   ├── iam.tf
│   ├── ec2.tf
│   ├── alb.tf
│   ├── github-actions.tf
│   └── outputs.tf
│
├── deploy-aws.sh
├── deploy.ps1
├── docker-compose.yml
├── nginx.conf
├── .gitignore
└── README.md

## AWS Deployment

The AWS infrastructure is provisioned using Terraform.

Run the following commands:

```powershell
cd terraform
terraform init
terraform validate
terraform plan
terraform apply

## Local Testing

The application can also be tested locally using Docker Compose.

Run:

```powershell
docker compose up -d --build

## Verification

The project was verified using:

- Successful GitHub Actions CI/CD runs
- Two AWS EC2 application instances
- Application Load Balancer
- ALB target health checks
- Application `/health` endpoint
- ALB traffic distribution between App 1 and App 2
- Rolling deployment
- Controlled automatic rollback

## Project Outcome

The platform demonstrates an automated CI/CD deployment workflow using Docker, GitHub Actions, Terraform, and AWS.

It supports:

- Automated application deployment
- Load-balanced application instances
- Health-check based deployment validation
- Rolling deployment
- Automatic rollback to the previous stable version
- Infrastructure provisioning using Terraform