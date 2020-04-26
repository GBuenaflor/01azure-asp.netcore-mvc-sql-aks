#----------------------------------------------------
# Azure Terraform Provider
#----------------------------------------------------

provider "azurerm" { 
  features {}
  version = ">=2.0.0"  
}
 
provider "azurerm" { 
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id 
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
    vm_size         = var.vm_size
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
# Uncomment if using AZ CLI from the Portal
#----------------------------------------------------

terraform {
  backend "azurerm" {
      storage_account_name= "dev01straccnt01"  
      access_key= "1qxGagOl73iVmc/KBZJvKS1aHHG/MIDS6BHRd3OXi5PFav6fNBPv3h0xhEr1zvHsaLkMzHw/UcOxMf09yNnSsQ==" 
      key= "dev01.k8s.tfstate"              
      container_name= "dev01strcontainer01" 
	}
}
