resource "azurerm_network_security_group" "sentry_node_nsg" {
  location            = data.azurerm_resource_group.this.location
  name                = "${var.sentry_node_sg_name}-nsg"
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = module.label.tags
}

resource "azurerm_application_security_group" "sentry_node_asg" {
  location            = data.azurerm_resource_group.this.location
  name                = "${var.sentry_node_sg_name}-asg"
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = module.label.tags
}

resource "azurerm_network_security_rule" "sentry_node_sg_ssh" {
  count                       = ! var.bastion_enabled ? 1 : 0
  name                        = "${var.sentry_node_sg_name}-ssh"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.sentry_node_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_address_prefixes                    = var.corporate_ip == "" ? ["0.0.0.0/0"] : ["${var.corporate_ip}/32"]
  source_port_range                          = "22"
  destination_application_security_group_ids = [azurerm_application_security_group.sentry_node_asg[0].name]
}

resource "azurerm_network_security_rule" "sentry_node_sg_bastion_ssh" {
  count                       = var.bastion_enabled ? 1 : 0
  name                        = "${var.sentry_node_sg_name}-ssh"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.sentry_node_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_application_security_group_ids      = [azurerm_application_security_group.bastion_asg[0].name]
  source_port_range                          = "22"
  destination_application_security_group_ids = [azurerm_application_security_group.sentry_node_asg[0].name]
}

resource "azurerm_network_security_rule" "sentry_node_sg_mon" {
  count                       = var.monitoring_enabled ? 1 : 0
  name                        = "${var.sentry_node_sg_name}-monitoring"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.sentry_node_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_application_security_group_ids      = [azurerm_application_security_group.monitoring_asg[0].name]
  source_port_ranges                         = ["9100", "9323"]
  destination_application_security_group_ids = [azurerm_application_security_group.sentry_node_asg[0].name]
}

resource "azurerm_network_security_rule" "sentry_node_sg_hids" {
  count                       = var.hids_enabled ? 1 : 0
  name                        = "${var.sentry_node_sg_name}-hids"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.sentry_node_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_application_security_group_ids      = [azurerm_application_security_group.monitoring_asg[0].name]
  source_port_ranges                         = ["1514", "1515"]
  destination_application_security_group_ids = [azurerm_application_security_group.sentry_node_asg[0].name]
}

resource "azurerm_network_security_rule" "sentry_node_sg_consul" {
  count                       = var.consul_enabled ? 1 : 0
  name                        = "${var.sentry_node_sg_name}-consul"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.sentry_node_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                              = "*"
  source_application_security_group_ids = [azurerm_application_security_group.consul_asg[0].name]
  source_port_ranges = ["8600",
    "8500",
    "8301",
  "8302"]
  destination_application_security_group_ids = [azurerm_application_security_group.sentry_node_asg[0].name]
}

resource "azurerm_network_security_rule" "sentry_node_sg_p2p" {
  name                        = "${var.sentry_node_sg_name}-p2p"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.sentry_node_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "*"
  source_address_prefix                      = "0.0.0.0/0"
  source_port_ranges                         = ["30333", "51820"]
  destination_application_security_group_ids = [azurerm_application_security_group.sentry_node_asg[0].name]
}