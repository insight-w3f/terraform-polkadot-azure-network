provider "azurerm" {
  version = "=2.0.0"
  features {}
}

resource "azurerm_resource_group" "this" {
  location = "eastus"
  name     = "asg-default-testing"
}

module "defaults" {
  source                    = "../.."
  azure_resource_group_name = azurerm_resource_group.this.name
}
