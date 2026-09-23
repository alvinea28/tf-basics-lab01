output "resource_id" {
  description = "The VNet resource ID for another module to consume."
  value       = azurerm_virtual_network.this.id
}

output "name" {
  description = "The VNet name."
  value       = azurerm_virtual_network.this.name
}
