resource "azurerm_public_ip" "myterraformpublicip" {
  name                         = "SandboxPublicIP"
  location                     = "eastus"
  resource_group_name          = "${azurerm_resource_group.myterraformgroup.Sandbox}"
  public_ip_address_allocation = "dynamic"

  tags {
    env = "Terraform Demo"
  }
}
