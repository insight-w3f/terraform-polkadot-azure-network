resource "azurerm_network_security_group" "vault_nsg" {
  count               = var.vault_enabled ? 1 : 0
  location            = data.azurerm_resource_group.this.location
  name                = "${var.vault_sg_name}-nsg"
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = module.label.tags
}

resource "azurerm_application_security_group" "vault_asg" {
  count               = var.vault_enabled ? 1 : 0
  location            = data.azurerm_resource_group.this.location
  name                = "${var.vault_sg_name}-asg"
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = module.label.tags
}

resource "azurerm_network_security_rule" "vault_sg_ssh" {
  count                       = var.vault_enabled && ! var.bastion_enabled ? 1 : 0
  name                        = "${var.vault_sg_name}-ssh"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.vault_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_address_prefixes                    = var.corporate_ip == "" ? ["0.0.0.0/0"] : ["${var.corporate_ip}/32"]
  source_port_range                          = "22"
  destination_application_security_group_ids = [azurerm_application_security_group.vault_asg[0].id]
  destination_port_range                     = "22"
}

resource "azurerm_network_security_rule" "vault_sg_bastion_ssh" {
  count                       = var.vault_enabled && var.bastion_enabled ? 1 : 0
  name                        = "${var.vault_sg_name}-ssh"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.vault_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_application_security_group_ids      = [azurerm_application_security_group.bastion_asg[0].id]
  source_port_range                          = "22"
  destination_application_security_group_ids = [azurerm_application_security_group.vault_asg[0].id]
  destination_port_range                     = "22"
}

resource "azurerm_network_security_rule" "vault_sg_mon" {
  count                       = var.monitoring_enabled ? 1 : 0
  name                        = "${var.vault_sg_name}-monitoring"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.vault_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_application_security_group_ids      = [azurerm_application_security_group.monitoring_asg[0].id]
  source_port_ranges                         = ["9100", "9333"]
  destination_application_security_group_ids = [azurerm_application_security_group.vault_asg[0].id]
  destination_port_ranges                    = ["9100", "9333"]
}

resource "azurerm_network_security_rule" "vault_sg_consul" {
  count                       = var.consul_enabled ? 1 : 0
  name                        = "${var.vault_sg_name}-consul"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.vault_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                              = "*"
  source_application_security_group_ids = [azurerm_application_security_group.consul_asg[0].id]
  source_port_ranges = ["8600",
    "8500",
    "8301",
  "8302"]
  destination_application_security_group_ids = [azurerm_application_security_group.vault_asg[0].id]
  destination_port_ranges = ["8600",
    "8500",
    "8301",
  "8302"]
}

resource "azurerm_network_security_rule" "vault_sg_various" {
  count                       = var.vault_enabled ? 1 : 0
  name                        = "${var.vault_sg_name}-various"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.vault_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol              = "tcp"
  source_address_prefix = "0.0.0.0/0"
  source_port_ranges = ["8200",
  "8201"]
  destination_application_security_group_ids = [azurerm_application_security_group.vault_asg[0].id]
  destination_port_ranges = ["8200",
  "8201"]
}