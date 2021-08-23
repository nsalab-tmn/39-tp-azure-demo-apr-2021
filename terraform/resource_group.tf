variable "prefix" {
  default = "comp-99"
}
variable "competition_instance" {
  default = "gfd39"
  type = string
}

variable "adminuser" {
  default = "azadmin"
}
# variable "adminpass" {
#   default = "4eEAV4_H!M^a"
# }

variable "prod_rg" {
  default = "common_rg"
}

variable "ts39-api-url" {
  default = "https://ts39storacc.blob.core.windows.net/content/ts39-api.zip"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.competition_instance}-${var.prefix}"
  location = "westus2"
}

resource "random_string" "pass" {
  length           = 16
  special          = false
  min_lower        = 2
  min_numeric      = 2
  min_upper        = 2
  min_special      = 1
  override_special = "+-=%#^@"
}

resource "azuread_user" "competitor" {
  user_principal_name = "${var.competition_instance}-${var.prefix}@nsalab.org"
  display_name        = "${var.competition_instance}-${var.prefix}"
  mail_nickname       = "${var.competition_instance}-${var.prefix}"
  password            = random_string.pass.result
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = azuread_user.competitor.object_id
}

