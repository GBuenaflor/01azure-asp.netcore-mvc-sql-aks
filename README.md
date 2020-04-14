# 01azure-asp.netcore-mvc-sql-aks

Deploy Asp.net Core MVC and SQL Linux to Azure Kubernetes.

#-----------------------------------------------------------------------------------
# Configure Development Environment using Azure VM
#-----------------------------------------------------------------------------------

- Provision Azure Windows 10 EnterpriseN, Verion 1809
- Install HyPer-V and Containers Role
- Install Docker for Windows
  https://docs.docker.com/docker-for-windows/install/
- Install VS2019 Community Edition  
  https://visualstudio.microsoft.com/vs/compare/
- Install SQL Express 2017 
  https://www.microsoft.com/en-us/download/details.aspx?id=55994
- Install SSMS
      https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?redirectedfrom=MSDN&view=sql-server-ver15

#-----------------------------------------------------------------------------------
# Run the Container using docker-compose
#-----------------------------------------------------------------------------------
# Download the project and extract to this path "C:\_1" 

docker-compose -f "C:\_1\Web01\docker-compose.yml" -f "C:\_1\Web01\docker-compose.override.yml" up -d
docker ps
docker images
docker-compose down

#-----------------------------------------------------------------------------------
# Create Azure Container Registry using Azure CLI
#-----------------------------------------------------------------------------------
az login

# Create Resource group
# az group create --name <rgName> --location eastus
az group create --name devRG --location eastus
  
 
# Create Azure container registry
# az acr create --resource-group myResourceGroup --name <acrName> --sku Basic --admin-enabled true
  az acr create --resource-group devRG --name dev2acr --sku Basic --admin-enabled true


# Log in to container registry
# az acr login --name <acrName>
  az acr login --name dev02acr

# Show container image from ACR
# az acr show --name <acrName> --query loginServer --output table
  az acr show --name dev02acr --query loginServer --output table
  
# Tag the weblinux1 image with the loginServer of container registry
# docker tag <Repository> <acrLoginServer>/aci-tutorial-app:v1  
docker tag web01 dev02acr.azurecr.io/web01aspnetcore-app:v1
docker tag  microsoft/mssql-server-linux dev02acr.azurecr.io/sqllinux:v1
 
 
#-----------------------------------------------------------------------------------
# Push Image to ACR using Azure CLI
#-----------------------------------------------------------------------------------

# Push image to Azure Container Registry
# docker push <acrLoginServer>/aci-tutorial-app:v1 
docker push dev02acr.azurecr.io/web01aspnetcore-app:v1
docker push dev02acr.azurecr.io/sqllinux:v1
 

# List images in Azure Container Registry
# az acr repository list --name <acrName> --output table
  az acr repository list --name dev02acr --output table

# View the tags for a specific images
# az acr repository show-tags --name <acrName> --repository aci-tutorial-app --output table
  az acr repository show-tags --name dev02acr --repository web01aspnetcore-app --output table
  
#-----------------------------------------------------------------------------------
# Push Image to DockerHub using Azure CLI
#-----------------------------------------------------------------------------------

docker login
# Provide your userName and Passwrod

docker container list- a

#WARNING: login credentials saved in /home/username/.docker/config.json

docker tag web01 gbbuenaflor/web01aspnetcore-app:v1
docker tag  microsoft/mssql-server-linux gbbuenaflor/sqllinux:v1

docker images
 
docker push gbbuenaflor/web01aspnetcore-app:v1
docker push gbbuenaflor/sqllinux:v1


#-----------------------------------------------------------------------------------
# Deploy AKS Cluster using Azure CLI
#-----------------------------------------------------------------------------------
# https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest
 
 
$resourcegroup='devRG'
$location='East US'
$clusterName='DevAKSCluster'
$nodeVMSize='Standard_DS1_v2'
$nodeCount=2
$minCount=1
$maxCount=5
 
