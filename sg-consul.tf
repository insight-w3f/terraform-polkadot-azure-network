resource "azurerm_network_security_group" "consul_nsg" {
  count               = var.consul_enabled ? 1 : 0
  location            = data.azurerm_resource_group.this.location
  name                = "${var.consul_sg_name}-nsg"
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = module.label.tags
}

resource "azurerm_application_security_group" "consul_asg" {
  count               = var.consul_enabled ? 1 : 0
  location            = data.azurerm_resource_group.this.location
  name                = "${var.consul_sg_name}-asg"
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = module.label.tags
}

resource "azurerm_network_security_rule" "consul_sg_ssh" {
  count                       = var.consul_enabled && ! var.bastion_enabled ? 1 : 0
  name                        = "${var.consul_sg_name}-ssh"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.consul_nsg[0].name
  priority                    = 300
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_address_prefixes                    = var.corporate_ip == "" ? ["0.0.0.0/0"] : ["${var.corporate_ip}/32"]
  source_port_range                          = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.consul_asg[0].id]
  destination_port_range                     = "22"
}

resource "azurerm_network_security_rule" "consul_sg_bastion_ssh" {
  count                       = var.consul_enabled && var.bastion_enabled ? 1 : 0
  name                        = "${var.consul_sg_name}-ssh"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.consul_nsg[0].name
  priority                    = 301
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_application_security_group_ids      = [azurerm_application_security_group.bastion_asg[0].id]
  source_port_range                          = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.consul_asg[0].id]
  destination_port_range                     = "22"
}

resource "azurerm_network_security_rule" "consul_sg_mon_prom" {
  count                       = var.consul_enabled && var.monitoring_enabled ? 1 : 0
  name                        = "${var.consul_sg_name}-monitoring"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.consul_nsg[0].name
  priority                    = 302
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_application_security_group_ids      = [azurerm_application_security_group.monitoring_asg[0].id]
  source_port_range                          = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.consul_asg[0].id]
  destination_port_range                     = "9100"
}

resource "azurerm_network_security_rule" "consul_sg_mon_nordstrom" {
  count                       = var.consul_enabled && ! var.monitoring_enabled ? 1 : 0
  name                        = "${var.consul_sg_name}-monitoring"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.consul_nsg[0].name
  priority                    = 303
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_application_security_group_ids      = [azurerm_application_security_group.monitoring_asg[0].id]
  source_port_range                          = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.consul_asg[0].id]
  destination_port_range                     = "9428"
}
