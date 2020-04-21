variable client_id {}
variable client_secret {}
variable ssh_public_key {}

variable environment {
    default = "Prod"
}

variable location {
    default = "westeurope"
}

variable node_count {
  default = 2
}

variable dns_prefix {
  default = "k8sprod"
}

variable cluster_name {
  default = "k8sprod"
}

variable resource_group {
  default = "prod-aks01"
}