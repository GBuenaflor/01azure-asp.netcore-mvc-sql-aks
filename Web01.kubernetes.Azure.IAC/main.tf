#######################################################
# Azure Terraform - Infrastructure as a Code (IaC)
#
# Gerardo Buenaflor
# Sr. Architect 
# 10:31 AM 4/20/2020
#
####################################################### 
#----------------------------------------------------
# Initial Configuration
#----------------------------------------------------

# Run this in Azure CLI
# az login
# az ad sp create-for-rbac -n "AzureTerraform" --role="Contributor" 
# --scopes="/subscriptions/[SubscriptionID]"
 
#----------------------------------------------------
# Indentify Terraform Provider
#----------------------------------------------------

provider "azurerm" { 
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}
  
#----------------------------------------------------
# Create Resource Group
#----------------------------------------------------

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_group}"
  location = var.location
}
 
#----------------------------------------------------
# Create Azure AKS Cluster
#----------------------------------------------------

resource "azurerm_kubernetes_cluster" "terraform-k8s" {
  name                = "${var.cluster_name}_${var.environment}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  dns_prefix          = var.dns_prefix

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  default_node_pool {
    name            = "agentpool"
    node_count      = var.node_count
    vm_size         = "Standard_DS1_v2"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    Environment = var.environment
  }
}


#----------------------------------------------------
# Create Terraform BackEnd
#----------------------------------------------------

terraform {
  backend "azurerm" {
      #storage_account_name= "dev01straccnt01"  
      #access_key= var.subscription_id 
      #key= "dev01.k8s.tfstate"              
      #container_name= "dev01strcontainer01"
 
	}
}
