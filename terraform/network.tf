
resource "azurerm_virtual_network" "sample_app" {
  name = "sample_app_vn"
  address_space = [
    "${var.vn_cidr}"]
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.sample_app.name}"

  tags {
    purpose = "IaC Schulung"
  }
}

resource "azurerm_subnet" "sample_app" {
  name = "sample_app_sn"
  resource_group_name = "${azurerm_resource_group.sample_app.name}"
  virtual_network_name = "${azurerm_virtual_network.sample_app.name}"
  address_prefix = "${var.subnet_cidr}"
  network_security_group_id = "${azurerm_network_security_group.sample_app.id}"
}