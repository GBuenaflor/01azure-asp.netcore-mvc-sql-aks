----------------------------------------------------------
# Deploying ASP.net Core MVC and SQL Linux to Azure Kubernetes Service using Azure DevOps

High Level Architecture Diagram:

![Image description](https://github.com/GBuenaflor/01azure-asp.netcore-mvc-sql-aks/blob/master/GB-AzureDevOps-AKS.png)

Data Flow :

1. Developer Checkin Code to Github
2. AzureDevOps Pipeline triggers
3. CI Pipeline will build the images and push to container registry either Azure Container Registry or Docker Hub
4. CD Pipeline will deploy the images from container registry to Azure Kubernetes
5. ASP.net Core connects to SQL Linux container  or Azure SQL DB. SQL Linux container use Azure Storage Account to save data.
        
----------------------------------------------------------
# Provisioning Azure Kubernetes Service with Terraform using Azure DevOps - IaC

High Level Architecture Diagram: 

![Image description](https://github.com/GBuenaflor/01azure-asp.netcore-mvc-sql-aks/blob/master/GB-AzureDevOps-AKS-IaC.png)

Configuration Flow :

1. Install Terraform Plugins to your Development Machine
2. Check-in Terraform Codes to Github.
3. Create new Azure DevOps Release Pipeline with service connection to Azure ARM, this will provision AKS Cluster to Azure.
4. Terraform Apply command will provision AKS Cluster to Azure.
5. Terraform Destroy command will de-provision AKS Cluster to Azure.  

Note: During code checkin, pipeline will trigger to provision the environment to Azure.Once Provisioned, Pipeline can be enable/disable.


Note: My Favorite > Microsoft Technologies
