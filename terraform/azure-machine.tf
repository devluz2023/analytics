resource "tls_private_key" "vm1key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "azurerm_linux_virtual_machine" "ubuntu-machine" {
  name                  = var.vm_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.analytics.id]
  size                  = "Standard_DS2_v2"  
  admin_username        = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.vm1key.public_key_openssh
  }

  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

 admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.vm1key.public_key_openssh
  }                                                                                                                                                                                                                                                                         
}


resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm1" {
  virtual_machine_id = azurerm_linux_virtual_machine.ubuntu-machine.id
  location           = azurerm_resource_group.rg.location
  enabled            = true

  daily_recurrence_time = var.vmShutdownTime
  timezone              = var.vmShutdownTimeZone

  notification_settings {
    enabled = false
  }
}


resource "azurerm_virtual_machine_extension" "vm1extension" {
  name                 = var.vm_name
  virtual_machine_id   = azurerm_linux_virtual_machine.ubuntu-machine.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
        "fileUris":["https://raw.githubusercontent.com/devluz2023/analytics/main/scripts/ubuntu-setup-ansible.sh"]
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
        "commandToExecute": ". ./ubuntu-setup-ansible.sh"
    }
PROTECTED_SETTINGS
}

# resource "null_resource" "install_ansible" {
#   triggers = {
#     always_run = "${timestamp()}"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt-get update",
#       "sudo apt-get install -y ansible",
#       "ansible-playbook -i localhost, -c local ../ansible/install_mssql.yml"
#       # Add any other installation steps as needed
#     ]

#     connection {
#       type        = "ssh"
#       user        = var.admin_username
#       host        = azurerm_public_ip.analytics-public-ip.ip_address
#       private_key = file("~/.ssh/azure-key")
#     }


#   }

#   depends_on = [azurerm_linux_virtual_machine.ubuntu-machine]
# }
