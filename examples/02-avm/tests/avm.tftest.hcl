# Mock ALL providers: terraform test must never use the learner's Azure credentials.
mock_provider "azapi" {}
mock_provider "modtm" {}
mock_provider "random" {}
mock_provider "time" {}

override_resource {
  target = module.plan.azapi_resource.this
  values = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-tf-basics-lab01-test1234/providers/Microsoft.Web/serverfarms/asp-tf01avm-test1234"
  }
}

variables {
  subscription_id     = "00000000-0000-0000-0000-000000000000"
  resource_group_name = "rg-tf-basics-lab01-test1234"
  name_suffix         = "test1234"
}

run "japan_and_safe_storage" {
  command = plan

  assert {
    condition     = module.vnet.resource.location == "japaneast" && module.storage.resource.location == "japaneast" && module.site.resource.location == "japaneast"
    error_message = "AVM workload resources must stay in Japan East."
  }

  assert {
    condition     = module.storage.resource.body.sku.name == "Standard_LRS" && module.storage.resource.body.properties.allowSharedKeyAccess == false
    error_message = "Storage must use Standard_LRS with Shared Key disabled."
  }

  assert {
    condition     = module.site.resource.body.properties.siteConfig.alwaysOn == false && module.site.resource.body.properties.siteConfig.use32BitWorkerProcess == true
    error_message = "Keep the web app compatible with F1."
  }
}

run "reject_non_japan_region" {
  command = plan

  variables {
    location = "eastus"
  }

  expect_failures = [var.location]
}
