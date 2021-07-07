##EASTUS============
resource "azurerm_network_interface" "cisco-eastus" {
  name                = "${var.prefix}-cisco-eastus"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.eastus-private01.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.1.10.4"
  }
  enable_ip_forwarding = true
}

resource "azurerm_network_interface" "cisco-eastus-public" {
  name                = "${var.prefix}-cisco-eastus-public"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.eastus-public01.id
    private_ip_address_allocation = "Static" #have to be Dynamic according to template. why?
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.1.1.4"
    public_ip_address_id          = azurerm_public_ip.cisco-eastus.id
  }
  enable_ip_forwarding = true
}

resource "azurerm_public_ip" "cisco-eastus" {
  name                    = "${var.prefix}-cisco-eastus-public"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  sku                     = "Basic"
  allocation_method       = "Static"
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
}

resource "azurerm_linux_virtual_machine" "cisco-eastus" {
  name                = "${var.prefix}-cisco-eastus"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  plan {
    name      = "17_2_1-payg-sec"
    product   = "cisco-csr-1000v"
    publisher = "cisco"
  }
  size                            = "Standard_B2s"
  admin_username                  = var.adminuser
  admin_password                  = random_string.pass.result
  disable_password_authentication = false
  provision_vm_agent              = true


  allow_extension_operations = true
  computer_name              = "${var.prefix}-cisco-eastus"
  network_interface_ids = [
    azurerm_network_interface.cisco-eastus-public.id,
    azurerm_network_interface.cisco-eastus.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 16
    name                 = "${var.prefix}-cisco-eastus"
  }

  source_image_reference {
    publisher = "cisco"
    offer     = "cisco-csr-1000v"
    sku       = "17_2_1-payg-sec"
    version   = "latest"
  }
  # custom_data = base64encode(templatefile("${path.module}/customdata-cisco-eastus.tpl", { westip = azurerm_public_ip.cisco-westus.ip_address, southip = azurerm_public_ip.cisco-southcentralus.ip_address }))
}