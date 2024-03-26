output "backstage_service_principal_object_id" {
  value = azuread_service_principal.service_principal.object_id
}

output "backstage_service_principal_id" {
  value = azurerm_app_service.backstage_app.identity[0].principal_id
}
