provider "azurerm" {

}

terraform {
  backend "azurerm" {
    resource_group_name = "jambitiac"
    storage_account_name = "jambitiac"
    container_name = "tfstate"
    key = "bdoepfne.terraform.tfstate"
  }
}

resource "azurerm_resource_group" "sample_app" {
  name = "bdoepfne_rg"
  location = "${var.location}"

  tags {
    purpose = "IaC Schulung"
  }
}

#Assume that custom image has been already created in the 'customimage' resource group
data "azurerm_resource_group" "image" {
  name = "jambitiac"
}

data "azurerm_image" "image" {
  name_regex = "sample-app-server-bdoepfne-"
  sort_descending = true
  resource_group_name = "${data.azurerm_resource_group.image.name}"
}

//resource "azurerm_public_ip" "public_ip" {
//  count = "${var.machine_count}"
//  name = "sample_app_vm_public_ip-${count.index}"
//  location = "${var.location}"
//  resource_group_name = "${azurerm_resource_group.sample_app.name}"
//  public_ip_address_allocation = "static"
//}

resource "azurerm_network_interface" "sample_app" {
  count = "${var.machine_count}"
  name = "bdoepfne_ni-${count.index}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.sample_app.name}"

  ip_configuration {
    name = "ip_config-${count.index}"
    subnet_id = "${azurerm_subnet.sample_app.id}"
    private_ip_address_allocation = "dynamic"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.sample_app.id}"]
  }
}

resource "azurerm_availability_set" "sample_app" {
  name                = "sample-app-as"
  location            = "${azurerm_resource_group.sample_app.location}"
  resource_group_name = "${azurerm_resource_group.sample_app.name}"
  managed = true
  platform_update_domain_count = "${var.machine_count}"
  platform_fault_domain_count = "${var.machine_count}"
}

resource "azurerm_virtual_machine" "sample_app_machine" {
  count = "${var.machine_count}"
  name = "bdoepfne-vm-${count.index}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.sample_app.name}"
  network_interface_ids = [
    "${azurerm_network_interface.sample_app.*.id[count.index]}"]
  vm_size = "Standard_A0"
  availability_set_id = "${azurerm_availability_set.sample_app.id}"
  delete_os_disk_on_termination = true


  storage_image_reference {
    id = "${data.azurerm_image.image.id}"
  }

  storage_os_disk {
    name = "osdisk-${count.index}"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }


  os_profile {
    computer_name = "sample-app-${count.index}"
    admin_username = "jambitadmin"
    admin_password = "jambit1!2"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

}

output "sample_app_ip_address" {
  value = "${azurerm_public_ip.lb.ip_address}"
}


output "sample_app_fqdn" {
  value = "${azurerm_public_ip.lb.fqdn}"
}
