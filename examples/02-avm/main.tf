locals {
  resource_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  tags = {
    workshop = "tf-basics-lab01"
    owner    = var.owner
    lesson   = "azure-verified-modules"
  }
}

# A module is reusable Terraform, not a different deployment tool.
module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.22.2"

  name             = "vnet-tf01avm-${var.name_suffix}"
  parent_id        = local.resource_group_id
  location         = var.location
  address_space    = ["10.10.0.0/16"]
  enable_telemetry = false
  tags             = local.tags
}

module "storage" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.10.0"

  name                            = "sttf01avm${var.name_suffix}"
  parent_id                       = local.resource_group_id
  location                        = var.location
  account_kind                    = "StorageV2"
  account_sku_name                = "Standard_LRS"
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  shared_access_key_enabled       = false
  allow_nested_items_to_be_public = false
  default_to_oauth_authentication = true
  public_network_access_enabled   = false
  enable_telemetry                = false
  tags                            = local.tags

  network_rules = {
    default_action = "Deny"
    bypass         = ["None"]
  }
}

module "plan" {
  source  = "Azure/avm-res-web-serverfarm/azurerm"
  version = "2.0.8"

  name                   = "asp-tf01avm-${var.name_suffix}"
  parent_id              = local.resource_group_id
  location               = var.location
  os_type                = "Windows"
  sku_name               = "F1"
  worker_count           = null
  zone_balancing_enabled = false
  enable_telemetry       = false
  tags                   = local.tags
}

module "site" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.23.0"

  name                                     = "app-tf01avm-${var.name_suffix}"
  parent_id                                = local.resource_group_id
  location                                 = var.location
  kind                                     = "webapp"
  os_type                                  = "Windows"
  service_plan_resource_id                 = module.plan.resource_id
  public_network_access_enabled            = true
  https_only                               = true
  client_affinity_enabled                  = true
  ftp_publish_basic_authentication_enabled = false
  scm_publish_basic_authentication_enabled = false
  delete_empty_service_plan                = false
  enable_telemetry                         = false
  tags                                     = local.tags

  site_config = {
    always_on               = false
    use_32_bit_worker       = true
    ftps_state              = "Disabled"
    minimum_tls_version     = "1.2"
    scm_minimum_tls_version = "1.2"
  }
}
