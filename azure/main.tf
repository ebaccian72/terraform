terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.61.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "subscription" {
  default = "azr02"
}

resource "azurerm_resource_group" "rg_principale" {
  name     = "${var.subscription}-rg006"
  location = "West Europe"

  tags = {
    CreatedBy = "enrico.baccianini@crealogix.com"
  }
  lifecycle {
    ignore_changes = [
      tags ["CreatedOnDate"]
    ]
  }
}

resource "azurerm_virtual_network" "vnet_principale" {
  name                = "${azurerm_resource_group.rg_principale.name}-vnet"
  location            = azurerm_resource_group.rg_principale.location
  resource_group_name = azurerm_resource_group.rg_principale.name

  address_space       = ["10.0.0.0/16","fd00:db8:deca::/48"]
  tags = {
    CreatedBy = "enrico.baccianini@crealogix.com"
  }
  lifecycle {
    ignore_changes = [
      tags ["CreatedOnDate"]
    ]
  }
}


resource "azurerm_public_ip" "vm006-ip4" {
  name                = "${var.subscription}-ip1"
  location            = azurerm_resource_group.rg_principale.location
  resource_group_name = azurerm_resource_group.rg_principale.name
  sku                 = "Standard"

  allocation_method   = "Static"
  ip_version          = "IPv4"
  tags = {
    CreatedBy = "enrico.baccianini@crealogix.com"
  }
  lifecycle {
    ignore_changes = [
      tags ["CreatedOnDate"]
    ]
  }
}
resource "azurerm_public_ip" "vm006-ip6" {
  name                = "${var.subscription}-ip3"
  location            = azurerm_resource_group.rg_principale.location
  resource_group_name = azurerm_resource_group.rg_principale.name

  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv6"
  tags = {
    CreatedBy = "enrico.baccianini@crealogix.com"
  }
  lifecycle {
    ignore_changes = [
      tags ["CreatedOnDate"]
    ]
  }
}
# resource "azurerm_public_ip" "vm007-ip4" {
#   name                = "${var.subscription}-ip2"
#   location            = azurerm_resource_group.rg_principale.location
#   resource_group_name = azurerm_resource_group.rg_principale.name

#   allocation_method   = "Static"
#   ip_version          = "IPv4"
#   tags = {
#     CreatedBy = "enrico.baccianini@crealogix.com"
#   }
#   lifecycle {
#     ignore_changes = [
#       tags ["CreatedOnDate"]
#     ]
#   }
# }

resource "azurerm_subnet" "sub_ext" {
  name                 = "sub_ext"
  resource_group_name  = azurerm_resource_group.rg_principale.name

  virtual_network_name = azurerm_virtual_network.vnet_principale.name
  address_prefixes     = ["10.0.2.0/24"]
}

# resource "azurerm_subnet" "sub_int" {
#   name                 = "sub_int"
#   resource_group_name  = azurerm_resource_group.rg_principale.name

#   virtual_network_name = azurerm_virtual_network.vnet_principale.name
#   address_prefixes     = ["10.0.3.0/24"]
# }

resource "azurerm_subnet" "sub_sei" {
  name                 = "sub_sei"
  resource_group_name  = azurerm_resource_group.rg_principale.name

  virtual_network_name = azurerm_virtual_network.vnet_principale.name
  address_prefixes     = ["fd00:db8:deca:deed::/64"]
}


resource "azurerm_network_interface" "vm006-nic1" {
  name                = "${var.subscription}-vm006-nic1"
  location            = azurerm_resource_group.rg_principale.location
  resource_group_name = azurerm_resource_group.rg_principale.name

  ip_configuration {
    name                          = "vm006-nic1-cfg1"
    subnet_id                     = azurerm_subnet.sub_ext.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm006-ip4.id
    primary                       = true
  }
  ip_configuration {
    name                          = "vm006-nic1-cfg2"
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv6"
      subnet_id                     = azurerm_subnet.sub_sei.id
      public_ip_address_id          = azurerm_public_ip.vm006-ip6.id
  }
  tags = {
    CreatedBy = "enrico.baccianini@crealogix.com"
  }
  lifecycle {
    ignore_changes = [
      tags ["CreatedOnDate"]
    ]
  }
}
# resource "azurerm_network_interface" "vm006-nic2" {
#   name                = "${var.subscription}-vm006-nic2"
#   location            = azurerm_resource_group.rg_principale.location
#   resource_group_name = azurerm_resource_group.rg_principale.name

#   ip_configuration {
#     name                          = "vm006-nic2-cfg"
#     subnet_id                     = azurerm_subnet.sub_int.id
#     private_ip_address_allocation = "Dynamic"
#   }
#   tags = {
#     CreatedBy = "enrico.baccianini@crealogix.com"
#   }
#   lifecycle {
#     ignore_changes = [
#       tags ["CreatedOnDate"]
#     ]
#   }
# }


# resource "azurerm_network_interface" "vm007-nic1" {
#   name                = "${var.subscription}-vm007-nic1"
#   location            = azurerm_resource_group.rg_principale.location
#   resource_group_name = azurerm_resource_group.rg_principale.name

#   ip_configuration {
#     name                          = "vm007-nic1-cfg"
#     subnet_id                     = azurerm_subnet.sub_ext.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.vm007-ip4.id
#   }
#   tags = {
#     CreatedBy = "enrico.baccianini@crealogix.com"
#   }
#   lifecycle {
#     ignore_changes = [
#       tags ["CreatedOnDate"]
#     ]
#   }
# }
# resource "azurerm_network_interface" "vm007-nic2" {
#   name                = "${var.subscription}-vm007-nic2"
#   location            = azurerm_resource_group.rg_principale.location
#   resource_group_name = azurerm_resource_group.rg_principale.name

