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
  name_regex = "bdoepfne-ubuntu-16-04-"
  sort_descending = true
  resource_group_name = "${data.azurerm_resource_group.image.name}"
}

resource "azurerm_public_ip" "public_ip" {
  name                         = "sample_app_vm_public_ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.sample_app.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "sample_app" {
  name = "bdoepfne_ni"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.sample_app.name}"

  ip_configuration {
    name = "testconfiguration1"
    subnet_id = "${azurerm_subnet.sample_app.id}"
    public_ip_address_id = "${azurerm_public_ip.public_ip.id}"
    private_ip_address_allocation = "dynamic"
  }
}


resource "azurerm_virtual_machine" "test" {
  name = "bdoepfne-vm"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.sample_app.name}"
  network_interface_ids = [
    "${azurerm_network_interface.sample_app.id}"]
  vm_size = "Standard_A0"

  delete_os_disk_on_termination = true


  storage_image_reference {
    id = "${data.azurerm_image.image.id}"
  }

  storage_os_disk {
    name = "osdisk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }


  os_profile {
    computer_name = "hostname"
    admin_username = "jambitadmin"
    admin_password = "jambit1!2"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

}
