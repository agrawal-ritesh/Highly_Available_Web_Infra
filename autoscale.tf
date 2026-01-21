
resource "azurerm_monitor_autoscale_setting" "autoscale" {
    name = "windows-vmss-autoscale"
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
    target_resource_id = azurerm_windows_virtual_machine_scale_set.vmss.id

    profile {
        name = "default"

        capacity {
            minimum = local.autoscale.min_instance
            maximum = local.autoscale.max_instance
            default = local.autoscale.min_instance
        }

        #scale_out
        rule {
            metric_trigger {
                metric_name = "Percentage CPU"
                metric_resource_id = azurerm_windows_virtual_machine_scale_set.vmss.id
                operator = "GreaterThan"
                statistic = "Average"
                threshold = local.autoscale.scale_out_cpu
                time_window = "PT5M"
                time_grain = "PT1M"
                time_aggregation = "Average"
            }

            scale_action {
                direction = "Increase"
                type = "ChangeCount"
                value = "1"
                cooldown ="PT5M"
            }
        }

        #Scale_In
        rule {
            metric_trigger {
                metric_name = "Percentage CPU"
                metric_resource_id = azurerm_windows_virtual_machine_scale_set.vmss.id
                operator = "LessThan"
                statistic = "Average"
                threshold = local.autoscale.scale_in_cpu
                time_window = "PT5M"
                time_grain = "PT1M"
                time_aggregation = "Average"
            }

            scale_action {
                direction = "Decrease"
                type = "ChangeCount"
                value = "1"
                cooldown ="PT5M"
            }
        }
    }
    depends_on = [azurerm_windows_virtual_machine_scale_set.vmss]

}