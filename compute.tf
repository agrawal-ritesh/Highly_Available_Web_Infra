/*
Configured a Standard Azure Load Balancer with a static public IP, 
backend pool, health probes, and load balancing rules to distribute 
HTTP traffic only to healthy backend instances.
*/


#--------------------------------------------------------------------

#public ip block
# This block will create a public IP in Azure which will be used by users to connect.
resource "azurerm_public_ip" "pip" {
    name = "web-public_ip"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method = "Static"
    sku = "Standard"
}

#load balance block - Will create a Load Balancer. 
#Load balance will act like a traffic manager.

resource "azurerm_lb" "lb" {
    name = "web_lb"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
    sku = "Standard"

    frontend_ip_configuration {   # this will attach the public IP to load balancer
        name = "Public"
        public_ip_address_id = azurerm_public_ip.pip.id
    }
}


#backend pool block - Load Balancer (LB) will send the traffic only to member of this pool.

resource "azurerm_lb_backend_address_pool" "bckpool" {
    loadbalancer_id = azurerm_lb.lb.id
    name = "backend-pool"
}

#Health Probe block
/* 
Probe checks if someone is listening or not. 
If the VMs /Sevrers stops responding, it marks it unhealthy and LB stops sending the traffic.
*/
resource "azurerm_lb_probe" "probe" {
    loadbalancer_id = azurerm_lb.lb.id
    name = "http-probe"
    protocol = "Tcp"
    port = 80
}

#load Balancing rule block

resource "azurerm_lb_rule" "rule" {
  loadbalancer_id = azurerm_lb.lb.id
  name = "http-rule" #will create the LB rule.
  protocol = "Tcp"  #liste to port 80 and forward trafic to backend VMs
  frontend_port = 80 
  backend_port = 80
  frontend_ip_configuration_name = "Public"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.bckpool.id]  #sends traffic to backend pool only.
  probe_id = azurerm_lb_probe.probe.id  #used probe to decide healthy VMs
}