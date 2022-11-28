terraform{
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.27"
        }
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~> 3.11"
        }
    }

    required_version = ">= 0.14.9"
}

provider "aws" {
    profile = "default"
    region = "us-east-2"
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

# Create Load Balancer public IPs
resource "azurerm_public_ip" "loadbalancerip" {
  name                = "${var.appserver_name}LBIP"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  allocation_method   = "Static"
}

# Create App Server public IPs
resource "azurerm_public_ip" "appserverpublicip" {
  name                = "${var.appserver_name}publicIP"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  allocation_method   = "Static"
}

# # Create DB Server public IPs
# resource "azurerm_public_ip" "dbserverpublicip" {
#   name                = "${var.dbserver_name}publicIP"
#   location            = var.resource_group_location
#   resource_group_name = var.resource_group_name
#   allocation_method   = "Static"
# }

# Create app server network interface
resource "azurerm_network_interface" "appservernic" {
  name                = "${var.appserver_name}NIC"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.appserver_name}IPConfig"
    subnet_id                     = "/subscriptions/4df768f8-9063-47c5-82cd-60ebaa90333e/resourceGroups/KovairDevOps/providers/Microsoft.Network/virtualNetworks/KovairDevOpsvnet186/subnets/ApplicationGateway"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.appserverpublicip.id
  }

  depends_on = [azurerm_public_ip.appserverpublicip]
}

# # Create DB server network interface
# resource "azurerm_network_interface" "dbservernic" {
#   name                = "${var.dbserver_name}NIC"
#   location            = var.resource_group_location
#   resource_group_name = var.resource_group_name

#   ip_configuration {
#     name                          = "${var.dbserver_name}IPConfig"
#     subnet_id                     = "/subscriptions/4df768f8-9063-47c5-82cd-60ebaa90333e/resourceGroups/KovairDevOps/providers/Microsoft.Network/virtualNetworks/KovairDevOpsvnet186/subnets/ApplicationGateway1"
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.dbserverpublicip.id
#   }

#   depends_on = [azurerm_public_ip.dbserverpublicip]
# }

# Connect the app server security group to the network interface
resource "azurerm_network_interface_security_group_association" "appnicsgassociation" {
  network_interface_id      = azurerm_network_interface.appservernic.id
  network_security_group_id = "/subscriptions/4df768f8-9063-47c5-82cd-60ebaa90333e/resourceGroups/KovairDevOps/providers/Microsoft.Network/networkSecurityGroups/test12-nsg"

  depends_on = [azurerm_network_interface.appservernic]
}

# # Connect the DB server security group to the network interface
# resource "azurerm_network_interface_security_group_association" "dbnicsgassociation" {
#   network_interface_id      = azurerm_network_interface.dbservernic.id
#   network_security_group_id = "/subscriptions/4df768f8-9063-47c5-82cd-60ebaa90333e/resourcegroups/KovairDevOps/providers/Microsoft.Network/networkSecurityGroups/DBServerNSG"

#   depends_on = [azurerm_network_interface.dbservernic]
# }