az aks create --resource-group $resourcegroup --location $location --name $clusterName --node-count $nodeCount --node-vm-size $nodeVMSize --enable-addons monitoring --generate-ssh-keys --disable-rbac --enable-cluster-autoscaler --min-count $minCount --max-count $maxCount --verbose
 
 
 
#------------------------------------------------------
# Get AKS Credentials
az aks get-credentials --resource-group $resourcegroup --name $clusterName

kubectl version
kubectl get nodes
kubectl get ns
kubectl get services
kubectl get services --namespace=kube-system

kubectl get config get-clusters

#-------------------------------------------------------
# Open Kubernentes Dash Board

$resourcegroup='devRG' 
$clusterName='DevAKSCluster' 

# kubectl get proxy 
az aks browse --resource-group $resourcegroup --name $clusterName
az aks browse --resource-group Dev02 --name DevAKSCluster
 
 

#-------------------------------------------------------
# Generate Secret Key 
https://kubernetes.io/docs/concepts/configuration/secret/


echo -n 'admin' | base64

echo -n 'Server=mssql-service;Database=Web01DB;User=SA;Password=VM12345!@#12345;' | base64 > ./web01ConnectionString.txt
Get-Content ./web01ConnectionString.txt

U2VydmVyPW1zc3FsLXNlcnZpY2U7RGF0YWJhc2U9V2ViMDFEQjtVc2VyPVNBO1Bhc3N3b3JkPVZNMTIzNDUhQCMxMjM0NTsK

#-----------------------------------------------------------------------------------
# Deploy asp.net core mvc and sql linux to Azure Kubernetes
#-----------------------------------------------------------------------------------
# gbbuenaflor/web01aspnetcore-app:v1
# gbbuenaflor/sqllinux:v1 
# microsoft/mssql-server-linux


kubectl apply -f 01mssql-secret.yaml --record
kubectl apply -f 02mssql-config-map.yaml --record
kubectl apply -f 03mssql-pv.azure.yaml --record
kubectl apply -f 04mssql-deployment.yaml --record
kubectl apply -f 04mssql-deployment-ext.yaml --record
kubectl apply -f 05mvc-deployment.azure.yaml --record

kubectl get ns
kubectl get pods --namespace=default
kubectl get service --namespace=default
kubectl get pvc --namespace=default

kubectl get replicaset
kubectl rollout status deployment mvc-deployment
kubectl rollout status deployment mssql-deployment


#-------------------------------------------------------
# Open Kubernentes Dash Board

$resourcegroup='devRG' 
$clusterName='DevAKSCluster' 
 
az aks browse --resource-group $resourcegroup --name $clusterName 
  
#-------------------------------------------------------
# Conecting SSMS to SQL Linux Container

- Login to Dev Machine
- Get SQl Load Balancer IP  
   kubectl get svc

- Connect to SQL Linux via SSMS

  ServerName     : 52.188.75.41,1433
  Authentication : SQL Server Authentication
  Login          : sa
  Password       : [Password provided in the config file]
  
  
#-----------------------------------------------------------------------------------
# Deploy asp.net core mvc and sql linux to Azure Kubernetes using HELM
#-----------------------------------------------------------------------------------
# YOu can also use Azure CLI from the portal, upload the project file into this drectory and run the comand below
# cd /usr/csuser/clouddrive/Web01.kubernetes.Helm/

helm init
helm version
  

# Create Package , Install the package
helm package helm-web01
helm install helm-web01 --name helm-web01 


#-------------------------------------------------------
# Check the application

kubectl get ns 
helm status helm-web01

kubectl get services --namespace=helm-web01
kubectl get pods --namespace=helm-web01
kubectl get rs --namespace=helm-web01

#-------------------------------------------------------
# Open Kubernentes Dash Board


$resourcegroup='devRG' 
$clusterName='DevAKSCluster' 
 
az aks browse --resource-group devRG --name DevAKSCluster
 
#-------------------------------------------------------
# Roll Back Update app01 to version 1 using HELM

helm history helm-web01
helm rollback helm-web01 1
 

#-------------------------------------------------------
# Delete the app

helm del --purge helm-web01;
helm delete --purge helm-web01;  
 





