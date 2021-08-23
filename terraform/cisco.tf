##EASTUS============
resource "azurerm_network_interface" "gw-region-01" {
  name                = "${var.prefix}-gw-region-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.region-01-private01.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.1.10.4"
  }
  enable_ip_forwarding = true
}

resource "azurerm_network_interface" "gw-region-01-public" {
  name                = "${var.prefix}-gw-region-01-public"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.region-01-public01.id
    private_ip_address_allocation = "Static" #have to be Dynamic according to template. why?
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.1.1.4"
    public_ip_address_id          = azurerm_public_ip.gw-region-01.id
  }
  enable_ip_forwarding = true
}

resource "azurerm_public_ip" "gw-region-01" {
  name                    = "${var.prefix}-gw-region-01-public"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  sku                     = "Basic"
  allocation_method       = "Static"
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
}

resource "azurerm_linux_virtual_machine" "gw-region-01" {
  name                = "${var.prefix}-gw-region-01"
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
  computer_name              = "${var.prefix}-gw-region-01"
  network_interface_ids = [
    azurerm_network_interface.gw-region-01-public.id,
    azurerm_network_interface.gw-region-01.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 16
    name                 = "${var.prefix}-gw-region-01"
  }

  source_image_reference {
    publisher = "cisco"
    offer     = "cisco-csr-1000v"
    sku       = "17_2_1-payg-sec"
    version   = "latest"
  }
  # custom_data = base64encode(templatefile("${path.module}/customdata-gw-region-01.tpl", { westip = azurerm_public_ip.gw-westus.ip_address, southip = azurerm_public_ip.gw-southcentralus.ip_address }))
}