variable "location" {
    default = "Central India"
}
variable "resource_group_name" {
    default = "webInfra-rg"
}
variable "admin_username" {
    default = "admin12345"
}
variable "admin_password" {
    sensitive = true
}
