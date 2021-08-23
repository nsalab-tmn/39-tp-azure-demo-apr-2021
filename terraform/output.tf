output "pass" {
  value = {(var.prefix) = random_string.pass.result}
}

output "static-params" {
  value = {
    "region-01-private-network" = cidrhost(azurerm_subnet.region-01-private01.address_prefixes[0],0)
    "platform-01-ip" = azurerm_network_interface.platform-region-01.private_ip_address
    "gw-01-private-ip" = azurerm_network_interface.gw-region-01.private_ip_address
  }
}

output "dynamic-params" {
  value = {
    "${var.competition_instance}-${var.prefix}"= {
      "gw-01-public-ip" = azurerm_public_ip.gw-region-01.ip_address
      "adminuser" = var.adminuser
      "password" = random_string.pass.result
      "ad-username" = azuread_user.competitor.user_principal_name
      "prefix" = "${var.competition_instance}-${var.prefix}"
      "dns-zone" = azurerm_dns_zone.comp-hz.name

    }
  }
}