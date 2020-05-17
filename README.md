----------------------------------------------------------
# Deploying ASP.net Core MVC and SQL Linux to Azure Kubernetes Service using Azure DevOps

High Level Architecture Diagram:

![Image description](https://github.com/GBuenaflor/01azure-asp.netcore-mvc-sql-aks/blob/master/GB-AzureDevOps-AKS.png)

Data Flow :

1. Developer Checkin Code to Github
2. AzureDevOps Pipeline triggers
3. CI Pipeline will build the images and push to container registry either Azure Container Registry or Docker Hub
4. CD Pipeline will deploy the images from container registry to Azure Kubernetes
5. ASP.net Core connects to SQL Linux container , this also can connect to Azure SQL DB. SQL Linux container use Azure Storage Account to save data.
        
----------------------------------------------------------
# Deploying Azure Kubernetes Service using Terraform using Azure DevOps - IaC

High Level Architecture Diagram: (To Follow)

Data Flow :

1. Create Service Account to configure the AKS Cluster using Terraform
2. Create Azure DevOps Connections - Azure ARM
3. Install Terraform Plugins
4. Create new Azure DevOps Pipeline


Note: My favorite -> Microsoft technologies, see you guys soon.
