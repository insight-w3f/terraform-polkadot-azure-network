resource "azurerm_network_security_group" "bastion_nsg" {
  count               = var.bastion_enabled ? 1 : 0
  location            = data.azurerm_resource_group.this.location
  name                = "${var.bastion_sg_name}-nsg"
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = var.tags
}

resource "azurerm_application_security_group" "bastion_asg" {
  count               = var.bastion_enabled ? 1 : 0
  location            = data.azurerm_resource_group.this.location
  name                = "${var.bastion_sg_name}-asg"
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "bastion_sg_ssh" {
  count                       = var.bastion_enabled ? 1 : 0
  name                        = "${var.bastion_sg_name}-ssh"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.bastion_nsg[0].name
  priority                    = 200
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_address_prefixes                    = var.corporate_ip == "" ? ["0.0.0.0/0"] : ["${var.corporate_ip}/32"]
  source_port_range                          = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.bastion_asg[0].id]
  destination_port_range                     = "22"
}

resource "azurerm_network_security_rule" "bastion_sg_mon" {
  count                       = var.bastion_enabled ? 1 : 0
  name                        = "${var.bastion_sg_name}-monitoring"
  access                      = "Allow"
  direction                   = "Inbound"
  network_security_group_name = azurerm_network_security_group.bastion_nsg[0].name
  priority                    = 201
  resource_group_name         = data.azurerm_resource_group.this.name

  protocol                                   = "tcp"
  source_application_security_group_ids      = var.monitoring_enabled ? [azurerm_application_security_group.monitoring_asg[*].id] : []
  source_port_range                          = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.bastion_asg[0].id]
  destination_port_ranges = [
    "9100",
  "9428"]
}