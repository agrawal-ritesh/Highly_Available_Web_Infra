#public ip block
resource "azurerm_public_ip" "pip" {
    name = "web-public_ip"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method = "Static"
    sku = "Standard"
}

#load balance block

resource "azurerm_lb" "lb" {
    name = "web_lb"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
    sku = "Standard"

    frontend_ip_configuration {
        name = "Public"
        public_ip_address_id = azurerm_public_ip.pip.id
    }
}


#backend pool block

resource "azurerm_lb_backend_address_pool" "bckpool" {
    loadbalancer_id = azurerm_lb.lb.id
    name = "backend-pool"
}

#Health Probe block

resource "azurerm_lb_probe" "probe" {
    loadbalancer_id = azurerm_lb.lb.id
    name = "http-probe"
    protocol = "Tcp"
    port = 80
}

#load Balancing rule block

resource "azurerm_lb_rule" "rule" {
  loadbalancer_id = azurerm_lb.lb.id
  name = "http-rule"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  frontend_ip_configuration_name = "PublicIP"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.bckpool.id]
  probe_id = azurerm_lb_probe.probe.id
}