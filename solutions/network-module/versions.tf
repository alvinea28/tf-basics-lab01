terraform {
  required_version = ">= 1.16.3, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.6.0"
    }
  }
}

# A reusable child module declares requirements but inherits its caller's provider.
