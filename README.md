# Automated Zero-Downtime Deployment Platform

A containerized deployment platform that demonstrates rolling deployments, health-check validation, load balancing, and automatic rollback using Docker, Python, Nginx, and GitHub Actions.

## Technologies

- Python
- Flask
- Docker
- Docker Compose
- Nginx
- PowerShell
- GitHub Actions
- Linux / WSL

## Features

- Containerized Flask application
- Two application instances
- Nginx load balancing
- Application health checks
- Rolling deployment
- Deployment validation
- Automatic rollback
- GitHub Actions CI pipeline

## Architecture

```text
GitHub
   |
   v
GitHub Actions
   |
   v
Docker
   |
   +----------+----------+
   |                     |
   v                     v
 App 1                 App 2
Server 1              Server 2
   |                     |
   +----------+----------+
              |
              v
        Nginx Load Balancer
              |
              v
           Browser

           ## Project Structure

```text
zero-downtime-deployment/
├── .github/
│   └── workflows/
│       └── ci.yml
├── app/
│   ├── app.py
│   ├── Dockerfile
│   └── requirements.txt
├── deploy.ps1
├── docker-compose.yml
├── nginx.conf
└── README.md

## Running the Application

Start the application containers:

```powershell
docker compose up -d --build

## Health Checks

Check App 1:

```powershell
Invoke-WebRequest http://localhost:5000/health -UseBasicParsing

## Rolling Deployment

Run the deployment script:

```powershell
powershell -ExecutionPolicy Bypass -File .\deploy.ps1

## Automatic Rollback

If a deployment health check fails, the script automatically restores the previous stable version.

```text
Deploy New Version
        |
        v
   Health Check
        |
   +----+----+
   |         |
 Healthy   Failed
   |         |
   v         v
Continue   Rollback
             |
             v
     Previous Version 
     ## GitHub Actions

The project includes a GitHub Actions CI pipeline that:

- Checks out the repository
- Sets up Python
- Installs application dependencies
- Checks Python syntax
- Builds the Docker image

Workflow file:

```text
.github/workflows/ci.yml

## Project Scope

This project demonstrates zero-downtime deployment concepts using a local Docker environment.

The current implementation uses Docker, Nginx, Python, PowerShell, and GitHub Actions. AWS EC2, AWS ALB, and Terraform are not included in the current implementation.