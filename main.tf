terraform {
  required_version = ">= 0.12"
}

data azurerm_resource_group "this" {
  name = var.azure_resource_group_name
}

module "label" {
  source = "github.com/robc-io/terraform-null-label.git?ref=0.16.1"
  tags = {
    NetworkName = var.network_name
    Owner       = var.owner
    Terraform   = true
    VpcType     = "main"
  }

  environment = var.environment
  namespace   = var.namespace
  stage       = var.stage
}
