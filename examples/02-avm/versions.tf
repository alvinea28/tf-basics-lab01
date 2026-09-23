terraform {
  required_version = ">= 1.16.3, < 2.0.0"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "= 2.12.0"
    }
    modtm = {
      source  = "Azure/modtm"
      version = "= 0.4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "= 3.9.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "= 0.14.2"
    }
  }
}

# These AVM releases use AzAPI even though their registry addresses end in /azurerm.
provider "azapi" {
  subscription_id            = var.subscription_id
  skip_provider_registration = true
  enable_preflight           = false
}
