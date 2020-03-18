locals {
  public_domain = join(".", [data.azurerm_resource_group.this.location, var.environment, var.root_domain_name])
}

resource "azurerm_dns_zone" "this" {
  count               = var.root_domain_name == "" ? 0 : 1
  name                = "${var.root_domain_name}."
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone" "root_private" {
  count               = var.create_internal_domain ? 1 : 0
  name                = "${var.namespace}.${var.internal_tld}"
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_dns_zone" "region_public" {
  count               = var.create_public_regional_subdomain ? 1 : 0
  name                = local.public_domain
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_dns_ns_record" "region_public" {
  count               = var.create_public_regional_subdomain ? 1 : 0
  name                = local.public_domain
  resource_group_name = data.azurerm_resource_group.this.name
  ttl                 = 30
  zone_name           = azurerm_dns_zone.region_public[0].name
  records             = [azurerm_dns_zone.region_public[0].name_servers]
}