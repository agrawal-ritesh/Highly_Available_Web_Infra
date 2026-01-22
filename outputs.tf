# to get the public IP that will be used to access the Web.
output "load_balance_public_ip" {
    value = azurerm_public_ip.pip.ip_address
}