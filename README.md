# Terraform-Infrastructure-Deployment

## Problem Statement :

- SREs and DevOps engineers need an efficient way to manage and provision cloud infrastructure for applications.
- Manual deployment of applications and infrastructure can lead to errors, inconsistencies, and slower delivery.
- Tools like Terraform help automate the provisioning and management of Azure resources using code.
- CI/CD pipelines are required to automate the process of building, testing, and deploying applications

## Objectives : 

- Use Terraform to define and manage Azure infrastructure through code.
- Host and run a basic web application on the provisioned Azure infrastructure.
- Set up a CI/CD pipeline to automate Terraform provisioning and application deployment.
- Store Terraform code, application code, and configuration files in GitHub for proper version management.
- Configure the CI/CD pipeline to automatically run when changes are pushed to the GitHub repository.


## Project Folder Structure

```
Terraform-Infrastructure-Deployment/
│
├── .github/
│   └── workflows/
│       └── main_t-web-app.yml      # GitHub Actions CI/CD pipeline for Terraform and app deployment
│
├── flaskApp/
│   └── app.py                      # Simple Flask web application
│
├── .gitignore                      # Files and folders ignored by Git
│
├── main.tf                         # Main Terraform configuration for Azure resources
│
├── provider.tf                     # Azure provider configuration for Terraform
│
├── variable.tf                     # Terraform variables used in the project
│
├── package.json                    # Project dependencies and scripts
│
└── README.md                       # Project documentation
```

### main.tf

- Terraform & Provider Setup
Specifies that Terraform will use the AzureRM provider (version ~> 4.0) to create and manage Azure resources.

- Azure Authentication
Uses subscription ID, tenant ID, client ID, and client secret (from variables) to authenticate with Azure.

- Resource Group Creation
Creates an Azure Resource Group named rg-demo-web in West Europe to hold all resources.

- Storage Account Creation
Creates an Azure Storage Account named storageforstaticpage for storing application files or data.

- Random Number Generator
Generates a random number to make the web app name unique (Azure requires globally unique names).

- App Service Plan
Creates an App Service Plan (demo-serviceplan) on Linux using Basic tier (S1) which provides compute resources for the web app.

- Linux Web App Deployment
Creates a Linux Web App with Python 3.9 runtime to host the application.

- Application Settings
    Configures environment variables:
    - WEBSITE_RUN_FROM_PACKAGE = 1 → Runs the app from a deployment package.
    - STORAGE_ACCOUNT_NAME → Connects the web app with the created storage account.

- Dependency Management
Ensures the storage account is created before the web app using depends_on.

## package.json

- This file provides project metadata, versioning information, and basic script configuration for the repository.

## Provider.tf

- This configuration connects Terraform to Azure using service principal credentials so it can provision and manage cloud resources.

## variable.tf

- These variables store Azure authentication credentials, allowing Terraform to securely connect and provision resources in the specified Azure subscription

## app.py

- Import Flask – Imports the Flask framework used to build the web application.
- Create App Instance – app = Flask(__name__) initializes the Flask application.
- Define Route – @app.route("/") creates the home page route of the web app.
- Response Function – The hello() function returns the message "Hello from Azure Web App!" when    users visit the root URL.

Run the Application – app.run(host="0.0.0.0", port=8000) starts the web server and makes it accessible on port 8000.

## main_t-web-app.yml

- Workflow Trigger

    - Runs when code is pushed to the main branch.
    - Can also be started manually using workflow_dispatch.

- Build Job

    - Runs on Ubuntu latest runner.
    - Checks out repository code using actions/checkout.
    - Sets up Python 3.11 using actions/setup-python.
    - Creates a virtual environment for the project.
    - Installs project dependencies from requirements.txt.
    - Uploads the application as an artifact so it can be used in the deploy stage.

- Deploy Job

    - Runs after the build job completes.
    - Downloads the artifact created in the build stage.
    - Deploys the application to Azure Web App using azure/webapps-deploy.
    - Uses Azure publish profile stored in GitHub Secrets for secure authentication.

