##EASTUS============
resource "azurerm_virtual_network" "region-01" {
  name                = "${var.prefix}-vnet-region-01"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

}
resource "azurerm_subnet" "region-01-public01" {
  name                 = "public01"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.region-01.name
  address_prefixes       = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "region-01-azurebastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.region-01.name
  address_prefixes       = ["10.1.99.0/24"]
}

resource "azurerm_subnet" "region-01-private01" {
  name                 = "private01"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.region-01.name
  address_prefixes       = ["10.1.10.0/24"]
}

resource "azurerm_route_table" "rt-region-01" {
  name                = "${var.prefix}-rt-region-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  route {
    name                   = "${var.prefix}-rt-region-01"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.1.10.4"
  }
}

resource "azurerm_subnet_route_table_association" "rt-region-01" {
  subnet_id      = azurerm_subnet.region-01-private01.id
  route_table_id = azurerm_route_table.rt-region-01.id
}
