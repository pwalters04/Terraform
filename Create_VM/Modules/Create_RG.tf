resource "azurerm_resource_group" "myterraformgroup" {
  name     = "Sandbox"
  location = "eastus"

  tags {
    env = "Terraform Demo"
  }
}
