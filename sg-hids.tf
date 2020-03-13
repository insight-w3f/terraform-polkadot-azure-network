resource "azurerm_network_security_group" "hids_nsg" {
  count               = var.hids_enabled ? 1 : 0
  location            = data.azurerm_resource_group.this.location
  name                = "${var.hids_sg_name}-nsg"
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = module.label.tags
}

resource "azurerm_application_security_group" "hids_asg" {
  count               = var.hids_enabled ? 1 : 0
  location            = data.azurerm_resource_group.this.location
  name                = "${var.hids_sg_name}-asg"
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = module.label.tags
}

resource "azurerm_network_security_rule" "hids_sg_ssh" {
  count                       = var.hids_enabled ? 1 : 0
  name                        = "${var.hids_sg_name}-ssh"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.hids_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_address_prefixes                    = var.corporate_ip == "" ? ["0.0.0.0/0"] : ["${var.corporate_ip}/32"]
  source_port_range                          = "22"
  destination_application_security_group_ids = [azurerm_application_security_group.hids_asg[0].name]
}

resource "azurerm_network_security_rule" "hids_sg_mon_prom" {
  count                       = var.hids_enabled && var.monitoring_enabled ? 1 : 0
  name                        = "${var.hids_sg_name}-monitoring"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.hids_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_application_security_group_ids      = [azurerm_application_security_group.monitoring_asg[0].name]
  source_port_range                          = "9100"
  destination_application_security_group_ids = [azurerm_application_security_group.hids_asg[0].name]
}

resource "azurerm_network_security_rule" "hids_sg_mon_nordstrom" {
  count                       = var.hids_enabled && ! var.monitoring_enabled ? 1 : 0
  name                        = "${var.hids_sg_name}-monitoring"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.hids_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_application_security_group_ids      = [azurerm_application_security_group.monitoring_asg[0].name]
  source_port_range                          = "9108"
  destination_application_security_group_ids = [azurerm_application_security_group.hids_asg[0].name]
}

resource "azurerm_network_security_rule" "hids_sg_http_ingress" {
  count                       = var.hids_enabled ? 1 : 0
  name                        = "${var.hids_sg_name}-http_ingress"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.hids_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_address_prefix                      = "0.0.0.0/0"
  source_port_range                          = "80"
  destination_application_security_group_ids = [azurerm_application_security_group.hids_asg[0].name]
}

resource "azurerm_network_security_rule" "hids_sg_consul" {
  count                       = var.hids_enabled && var.consul_enabled ? 1 : 0
  name                        = "${var.hids_sg_name}-consul"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.hids_nsg[0].name
  priority                    = 100
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                              = "*"
  source_application_security_group_ids = [azurerm_application_security_group.consul_asg[0].name]
  source_port_ranges = ["8600",
    "8500",
    "8301",
  "8302"]
  destination_application_security_group_ids = [azurerm_application_security_group.hids_asg[0].name]
}
