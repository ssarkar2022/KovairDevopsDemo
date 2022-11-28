variable "resource_group_name" {
  default       = "KovairDevOps"
  description   = "Resource group name in your Azure subscription."
}

variable "resource_group_location" {
  default       = "eastus"
  description   = "Location of the resource group."
}

variable "appserver_name" {
  default       = "testaapvm"
  description   = "App VM Name."
}

# variable "dbserver_name" {
#   default       = "testdbvm"
#   description   = "DB VM Name."
# }

variable "url" {
  type = string
  default = "productiontest"
}