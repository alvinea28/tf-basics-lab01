output "resource_group_name" {
  description = "Your pre-created resource group, outside this Terraform state."
  value       = var.resource_group_name
}

output "vnet_name" {
  description = "The empty VNet name."
  value       = module.vnet.name
}

output "storage_account_name" {
  description = "The empty storage account name, never an access key."
  value       = module.storage.name
}

output "web_app_name" {
  description = "The Windows web app name."
  value       = module.site.name
}

output "web_app_url" {
  description = "The default public HTTPS welcome page."
  value       = "https://${module.site.resource_uri}"
}
