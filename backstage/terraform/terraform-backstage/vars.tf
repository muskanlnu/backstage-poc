# Environment, for example "prod" or "test"
variable "environment" {
    type = string
    default = "test"
}

# The name of your new service, for example "backstage"
variable "service_name" { 
    type = string
    default = "backstage-poc"
}

# Change this to match whatever suits you best
variable "location" {
    type = string
    default = "East US"
}

# An admin password for your database
variable "db_admin_password" {
    type = string
    default = "AAbb##123"
}

variable "db_admin_username" {
    type = string
    default = "psqladmin"
}

# Whatever domain you want your service to answer to. To get up and running, just let this be the *.azurewebsites.net.
variable "custom_domain" {
    type = string
    default = "backstage-poc-appservice.azurewebsites.net"
}
  
variable "github_backstage_appid" {
    type = string
}

variable "github_backstage_webhookUrl" {
    type = string
}

variable "github_backstage_clientId" {
    type = string
}

variable "github_backstage_clientSecret" {
    type = string
}
  
variable "github_backstage_webhookSecret" {
    type = string
}
  
variable "github_backstage_privateKey" {
    type = string
}
