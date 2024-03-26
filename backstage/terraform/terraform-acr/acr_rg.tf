terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.89.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "2.12.0"
    }
    github = {
      source = "integrations/github"
      version = "4.19.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
}

provider "github" {
  owner = "Microsoft"
  app_auth { }
}

# I use "abcd" as my "company name" here as an example, substitute for anything you want.
# Combining this name_prefix with resource type in names later on enforces good naming practices for the Azure resources.

locals {
  name_prefix = "backstage-poc-${var.environment}${var.service_name}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.name_prefix}rg"
  location = var.location
}

resource "azuread_application" "container_registry_contributor" {
  display_name = "${local.name_prefix}service"
}

resource "azuread_service_principal" "cr_contributor_service_principal" {
  application_id = azuread_application.container_registry_contributor.application_id
  tags           = ["container registry", "docker", "github"]
}

resource "azuread_application_password" "cr_contributor_service_principal_password" {
  application_object_id = azuread_application.container_registry_contributor.object_id
  end_date              = "2099-02-01T01:02:03Z"
}

resource "azurerm_container_registry" "acr" {
  name                = "${local.name_prefix}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "container_registry_contributor_role_assignment" {
  scope                = azurerm_container_registry.acr[0].id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.cr_contributor_service_principal.object_id
}

resource "azurerm_role_assignment" "backstage_app_service_principal_acr_role_assignment" {
  scope                = azurerm_container_registry.acr[0].id
  role_definition_name = "Reader"
  principal_id         = var.backstage_app_service_principal_id
}

resource "azurerm_role_assignment" "backstage_app_service_principal_acr_acrpull_role_assignment" {
  scope                = azurerm_container_registry.acr[0].id
  role_definition_name = "AcrPull"
  principal_id         = var.backstage_app_service_principal_id
}

resource "azurerm_role_assignment" "backstage_service_principal_acr_acrpull_role_assignment" {
  scope                = azurerm_container_registry.acr[0].id
  role_definition_name = "AcrPull"
  principal_id         = var.backstage_service_principal_id
}

resource "github_actions_organization_secret" "registry_login_server" {
  secret_name     = "REGISTRY_LOGIN_SERVER"
  visibility      = "private"
  plaintext_value = azurerm_container_registry.acr[0].login_server
}

resource "github_actions_organization_secret" "registry_username" {
  secret_name     = "REGISTRY_USERNAME"
  visibility      = "private"
  plaintext_value = azuread_service_principal.cr_contributor_service_principal.application_id
}

resource "github_actions_organization_secret" "registry_password" {
  secret_name     = "REGISTRY_PASSWORD"
  visibility      = "private"
  plaintext_value = azuread_application_password.cr_contributor_service_principal_password.value
}