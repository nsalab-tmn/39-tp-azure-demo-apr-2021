
##eastus1============
resource "azurerm_network_interface" "win-eastus" {
  name                = "${var.prefix}-win-eastus"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.eastus-private01.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.1.10.5"
  }
}

resource "azurerm_windows_virtual_machine" "win-eastus" {
  name                       = "${var.prefix}-win-eastus"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_network_interface.win-eastus.location
  size                       = "Standard_B2s"
  admin_username             = var.adminuser
  admin_password             = random_string.pass.result
  provision_vm_agent         = true
  enable_automatic_updates   = true
  allow_extension_operations = true
  computer_name              = "wincli01"
  network_interface_ids = [
    azurerm_network_interface.win-eastus.id,
  ]
  license_type = "Windows_Client"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 127
    name                 = "${var.prefix}-win-eastus"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "20h1-ent"
    version   = "latest"
  }
}

# resource "azurerm_virtual_machine_extension" "win-eastus" {
#   name                 = "addom"
#   virtual_machine_id   = azurerm_windows_virtual_machine.win-eastus.id
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "1.9"

#   settings = <<EOF
#     {
#       "commandToExecute": "powershell.exe -Command \"$Secure_String_Pwd = ConvertTo-SecureString '${random_string.pass.result}' -AsPlainText -Force; New-LocalUser 'DevUser' -Password $Secure_String_Pwd -FullName 'John Doe' -Description 'Account for super developer'\""
#     }
#   EOF
# }