# Create storage account for app server boot diagnostics
resource "azurerm_storage_account" "appvmstorageaccount" {
  name                     = trim("diag${var.appserver_name}","-")
  location                 = var.resource_group_location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# # Create storage account for DB server boot diagnostics
# resource "azurerm_storage_account" "dbvmstorageaccount" {
#   name                     = trim("diag${var.dbserver_name}","-")
#   location                 = var.resource_group_location
#   resource_group_name      = var.resource_group_name
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# Create virtual machine(app server)
resource "azurerm_linux_virtual_machine" "appserver" {
  name                       = var.appserver_name
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name
  network_interface_ids      = [azurerm_network_interface.appservernic.id]
  size                       = "Standard_B2ms"
  custom_data                = base64encode("${file("UC.sh")}")

  os_disk {
    name                 = var.appserver_name
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    
  }

  source_image_reference {
    //publisher = "OpenLogic"
    publisher = "canonical"
    //offer     = "CentOS"
    offer     = "0001-com-ubuntu-server-focal"
    //sku       = "7_9-gen2"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = var.appserver_name
  admin_username                  = "kovairadmin"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "kovairadmin"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDqXQhvSAF8dH5fKXeVtYaYK0n2Ty7sNL1J3MPp5Y6H+UxLEFVRSOSze0/d3XE/l65/h8HaBPFaqjZ9uvfjv/dQjTXgwOZ/31Y7/RSCy3PaTLfsT55r95sXkUfALYj4pgByjFnGXW4j0hxNNJzFw6cbiJAFMgdlIbqzwERGfTYWWaofRQow7nPDlFWL75SIo+8gvYaSftKJk9jR859pBoJ8HQ0xQIcNMIcS1ovXKooocN2D5CIj5Xbd5dctxrn539mqRHNy2grL25iKPZ1plPl8Ej/Cw5xifuv3kAY9hWNcL1sMU16Xu42AjT2sQC9fO8Vom5rqAHpJo0pj1640EKYnqMAfz2h/hV+J/hnkMOOlPZ/KWfLA7nblqJm6mo/FfxLJQx1J6kZPZlHMbtUF+eGn58XTtdSspdnZsUOJ0If0wCrfnNPS0mQUe5BMDkgtB8FZ2eUC9gLFhK9favN/vTuhIpowhF4frYmFxGdVd5V06d4tRoTP8N8FucQDz8J9wpE= generated-by-azure" //existing ssh key(KovDevOps-App) needs to be set
  }

  connection {
      type = "ssh"
      user = "kovairadmin"
      host = azurerm_linux_virtual_machine.appserver.public_ip_address
      private_key = "${file("KovDevOps-App.pem")}"
  }

  provisioner "file" {
    source = "/home/kovair/devops_demo/TFCloud-AZURE-VM/authorized_keys"
    destination = "/home/kovairadmin/authorized_keys"
  }

  provisioner "remote-exec" {
      inline = ["sudo hostname KovairDevOpsApp"]
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.appvmstorageaccount.primary_blob_endpoint
  }

  depends_on = [azurerm_public_ip.appserverpublicip,azurerm_storage_account.appvmstorageaccount,azurerm_network_interface.appservernic]
}

# # Create virtual machine(db server)
# resource "azurerm_linux_virtual_machine" "dbserver" {
#   name                       = var.dbserver_name
#   location                   = var.resource_group_location
#   resource_group_name        = var.resource_group_name
#   network_interface_ids      = [azurerm_network_interface.dbservernic.id]
#   size                       = "Standard_B2ms"
#   custom_data                = base64encode("${file("UC.sh")}")

#   os_disk {
#     name                 = var.dbserver_name
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
    
#   }

#   source_image_reference {
#     //publisher = "OpenLogic"
#     publisher = "canonical"
#     //offer     = "CentOS"
#     offer     = "0001-com-ubuntu-server-focal"
#     //sku       = "7_9-gen2"
#     sku       = "20_04-lts-gen2"
#     version   = "latest"
#   }

#   computer_name                   = var.dbserver_name
#   admin_username                  = "kovairadmin"
#   disable_password_authentication = true

#   admin_ssh_key {
#     username   = "kovairadmin"
#     public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDqXQhvSAF8dH5fKXeVtYaYK0n2Ty7sNL1J3MPp5Y6H+UxLEFVRSOSze0/d3XE/l65/h8HaBPFaqjZ9uvfjv/dQjTXgwOZ/31Y7/RSCy3PaTLfsT55r95sXkUfALYj4pgByjFnGXW4j0hxNNJzFw6cbiJAFMgdlIbqzwERGfTYWWaofRQow7nPDlFWL75SIo+8gvYaSftKJk9jR859pBoJ8HQ0xQIcNMIcS1ovXKooocN2D5CIj5Xbd5dctxrn539mqRHNy2grL25iKPZ1plPl8Ej/Cw5xifuv3kAY9hWNcL1sMU16Xu42AjT2sQC9fO8Vom5rqAHpJo0pj1640EKYnqMAfz2h/hV+J/hnkMOOlPZ/KWfLA7nblqJm6mo/FfxLJQx1J6kZPZlHMbtUF+eGn58XTtdSspdnZsUOJ0If0wCrfnNPS0mQUe5BMDkgtB8FZ2eUC9gLFhK9favN/vTuhIpowhF4frYmFxGdVd5V06d4tRoTP8N8FucQDz8J9wpE= generated-by-azure" //existing ssh key(KovDevOps-App) needs to be set
#   }

#   connection {
#       type = "ssh"
#       user = "kovairadmin"
#       host = azurerm_linux_virtual_machine.dbserver.public_ip_address
#       private_key = "${file("KovDevOps-App.pem")}"
#   }

#   provisioner "file" {
#     source = "/home/kovair/devops_demo/TFCloud-AZURE-VM/authorized_keys"
#     destination = "/home/kovairadmin/authorized_keys"
#   }

#   provisioner "remote-exec" {
#       inline = ["sudo hostname KovairDevOpsDB"]
#   }

#   boot_diagnostics {
#     storage_account_uri = azurerm_storage_account.dbvmstorageaccount.primary_blob_endpoint
#   }

#   depends_on = [azurerm_public_ip.dbserverpublicip,azurerm_storage_account.dbvmstorageaccount,azurerm_network_interface.dbservernic]
# }

#Create Load Balancer
resource "azurerm_lb" "lb" {
  name                = var.appserver_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  //type                = "Public"
  sku_tier            = "Regional"

  frontend_ip_configuration {
    name                 = "${var.appserver_name}FIP"
    public_ip_address_id = azurerm_public_ip.loadbalancerip.id
    //virtual_network      = "/subscriptions/4df768f8-9063-47c5-82cd-60ebaa90333e/resourceGroups/KovairDevOps/providers/Microsoft.Network/virtualNetworks/KovairDevOpsvnet186"
    //subnet_id            = "/subscriptions/4df768f8-9063-47c5-82cd-60ebaa90333e/resourceGroups/KovairDevOps/providers/Microsoft.Network/virtualNetworks/KovairDevOpsvnet186/subnets/ApplicationGateway1"
    //assignment           = "Dynamic"
    //availabilty_zone     = "Zone-redundant"
  }

  depends_on = [azurerm_public_ip.loadbalancerip]
}

resource "azurerm_lb_backend_address_pool" "lb_bap" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "${var.appserver_name}BP"

  depends_on = [azurerm_lb.lb]
}

