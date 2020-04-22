#----------------------------------------------------
# Azure Subscription
#
# Replace correct values :
# - subscription_id  
# - client_id  
# - client_secret  
# - tenant_id  
# - ssh_public_key  
# - access_key
#---------------------------------------------------- 

variable subscription_id {
   default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" 
    
 }

variable client_id       {
    default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
 }

variable client_secret   {
    default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
 }

variable tenant_id       {
    default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
 }

variable ssh_public_key {
    default = "azure_rsa.pub"
}

#----------------------------------------------------
# Azure Storage Account
#---------------------------------------------------- 
    
variable storage_account_name {
    default = "dev01straccnt01"
}
    
# Running Terraform Manualy, add this value:
variable access_key {
   default = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" 
    
}
  
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

variable resource_group {
  default = "dev01-aks01-rg"
}
