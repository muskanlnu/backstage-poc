# Your environment, for example "test" or "prod"
variable "environment" {
    type = string
    default = "test"
}

# Name of your service, for example "ContainerRegistry" or "cicd" or whatever suits your organization
variable "service_name" {
    type = string
    default = "backstage-poc-ContainerRegistry"
}


variable "location" {
    type = string
    default = "East US"
}

# The ID in the output "backstage_service_principal_id" in the section above
variable "backstage_app_service_principal_id" {
    type = string
}

# The ID in the output "backstage_service_principal_object_id" in the section above
variable "backstage_service_principal_id" {
    type = string
}