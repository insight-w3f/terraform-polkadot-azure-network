locals {
  // Azure doesn't support multiple AZ through Terraform yet
  // so everything is just going into one public and one private subnet per VPC
  subnet_num = 2
  num_azs    = 1

  subnet_count = local.subnet_num * local.num_azs

  subnet_bits = ceil(log(local.subnet_count, 2))

  public_subnets = [for subnet_num in range(local.num_azs) : cidrsubnet(
    var.cidr,
    local.subnet_bits,
  subnet_num)]

  private_subnets = [for subnet_num in range(local.num_azs) : cidrsubnet(
    var.cidr,
    local.subnet_bits,
    local.num_azs + subnet_num,
  )]

  public_subnet_names  = [for subnet_num in range(local.num_azs) : "public-${subnet_num}"]
  private_subnet_names = [for subnet_num in range(local.num_azs) : "private-${subnet_num}"]
}

resource "azurerm_virtual_network" "vpc_network" {
  address_space       = [var.cidr]
  location            = data.azurerm_resource_group.this.location
  name                = var.vpc_name
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_subnet" "public" {
  address_prefix       = local.public_subnets[0]
  name                 = local.public_subnet_names[0]
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.vpc_network.name
}

resource "azurerm_subnet" "private" {
  address_prefix       = local.private_subnets[0]
  name                 = local.private_subnet_names[0]
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.vpc_network.name
}

resource "azurerm_network_security_group" "public_nsg" {
  location            = data.azurerm_resource_group.this.location
  name                = "public-nsg"
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = module.label.tags
}

resource "azurerm_network_security_group" "private_nsg" {
  location            = data.azurerm_resource_group.this.location
  name                = "private-nsg"
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = module.label.tags
}

resource "azurerm_subnet_network_security_group_association" "public" {
  network_security_group_id = azurerm_network_security_group.public_nsg.id
  subnet_id                 = azurerm_subnet.public.id
}

resource "azurerm_subnet_network_security_group_association" "private" {
  network_security_group_id = azurerm_network_security_group.private_nsg.id
  subnet_id                 = azurerm_subnet.private.id
}

resource "azurerm_route_table" "public" {
  location            = data.azurerm_resource_group.this.location
  name                = "public-routes"
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_subnet_route_table_association" "public" {
  route_table_id = azurerm_route_table.public.id
  subnet_id      = azurerm_subnet.public.id
}

resource "azurerm_route" "public-inet" {
  count               = length(local.public_subnets)
  address_prefix      = "0.0.0.0/0"
  name                = "public-inet"
  next_hop_type       = "Internet"
  resource_group_name = data.azurerm_resource_group.this.name
  route_table_name    = azurerm_route_table.public.name
}

resource "azurerm_route" "public-vnetlocal" {
  count               = length(local.public_subnets)
  address_prefix      = local.public_subnets[0]
  name                = "public-vnetlocal"
  next_hop_type       = "vnetlocal"
  resource_group_name = data.azurerm_resource_group.this.name
  route_table_name    = azurerm_route_table.public.name
}
resource "azurerm_route_table" "private" {
  location            = data.azurerm_resource_group.this.location
  name                = "private-routes"
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_subnet_route_table_association" "private" {
  route_table_id = azurerm_route_table.private.id
  subnet_id      = azurerm_subnet.private.id
}

resource "azurerm_route" "private-vnetlocal" {
  count               = length(local.private_subnets)
  address_prefix      = local.private_subnets[0]
  name                = "private-vnetlocal"
  next_hop_type       = "vnetlocal"
  resource_group_name = data.azurerm_resource_group.this.name
  route_table_name    = azurerm_route_table.private.name
}