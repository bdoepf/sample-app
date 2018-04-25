resource "azurerm_public_ip" "lb" {
  name = "PublicIPForLB"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.sample_app.name}"
  public_ip_address_allocation = "static"
  domain_name_label = "sample-app"
}

resource "azurerm_lb" "sample_app" {
  name = "SampleApp-LB"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.sample_app.name}"

  frontend_ip_configuration {
    name = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.lb.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "sample_app" {
  resource_group_name = "${azurerm_resource_group.sample_app.name}"
  loadbalancer_id = "${azurerm_lb.sample_app.id}"
  name = "BackEndAddressPool"
}

resource "azurerm_lb_rule" "sample_app" {
  resource_group_name = "${azurerm_resource_group.sample_app.name}"
  loadbalancer_id = "${azurerm_lb.sample_app.id}"
  name = "LBRule"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 8080
  probe_id = "${azurerm_lb_probe.sample_app.id}"
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.sample_app.id}"
}

resource "azurerm_lb_probe" "sample_app" {
  resource_group_name = "${azurerm_resource_group.sample_app.name}"
  loadbalancer_id     = "${azurerm_lb.sample_app.id}"
  name                = "sample-app-health-check"
  port                = 8080
  protocol = "Http"
  request_path = "/"
}