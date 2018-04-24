
resource "azurerm_network_security_group" "sample_app" {
  name                = "sample_app_sg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.sample_app.name}"
}

resource "azurerm_network_security_rule" "allow_all_out" {
  name                        = "allOut"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.sample_app.name}"
  network_security_group_name = "${azurerm_network_security_group.sample_app.name}"
}

resource "azurerm_network_security_rule" "allow_all_ssh_in" {
  name                        = "sshIn"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.sample_app.name}"
  network_security_group_name = "${azurerm_network_security_group.sample_app.name}"
}

resource "azurerm_network_security_rule" "allow_all_http_in" {
  name                        = "httpIn"
  priority                    = 2000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.sample_app.name}"
  network_security_group_name = "${azurerm_network_security_group.sample_app.name}"
}
