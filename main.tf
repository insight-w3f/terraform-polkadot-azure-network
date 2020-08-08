terraform {
  required_version = ">= 0.12"
}

data azurerm_resource_group "this" {
  name = var.azure_resource_group_name
}
