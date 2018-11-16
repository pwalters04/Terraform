resource "random_id" "randomId" {
  keepers = {
    #Generates a new ID only when a new resource group is defined
    resource_group = "${azurerm_resource_group.myterraformgroup.name}"
  }

  byte_length = 8
}

resource "azurerm_storage_account" "sandboxstroageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.myterraformgroup.name}"
  location                 = "eastus"
  account_replication_type = "LSR"
  account_tier             = "Standard"

  tag {
    env = "Terraform Demo"
  }
}
