resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "SandboxVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.Sandbox}"

  tags {
    env = "Terraform Demo"
  }
}

resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "mySubnet"
  resource_group_name  = "${azurerm_resource_group.myterraformgroup.Sandbox}"
  virtual_network_name = "${azurerm_virtual_network.myterraformnetwork.SandboxVnet}"
  address_prefix       = "10.0.2.0/24"
}
