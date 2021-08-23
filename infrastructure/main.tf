resource "azurerm_resource_group" "rg" {
    name        =   "Azure_rg"
    location    =   "South India"   
}

# get current config. contains the service principal
data "azurerm_client_config" "current" {
}

# Create Azure Key Vault
resource "azurerm_key_vault" "key_vault" {
  name                         = "azure_kv"
  location                     = azurerm_resource_group.location
  resource_group_name          = azurerm_resource_group.rg
  tenant_id                    = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days   = 7
  soft_delete_enabled          = true
  purge_protection_enabled     = false
  
  sku_name = "standard"
  
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "get",
      "list",
      "set",
      "delete",
    ]
  }
}

resource azurerm_kubernetes_cluster "azure_aks" {
    name    =   "Azure_aks_cluster"
    location    =   azurerm_resource_group.location
    resource_group_name = azurerm_resource_group.rg
    dns_prefix = "azure_aks_dns"

    default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }
}
