resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "SandboxNetworkSecurityGroup"
  location            = "eastus"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.Sandbox}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    env = "Terraform Demo"
  }
}
