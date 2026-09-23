# A data block READS something that already exists; it does not create the group.
data "azurerm_resource_group" "workshop" {
  name = var.resource_group_name
}

# Locals are reusable values, not extra Azure resources.
locals {
  tags = {
    workshop = "tf-basics-lab01"
    owner    = var.owner
    lesson   = "first-deployment"
  }
}

# An empty VNet teaches address space. No subnet, VM, gateway, or peering is created.
resource "azurerm_virtual_network" "workshop" {
  name                = "vnet-tf01-${var.name_suffix}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.workshop.name
  address_space       = ["10.10.0.0/16"]
  tags                = local.tags
}

# Standard_LRS is low cost, not a promise of free storage.
# The account is empty and public DATA access is disabled. ARM management still works.
resource "azurerm_storage_account" "workshop" {
  name                            = "sttf01${var.name_suffix}"
  location                        = var.location
  resource_group_name             = data.azurerm_resource_group.workshop.name
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  shared_access_key_enabled       = false
  allow_nested_items_to_be_public = false
  default_to_oauth_authentication = true
  public_network_access           = "Disabled"
  tags                            = local.tags
}

# Every web app needs a plan. F1 is hard-coded: no paid fallback.
resource "azurerm_service_plan" "workshop" {
  name                = "asp-tf01-${var.name_suffix}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.workshop.name
  os_type             = "Windows"
  sku_name            = "F1"
  tags                = local.tags
}

# This creates the hosting resource, not custom application code.
# F1 cannot connect to the VNet; the default HTTPS welcome page is public.
resource "azurerm_windows_web_app" "workshop" {
  name                                           = "app-tf01-${var.name_suffix}"
  location                                       = var.location
  resource_group_name                            = data.azurerm_resource_group.workshop.name
  service_plan_id                                = azurerm_service_plan.workshop.id
  https_only                                     = true
  public_network_access_enabled                  = true
  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false
  client_affinity_enabled                        = true
  tags                                           = local.tags

  site_config {
    always_on               = false
    use_32_bit_worker       = true
    ftps_state              = "Disabled"
    minimum_tls_version     = "1.2"
    scm_minimum_tls_version = "1.2"
  }
}
