# Provider configuration
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id  # Use a variable for the subscription ID
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.tenant}-${var.environment}-rg"
  location = var.location
}

# Azure Container Registry (Optional)
resource "azurerm_container_registry" "acr" {
  count               = var.deploy_acr ? 1 : 0
  name                = "${var.tenant}${var.environment}acr"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

# AKS Cluster with a System Node Pool
resource "azurerm_kubernetes_cluster" "aks" {
  count               = var.deploy_aks ? 1 : 0
  name                = "${var.tenant}-${var.environment}-aks"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${var.tenant}-${var.environment}-aks"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name                  = "znode10apl"  # Set the name of the system pool
    vm_size               = "Standard_D4as_v4"
    node_count            = 1
    auto_scaling_enabled  = true
    min_count             = 1
    max_count             = 1
  }

  network_profile {
    network_plugin    = "azure"              # Azure CNI
    network_policy    = "calico"             # Calico for network policies
    load_balancer_sku = "standard"           # Standard load balancer
    dns_service_ip    = "10.0.0.10"          # DNS service IP
    service_cidr      = "10.0.0.0/16"        # Service CIDR
    pod_cidr          = null                 # Not needed with Azure CNI
    outbound_type     = "loadBalancer"       # Outbound via Load Balancer
  }
}
