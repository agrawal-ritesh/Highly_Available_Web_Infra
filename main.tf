#VM Scale Set block
resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
    name = "${local.name}-vmss"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
    sku = "Standard_B2s"
    instances = local.autoscale.min_instance
    zones = ["1", "2", "3"]
    admin_username = var.admin_username
    admin_password = var.admin_password

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsSever"
        sku = "2022-Datacenter"
        version = "lastest"
    }
    network_interface {
        name = "vmss-nic"
        primary = true

        ip_configuration {
            name = internal
            primary = true
            subnet_id = azurerm_subnet.subnet.id
            load_balancer_backend_address_pool_ids = [
                azurerm_lb_backend_address_pool.bckpool.id
            ]
        }
    }

    os_disk {
        storage_account_type = "Premium_LRS"
        caching = "ReadWrtie"
    }
    tags = local.tags

    depends_on = [azurerm_lb_rule.rule]
}