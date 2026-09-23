output "resource_group_name" {
  description = "The existing group containing your four workload resources."
  value       = data.azurerm_resource_group.workshop.name
}

output "vnet_name" {
  description = "Your empty virtual network."
  value       = azurerm_virtual_network.workshop.name
}

output "storage_account_name" {
  description = "The empty storage account name; never output its keys."
  value       = azurerm_storage_account.workshop.name
}

output "web_app_name" {
  description = "The Windows web app name."
  value       = azurerm_windows_web_app.workshop.name
}

output "web_app_url" {
  description = "The public HTTPS welcome page; no app code is deployed by this lab."
  value       = "https://${azurerm_windows_web_app.workshop.default_hostname}"
}
