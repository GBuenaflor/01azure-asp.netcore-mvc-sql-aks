----------------------------------------------------------
#  Azure Kubernetes Services (AKS) - Part 04
##  Deploying ASP.net Core MVC and SQL Linux to AKS using Azure DevOps

High Level Architecture Diagram:

![Image description](https://github.com/GBuenaflor/01azure-asp.netcore-mvc-sql-aks/blob/master/Images/GB-AzureDevOps-AKS02.png)

Data Flow :

1. Developer Checkin Code to Github
2. AzureDevOps Pipeline triggers
3. CI Pipeline will build the images and push to container registry either Azure Container Registry or Docker Hub
4. CD Pipeline will deploy the images from container registry to Azure Kubernetes
5. ASP.net Core connects to SQL Linux container  or Azure SQL DB. SQL Linux container use Azure Storage Account to save data.
         
</br>
Link to other Microsoft Azure projects
https://github.com/GBuenaflor/01azure
</br>

Note: My Favorite > Microsoft Technologies
