##EASTUS============
resource "azurerm_public_ip" "bastion-eastus" {
  name                = "${var.prefix}-vnet-eastus-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "eastus" {
  name                = "${var.prefix}-bastion-eastus"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "IpConf"
    subnet_id            = azurerm_subnet.eastus-azurebastionsubnet.id
    public_ip_address_id = azurerm_public_ip.bastion-eastus.id
  }
}
