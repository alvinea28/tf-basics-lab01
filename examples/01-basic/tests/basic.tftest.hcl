# Every provider in this test is mocked. No Azure sign-in or resources are used.
mock_provider "azurerm" {
  mock_data "azurerm_resource_group" {
    defaults = {
      name     = "rg-tf-basics-lab01-test1234"
      location = "japaneast"
      id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-basics-lab01-test1234"
    }
  }
}

variables {
  subscription_id     = "00000000-0000-0000-0000-000000000000"
  resource_group_name = "rg-tf-basics-lab01-test1234"
  name_suffix         = "test1234"
}

run "free_tier_and_japan" {
  command = plan

  assert {
    condition     = azurerm_service_plan.workshop.sku_name == "F1" && azurerm_service_plan.workshop.os_type == "Windows"
    error_message = "The workshop must use Windows F1, never a paid plan."
  }

  assert {
    condition     = !azurerm_windows_web_app.workshop.site_config[0].always_on && azurerm_windows_web_app.workshop.site_config[0].use_32_bit_worker
    error_message = "F1 requires Always On off and a 32-bit worker."
  }

  assert {
    condition = alltrue([
      azurerm_virtual_network.workshop.location == "japaneast",
      azurerm_storage_account.workshop.location == "japaneast",
      azurerm_service_plan.workshop.location == "japaneast",
      azurerm_windows_web_app.workshop.location == "japaneast"
    ])
    error_message = "Every workload resource must stay in Japan East."
  }

  assert {
    condition     = azurerm_storage_account.workshop.account_replication_type == "LRS" && !azurerm_storage_account.workshop.shared_access_key_enabled && !azurerm_storage_account.workshop.allow_nested_items_to_be_public && azurerm_storage_account.workshop.public_network_access == "Disabled"
    error_message = "Storage must stay Standard LRS, keyless, and closed to public data access."
  }
}

run "reject_non_japan_region" {
  command = plan

  variables {
    location = "eastus"
  }

  expect_failures = [var.location]
}
