resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.location
}

resource "azurerm_virtual_network" "vnet" {
    resource_group_name = azurerm_resource_group.rg.name
    name = "webInfra-vnet"
    location = var.location
    address_space = ["10.0.2.0/16"]
    tags = local.tags
}
resource "azurerm_subnet" "subnet" {
    name = "web-subnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.2.1/24"]

    depends_on = [azurerm_virtual_network.vnet]
}
