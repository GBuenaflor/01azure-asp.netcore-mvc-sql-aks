variable client_id {}
variable client_secret {}
variable ssh_public_key {}

variable environment {
    default = "Dev01"
}

variable location {
    default = "westeurope"
}

variable node_count {
  default = 2
}

variable dns_prefix {
  default = "k8sdev01"
}

variable cluster_name {
  default = "k8sdev01"
}

variable resource_group {
  default = "dev01-aks-rg"
}
