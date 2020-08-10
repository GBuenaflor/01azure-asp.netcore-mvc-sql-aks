----------------------------------------------------------
#  Azure Kubernetes Services (AKS) - Part 04
##  Deploying ASP.net Core MVC and SQL Linux to AKS using Azure DevOps

High Level Architecture Diagram:

![Image description](https://github.com/GBuenaflor/01azure-asp.netcore-mvc-sql-aks/blob/master/Images/GB-AzureDevOps-AKS02.png)

Data Flow :

1. Developer Checkin Code to Github
2. Create a AzureDevOps Pipeline trigger and stages
3. CI Pipeline will build the images and push to container registry either Azure Container Registry or Docker Hub
4. CD Pipeline will deploy the images from container registry to Azure Kubernetes
5. Connect to SQL Linux container and check where the data is stored.

----------------------------------------------------------
### Prerequisite: Configure Development Environment using Azure VM

```
- Provision Azure Windows 10 EnterpriseN, Verion 1809 , VM Size: DS2_V3

- Install HyPer-V and Containers Role

- Install Docker for Windows
  https://docs.docker.com/docker-for-windows/install/
  
- Install VS2019 Community Edition  
  https://visualstudio.microsoft.com/vs/compare/
  
- Install SQL Express 2017 
  https://www.microsoft.com/en-us/download/details.aspx?id=55994
  
- Install SSMS
  https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?redirectedfrom=MSDN&view=sql-server-ver15
  
- Install NodeJS
  https://nodejs.org/en/download/

```  


----------------------------------------------------------
### 1. Build and run the ASP.net Core and SQL Linux Docker Container

#### Run the Container using docker-compose

```
docker-compose -f "C:\_1\Web01\docker-compose.yml" -f "C:\_1\Web01\docker-compose.override.yml" up -d
```
#### View the docker images
```
docker ps
docker images
```

### Turn down the container
```
docker-compose down
```

----------------------------------------------------------
### 1.2 Create Azure Container Registry using Azure CLI

#### Login and Create a Resource Group

```
az login  
az group create --name devRG --location eastus
```

#### Create Azure container registry
```
az acr create --resource-group myResourceGroup --name <acrName> --sku Basic --admin-enabled true
az acr create --resource-group devRG --name dev2acr --sku Basic --admin-enabled true
```

#### Log in to container registry
```
az acr login --name <acrName>
az acr login --name dev02acr
```

#### Show container image from ACR
```
az acr show --name <acrName> --query loginServer --output table
az acr show --name dev02acr --query loginServer --output table
```
  
#### Tag the weblinux1 image with the loginServer of container registry

```
docker tag <Repository> <acrLoginServer>/aci-tutorial-app:v1  
docker tag web01 dev02acr.azurecr.io/web01aspnetcore-app:v1
docker tag  microsoft/mssql-server-linux dev02acr.azurecr.io/sqllinux:v1
``` 

----------------------------------------------------------
### 1.3 Push Image to ACR using Azure CLI
 
 
#### Push image to Azure Container Registry

```
docker push dev02acr.azurecr.io/web01aspnetcore-app:v1
docker push dev02acr.azurecr.io/sqllinux:v1
```
 

#### List images in Azure Container Registry
```
az acr repository list --name <acrName> --output table
az acr repository list --name dev02acr --output table
```


#### View the tags for a specific images
```
az acr repository show-tags --name <acrName> --repository aci-tutorial-app --output table
az acr repository show-tags --name dev02acr --repository web01aspnetcore-app --output table
```  


----------------------------------------------------------
### 1.4 Push Images to DockerHub using Azure CLI

```
docker login
docker container list- a
```

#### Tag the images
```
docker tag web01 gbbuenaflor/web01aspnetcore-app:v1
docker tag  microsoft/mssql-server-linux gbbuenaflor/sqllinux:v1
```

#### View the image and Push to Docker Hub
```
docker images
 
docker push gbbuenaflor/web01aspnetcore-app:v1
docker push gbbuenaflor/sqllinux:v1
```

----------------------------------------------------------
### 1.5 Connect to AKS Cluster

```
az aks get-credentials --resource-group $resourcegroup --name $clusterName
```

#### Run AKS commands
```
kubectl version
kubectl get nodes
kubectl get ns
kubectl get services
kubectl get services --namespace=kube-system

kubectl get config get-clusters
```

#### Open Kubernentes Dash Board
```
$resourcegroup='devRG' 
$clusterName='DevAKSCluster' 

kubectl get proxy 
az aks browse --resource-group $resourcegroup --name $clusterName
az aks browse --resource-group Dev02 --name DevAKSCluster
```

----------------------------------------------------------
### 1.6 Generate Secret Key to replace the text connection string
 
```
echo -n 'admin' | base64

echo -n 'Server=mssql-service;Database=Web01DB;User=SA;Password=VM12345!@#12345;' | base64 > ./web01ConnectionString.txt
Get-Content ./web01ConnectionString.txt

U2VydmVyPW1zc3FsLXNlcnZpY2U7RGF0YWJhc2U9V2ViMDFEQjtVc2VyPVNBO1Bhc3N3b3JkPVZNMTIzNDUhQCMxMjM0NTsK

View : https://kubernetes.io/docs/concepts/configuration/secret/
```


----------------------------------------------------------
### 1.7 Deploy asp.net core mvc and sql linux to Azure Kubernetes

#### This image will be deployed
```
gbbuenaflor/web01aspnetcore-app:v1
gbbuenaflor/sqllinux:v1 
microsoft/mssql-server-linux
```

#### Run the aks commands
```
kubectl apply -f 01mssql-secret.yaml --record
kubectl apply -f 02mssql-config-map.yaml --record
kubectl apply -f 03mssql-pv.azure.yaml --record
kubectl apply -f 04mssql-deployment.yaml --record
kubectl apply -f 04mssql-deployment-ext.yaml --record
kubectl apply -f 05mvc-deployment.azure.yaml --record
```

#### View the AKS pods, service, ns
```
kubectl get ns
kubectl get pods --namespace=default
kubectl get service --namespace=default
kubectl get pvc --namespace=default
```
#### View the deployment
```
kubectl get replicaset
kubectl rollout status deployment mvc-deployment
kubectl rollout status deployment mssql-deployment
```

----------------------------------------------------------
### 1.8 Open Kubernentes Dash Board

```
$resourcegroup='devRG' 
$clusterName='DevAKSCluster' 
 
az aks browse --resource-group $resourcegroup --name $clusterName 
```


----------------------------------------------------------
### 1.9 Connecting SSMS to SQL Linux Container

```
- Login to Dev Machine
- Get SQl Load Balancer IP  
   kubectl get svc

- Connect to SQL Linux via SSMS

  ServerName     : 52.188.75.41,1433
  Authentication : SQL Server Authentication
  Login          : sa
  Password       : [Password provided in the config file]
  
```
----------------------------------------------------------
### 1.10 Deploy ASP.net Core MVC and Sql Linux to Azure Kubernetes using HELM 

```
cd /usr/csuser/clouddrive/Web01.kubernetes.Helm/

helm init
helm version

```  

#### Create Package , Install the package

```
helm package helm-web01
helm install helm-web01 --name helm-web01 
``` 
 
 
----------------------------------------------------------
###  1.11 Check the application

```
kubectl get ns 
helm status helm-web01

kubectl get services --namespace=helm-web01
kubectl get pods --namespace=helm-web01
kubectl get rs --namespace=helm-web01
```
  
###  Optional: Roll Back Update app01 to version 1 using HELM

```
helm history helm-web01
helm rollback helm-web01 1
``` 

 
### Optional: Delete the app
```
helm del --purge helm-web01;
helm delete --purge helm-web01;  
``` 
 
----------------------------------------------------------
### 2. Create an AzureDevOps Pipeline trigger and stages

### Configure the Azure DevOps Pipeline to have two stages (Build and Deploy)
```
trigger:
- master

resources:
- repo: self

variables:
  tag: '$(Build.BuildId)'

- stage: Build
     ....
	 
- stage: Deploy
     ....
	 
```

----------------------------------------------------------
### 3. CI Pipeline will build the images and push to container registry either Azure Container Registry or Docker Hub

```
# -----------------------------------------------------
# Build Docker Image and Publish the K8S Files
# -----------------------------------------------------

- stage: Build
  displayName: Build image
  jobs:  
  - job: Build
    displayName: Build
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - task: Docker@2
      inputs:
        containerRegistry: 'dockerhubconnection'
        repository: 'gbbuenaflor/Web01Aks'
        command: 'buildAndPush'
        Dockerfile: '$(Build.SourcesDirectory)/Web01/Dockerfile'
        tags: '$(tag)'
    - task: CopyFiles@2
      inputs:
        SourceFolder: '$(System.DefaultWorkingDirectory)/Web01.kubernetes.Azure'
        Contents: '$(System.DefaultWorkingDirectory)/Web01.kubernetes.Azure/*.yaml'
        TargetFolder: '$(Build.ArtifactStagingDirectory)/Web01.kubernetes.Azure'
    - task: PublishBuildArtifacts@1
      inputs:
        PathtoPublish: '$(Build.ArtifactStagingDirectory)'
        ArtifactName: 'manifests'
        publishLocation: 'Container'
```

----------------------------------------------------------
### 4. CD Pipeline will deploy the images from container registry to Azure Kubernetes

```
# -----------------------------------------------------
# Download the K8S Files and deploy Docker Image to AKS Cluster
# -----------------------------------------------------

- stage: Deploy
  displayName: Deploy image
  jobs:  
  - job: Deploy
    displayName: Deploy
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - task: DownloadPipelineArtifact@2
      inputs:
        buildType: 'current'
        artifactName: 'manifests'
        itemPattern: '**/*.yaml'
        targetPath: '$(System.ArtifactsDirectory)'
    - task: KubernetesManifest@0
      inputs:
        action: 'deploy'
        kubernetesServiceConnection: 'AzureKubernetesConnection'
        namespace: 'default'
        manifests: '$(System.DefaultWorkingDirectory)/Web01.kubernetes.Azure/06webandsqldeployment.yaml'
        containers: 'gbbuenaflor/Web01Aks:$(tag)'
```

----------------------------------------------------------
### 5. Connect to SQL Linux containers and check where the data is stored.

#### Connects internally 
```
#-----------------------------------------------------------------
# Kubernetes - Service for SQL Linux - Internal
#-----------------------------------------------------------------
---
apiVersion: v1
kind: Service
metadata:
  name: mssql-service-int
  namespace: default
spec:
  selector:
    app: mssql
  ports:
    - protocol: TCP
      port: 1433
      targetPort: 1433
      nodePort: 30200
  type: NodePort

```

#### Connects externally    
```
---
apiVersion: v1
kind: Service
metadata:
  name: mssql-service-ext
  namespace: default
spec:
  selector:
    app: mssql
  ports:
    - protocol: TCP
      port: 1433
      targetPort: 1433 
  type: LoadBalancer  
#-----------------------------------------------------------------
# Kubernetes - Deployment for SQL Linux
#-----------------------------------------------------------------
---
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: mssql-deployment
  namespace: default
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: mssql
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - name: mssql
        image: microsoft/mssql-server-linux
        resources:
           limits:
             cpu: "2"
             memory: "2Gi"
           requests:
             cpu: "0.5"
        ports:
        - containerPort: 1433
        env:
        - name: ACCEPT_EULA
          value: "Y"
        - name: SA_PASSWORD
          value: "<Password Here>"
        volumeMounts:
        - name: mssql-persistent-storage
          mountPath: /var/opt/mssql
      volumes:
      - name: mssql-persistent-storage
        persistentVolumeClaim:
          claimName: mssql-pv-claim

```

#### SQL Linux container uses Azure Storage Account to save data.

``` 
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mssql-pv-claim
  annotations: 
    volume.beta.kubernetes.io/storage-class: azure-disk
spec:
  storageClassName: default
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```


##### Note: Azure SQL (external) can also be used.

----------------------------------------------------------
### View the  Azure DevOps Pipeline result

![Image description](https://github.com/GBuenaflor/01azure-asp.netcore-mvc-sql-aks/blob/master/Images/GB-AzureDevOps-AKS03.png)


### View the AKS deployment dashboard
	   
![Image description](https://github.com/GBuenaflor/01azure-asp.netcore-mvc-sql-aks/blob/master/Images/GB-AzureDevOps-AKS04.png)



### View the AKS services dashboard
![Image description](https://github.com/GBuenaflor/01azure-asp.netcore-mvc-sql-aks/blob/master/Images/GB-AzureDevOps-AKS05.png)


	   

### Connect SQL Linux from AKS to VS2019 locally
	   
![Image description](https://github.com/GBuenaflor/01azure-asp.netcore-mvc-sql-aks/blob/master/Images/GB-AzureDevOps-AKS06.png)



 
Link to other Microsoft Azure projects
https://github.com/GBuenaflor/01azure
 

Note: My Favorite -> Microsoft :D
