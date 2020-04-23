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


variable subscription_id {
    default = "2b5ee6f8-e317-4bc2-bced-a565aca7d8c1" 
 }

variable client_id       {
    default = "22146dd3-9ba9-4f63-8062-4f681a19be6f"
 }

variable client_secret   {
    default = "cb351e77-c2d7-4534-a357-56d15f7173f3"
 }

variable tenant_id       {
    default = "0a5c2b53-e3e6-45c2-aa3c-6827c8a81934"
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
    default = "1qxGagOl73iVmc/KBZJvKS1aHHG/MIDS6BHRd3OXi5PFav6fNBPv3h0xhEr1zvHsaLkMzHw/UcOxMf09yNnSsQ==" 
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
