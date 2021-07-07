resource "azurerm_dns_zone" "comp-hz" {
  name                = "${var.prefix}.az.skillscloud.company"
  resource_group_name = azurerm_resource_group.main.name
}



resource "azurerm_dns_ns_record" "parrent_record" {
  name                = var.prefix
  zone_name           = "az.skillscloud.company"
  resource_group_name = var.prod_rg
  ttl                 = 300

  records = azurerm_dns_zone.comp-hz.name_servers
}

resource "azurerm_dns_a_record" "eastus" {
  name                = "eastus"
  zone_name           = azurerm_dns_zone.comp-hz.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  records             = [azurerm_public_ip.cisco-eastus.ip_address]
}


resource "azurerm_dns_a_record" "main" {
  name                = "@"
  zone_name           = azurerm_dns_zone.comp-hz.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  records             = [azurerm_public_ip.cisco-eastus.ip_address]
}