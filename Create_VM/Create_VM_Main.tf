#Azure Provider
provider "azurerm" {
  subscription_id = "6f699576-2a8e-4add-abb6-09341fb6da70"
  client_id       = "8ef2a2a5-0300-4f4a-9083-45ecdc7b9979"
  client_secret   = "84598596-3f16-4350-b185-a5797a87eca1"
  tenant_id       = "a4f58d53-76f9-47aa-b407-bdd4268569cb"
}

#Create RG
resource "azurerm_resource_group" "myterraformgroup" {
  name     = "Sandbox"
  location = "eastus"

  tags {
    env = "Terraform Demo"
  }
}

#Create VNET
resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "SandboxVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"

  tags {
    env = "Terraform Demo"
  }
}

#Create Subnet
resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "mySubnet"
  resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
  virtual_network_name = "${azurerm_virtual_network.myterraformnetwork.name}"
  address_prefix       = "10.0.2.0/24"
}

#Create Public IP

resource "azurerm_public_ip" "myterraformpublicip" {
  name                         = "SandboxPublicIP"
  location                     = "eastus"
  resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    env = "Terraform Demo"
  }
}

#Create NSG
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "SandboxNetworkSecurityGroup"
  location            = "eastus"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"

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

#Create Network Interface
resource "azurerm_network_interface" "myterraformnic" {
  name                      = "SandboxNIC"
  location                  = "eastus"
  resource_group_name       = "${azurerm_resource_group.myterraformgroup.name}"
  network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"

  ip_configuration {
    name                          = "SandboxNicConfiguration"
    subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.myterraformpublicip.id}"
  }

  tags {
    environment = "Terraform Demo"
  }
}

#Create Random ID / Stroage Account

resource "random_id" "randomId" {
  keepers = {
    #Generates a new ID only when a new resource group is defined
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
  }

  byte_length = 8
}

resource "azurerm_storage_account" "sandboxstroageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.myterraformgroup.name}"
  location                 = "eastus"
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

#Create VM Ubuntu 16.04

resource "azurerm_virtual_machine" "SandboxTerraformVM" {
  name                  = "SandboxVM"
  location              = "eastus"
  resource_group_name   = "${azurerm_resource_group.myterraformgroup.name}"
  network_interface_ids = ["${azurerm_network_interface.myterraformnic.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "SandboxOSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "sandbox-dev"
    admin_username = "sandboxadmin"
    admin_password = "HBTP@ssw0rd2018"
  }

  os_profile_linux_config {
    disable_password_authentication = false

    #ss_key{
    # path ="/home/sandboxadmin/.ssh/authorized_keys"
    #key_data="ssh-rsa AAAAB3Nz{snip}hwhqT9h"
    #}
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.sandboxstroageaccount.primary_blob_endpoint}"
  }
}
