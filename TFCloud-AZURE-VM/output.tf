output "AppServer" {
  value = azurerm_linux_virtual_machine.appserver.public_ip_address
}
# output "DBServer" {
#   value = azurerm_linux_virtual_machine.dbserver.public_ip_address
# }
# output "DBServerPrivateIP" {
#   value = azurerm_network_interface.dbservernic.private_ip_address
# }