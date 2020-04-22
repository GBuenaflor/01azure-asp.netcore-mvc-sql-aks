 
#----------------------------------------------------
# Azure Subscription
#----------------------------------------------------

variable subscription_id {}
variable client_id {}
variable client_secret {}
variable tenant_id {}
variable ssh_public_key {}
  
#----------------------------------------------------
# Azure Storage Account
#---------------------------------------------------- 
    
variable storage_account_name {
    default = "dev01straccnt01"
}
    
variable access_key {}
  
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