#   ip_configuration {
#     name                          = "vm007-nic2-cfg"
#     subnet_id                     = azurerm_subnet.sub_int.id
#     private_ip_address_allocation = "Dynamic"
#   }
#   tags = {
#     CreatedBy = "enrico.baccianini@crealogix.com"
#   }
#   lifecycle {
#     ignore_changes = [
#       tags ["CreatedOnDate"]
#     ]
#   }
# }


resource "azurerm_network_security_group" "nsg_ext" {
  name                = "${azurerm_resource_group.rg_principale.name}-nsg_ext"
  location            = azurerm_resource_group.rg_principale.location
  resource_group_name = azurerm_resource_group.rg_principale.name

  security_rule {
    name                       = "regola_in_tcp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "regola_in_icmp"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "regola_out_icmp"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    CreatedBy = "enrico.baccianini@crealogix.com"
  }
  lifecycle {
    ignore_changes = [
      tags ["CreatedOnDate"]
    ]
  }
}

# resource "azurerm_network_security_group" "nsg_int" {
#   name                = "${azurerm_resource_group.rg_principale.name}-nsg_int"
#   location            = azurerm_resource_group.rg_principale.location
#   resource_group_name = azurerm_resource_group.rg_principale.name

#   security_rule {
#     name                       = "regola_tcp"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "25"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#   security_rule {
#     name                       = "regola_icmp"
#     priority                   = 200
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Icmp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#   security_rule {
#     name                       = "regola_blocco"
#     priority                   = 300
#     direction                  = "Inbound"
#     access                     = "Deny"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#   tags = {
#     CreatedBy = "enrico.baccianini@crealogix.com"
#   }
#   lifecycle {
#     ignore_changes = [
#       tags ["CreatedOnDate"]
#     ]
#   }
# }


resource "azurerm_subnet_network_security_group_association" "nsg_sub_ext" {
  subnet_id                 = azurerm_subnet.sub_ext.id
  network_security_group_id = azurerm_network_security_group.nsg_ext.id
}
resource "azurerm_subnet_network_security_group_association" "nsg_sub_sei" {
  subnet_id                 = azurerm_subnet.sub_sei.id
  network_security_group_id = azurerm_network_security_group.nsg_ext.id
}

# resource "azurerm_subnet_network_security_group_association" "nsg_sub_int" {
#   subnet_id                 = azurerm_subnet.sub_int.id
#   network_security_group_id = azurerm_network_security_group.nsg_int.id
# }


resource "azurerm_virtual_machine" "vm-006" {
  name                  = "${var.subscription}-vm006"
  location              = azurerm_resource_group.rg_principale.location
  resource_group_name   = azurerm_resource_group.rg_principale.name
  primary_network_interface_id = azurerm_network_interface.vm006-nic1.id
  network_interface_ids = [azurerm_network_interface.vm006-nic1.id]
  #network_interface_ids = [azurerm_network_interface.vm006-nic1.id,azurerm_network_interface.vm006-nic2.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "sx"
    admin_username = "enrico"
    # admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDO91bjFr+6+bIyQF1gPTNWgpbrg8ks4yPpyckjGNz6VkCroFlk+pMo+xzWPA7T3AuYcqEF51glTfdGdTAXGVlpH0rU5zevrCwyt7mPgsajnEOMX9jU9Lm6UKgZpyAacF6uU5KDYLd1TEmASXaF7YmHTSAp/xGCQCo0FGyYFrXe7Cukpt+eKTH9/Qwe1n2Dpl0noN3Oo//Y/jNYB0Ob4ScouxQaQgtq+GCnDdFdabqI1lhG40x83fHbbfUHyhP8i8FfYFeC+jkWFTVcDcbpQRrg4QZhff1I8LwdZlMjuSSzRGTfI7YoTQNhFGBgQdl9mChDeWvRupaB28kS8WJI9e/f PIV AUTH pubkey"
      path = "/home/enrico/.ssh/authorized_keys"
    }
  }
  tags = {
    CreatedBy = "enrico.baccianini@crealogix.com"
  }
  lifecycle {
    ignore_changes = [
      tags ["CreatedOnDate"]
    ]
  }
}

# resource "azurerm_virtual_machine" "vm-007" {
#   name                  = "${var.subscription}-vm007"
#   location              = azurerm_resource_group.rg_principale.location
#   resource_group_name   = azurerm_resource_group.rg_principale.name
#   primary_network_interface_id = azurerm_network_interface.vm007-nic1.id
#   network_interface_ids = [azurerm_network_interface.vm007-nic1.id,azurerm_network_interface.vm007-nic2.id]
#   vm_size               = "Standard_DS1_v2"

#   delete_os_disk_on_termination = true
#   delete_data_disks_on_termination = true

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }
#   storage_os_disk {
#     name              = "myosdisk2"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }
#   os_profile {
#     computer_name  = "dx"
#     admin_username = "enrico"
#     admin_password = "Password1234!"
#   }
#   os_profile_linux_config {
#     disable_password_authentication = false
#   }
#   tags = {
#     CreatedBy = "enrico.baccianini@crealogix.com"
#   }
#   lifecycle {
#     ignore_changes = [
#       tags ["CreatedOnDate"]
#     ]
#   }
# }

