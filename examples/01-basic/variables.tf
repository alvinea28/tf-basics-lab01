variable "subscription_id" {
  description = "Your Azure subscription ID, not a password or access token."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.subscription_id))
    error_message = "Use the subscription GUID shown by az account show."
  }
}

variable "resource_group_name" {
  description = "Your existing, dedicated lab01 resource group. Terraform will not create or delete it."
  type        = string

  validation {
    condition     = can(regex("^rg-tf-basics-lab01-[a-z0-9-]{1,40}$", var.resource_group_name))
    error_message = "Use a dedicated group named rg-tf-basics-lab01-<your-suffix>."
  }
}

variable "name_suffix" {
  description = "6-12 lowercase letters/digits to make storage and web app names globally unique."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{6,12}$", var.name_suffix))
    error_message = "Use 6-12 lowercase letters and digits only."
  }
}

variable "location" {
  description = "This beginner workshop is restricted to Japan East."
  type        = string
  default     = "japaneast"

  validation {
    condition     = var.location == "japaneast"
    error_message = "Keep location = japaneast. Do not move regions to bypass an F1 quota error."
  }
}

variable "owner" {
  description = "A non-sensitive learner nickname used as a resource tag."
  type        = string
  default     = "participant"
}
