##EASTUS============
resource "azurerm_network_interface" "ubuntu-eastus" {
  name                = "${var.prefix}-ubuntu-eastus"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.eastus-private01.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.1.10.6"
  }
}

resource "azurerm_linux_virtual_machine" "ubuntu-eastus" {
  depends_on                      = [azurerm_linux_virtual_machine.cisco-eastus]
  name                            = "${var.prefix}-ubuntu-eastus"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B2s"
  admin_username                  = var.adminuser
  admin_password                  = random_string.pass.result
  disable_password_authentication = false
  provision_vm_agent              = true


  allow_extension_operations = true
  computer_name              = "${var.prefix}-ubuntu-eastus"
  network_interface_ids = [
    azurerm_network_interface.ubuntu-eastus.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 30
    name                 = "${var.prefix}-ubuntu-eastus"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  # custom_data = filebase64("${path.module}/customdata-ubuntu-eastus.sh")
}
