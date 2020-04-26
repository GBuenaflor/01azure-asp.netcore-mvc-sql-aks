#----------------------------------------------------
# Azure Subscription
#
#  Replace correct values or configure values in Azure DevOps variables :
#  - subscription_id  
#  - client_id  
#  - client_secret  
#  - tenant_id  
#  - ssh_public_key  
#  - access_key
#---------------------------------------------------- 


variable subscription_id {}
# variable subscription_id {
#   default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" 
#}

variable client_id {}
# variable client_id       {
#    default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
# }
variable client_secret {}

# variable client_secret   {
#    default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
# }

variable tenant_id {}
# variable tenant_id       {
#    default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
# }

variable ssh_public_key {}
# azure_rsa.pub is uploaded in AzureDevOps Secure filethen set up the azure devops variable
# or upload the azure_rsa.pub together with the terrafom files and use the set up below
# variable ssh_public_key {
#    default = "azure_rsa.pub"
#}
 

#----------------------------------------------------
# Azure Storage Account
#---------------------------------------------------- 
    
variable storage_account_name {
    default = "dev01straccnt01"
}
 
variable access_key {}
#variable access_key {
#   default = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" 
#}
  
variable key {
    default = "dev01.k8s.tfstate"
}
  
variable container_name {
    default = "dev01strcontainer01"
}
  
#----------------------------------------------------
# Azure AKS Variables
#----------------------------------------------------
    
variable environment {
    default = "dev"
}

variable location {
    default = "eastus"
}

variable node_count {
  default = 2
}

variable dns_prefix {
  default = "aks01"
}

variable cluster_name {
  default = "aks01"
}

variable vm_size {
  default = "Standard_DS1_v2"
}

variable resource_group {
  default = "dev01-aks01-rg"
}
