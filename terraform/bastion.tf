##EASTUS============
resource "azurerm_public_ip" "bastion-region-01" {
  name                = "${var.prefix}-vnet-region-01-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "region-01" {
  name                = "${var.prefix}-bastion-region-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "IpConf"
    subnet_id            = azurerm_subnet.region-01-azurebastionsubnet.id
    public_ip_address_id = azurerm_public_ip.bastion-region-01.id
  }
}