resource "azurerm_lb_backend_address_pool_address" "lb_bapa" {
  name                    = "${var.appserver_name}BPA"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_bap.id
  virtual_network_id      = "/subscriptions/4df768f8-9063-47c5-82cd-60ebaa90333e/resourceGroups/KovairDevOps/providers/Microsoft.Network/virtualNetworks/KovairDevOpsvnet186"
  ip_address              = azurerm_network_interface.appservernic.private_ip_address

  depends_on = [azurerm_lb_backend_address_pool.lb_bap,azurerm_network_interface.appservernic]
}

resource "azurerm_lb_probe" "health_probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "${var.appserver_name}HP"
  protocol        = "Tcp"
  port            = 8080
  interval_in_seconds = 10
  number_of_probes = 10

  depends_on = [azurerm_lb.lb]
}

resource "azurerm_lb_rule" "lb_rule1" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "Rule1"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 8080
  frontend_ip_configuration_name = "${var.appserver_name}FIP"
  probe_id                       = azurerm_lb_probe.health_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_bap.id]

  depends_on = [azurerm_lb.lb,azurerm_lb_probe.health_probe]
}

resource "azurerm_lb_rule" "lb_rule2" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "Rule2"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 8443
  frontend_ip_configuration_name = "${var.appserver_name}FIP"
  probe_id                       = azurerm_lb_probe.health_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_bap.id]

  depends_on = [azurerm_lb.lb,azurerm_lb_probe.health_probe]
}

# Create route 53 record in AWS
resource "aws_route53_record" "kovairdomain" {
  zone_id = "Z07790763S12SIKNP8T7A"
  name    = var.url
  type    = "A"
  ttl     = "300"
  records = [azurerm_public_ip.loadbalancerip.ip_address]
  //records = [azurerm_lb.lb.frontend_ip_configuration.public_ip_address]

  depends_on = [azurerm_public_ip.loadbalancerip]
  //depends_on = [azurerm_lb.lb]
}
