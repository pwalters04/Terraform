#Usage: Creates Ubuntu 16.04-LTS
#Note you Need IP,NIC,RG,STG_ACCT,VNET to create VM

resource "azurermvirtual_machine" "SandboxTerraformVM" {
  name                  = "SandboxVM"
  location              = "eastus"
  resource_group_name   = "${azurerm_network_security_group.myterraformnsg.name}"
  network_interface_ids = "${azurerm_network_interface.myterraformnic.id}"
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "SandboxOSDisk"
    caching           = "ReadWrtie"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LSR"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "lastest"
  }

  os_profile {
    computer_name  = "sandbox-dev"
    admin_username = "sandboxadmin"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ss_key {
      path     = "/home/sandboxadmin/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3Nz{snip}hwhqT9h"
    }
  }

  boot-diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.sandboxstroageaccount.primary_blob_endpoint}"
  }

  tag {
    env = "Terraform Demo"
  }
}
