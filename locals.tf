locals {
    name = "Web-HA-Infra"
    
    autoscale = {
        min_instance = 2
        max_instance = 10
        scale_out_cpu = 70 
        scale_in_cpu = 30
    }
    tags = {
        project = local.name
        ManagedBy = "Terraform"
        Owner = "Ritesh"
    }
}