variable "subscription_id" {
  description = "The subscription containing your pre-created lab01 resource group."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.subscription_id))
    error_message = "Use your Azure subscription GUID, not credentials."
  }
}

variable "resource_group_name" {
  description = "The existing, dedicated participant group; this example never manages the group."
  type        = string

  validation {
    condition     = can(regex("^rg-tf-basics-lab01-[a-z0-9-]{1,40}$", var.resource_group_name))
    error_message = "Use your own rg-tf-basics-lab01-<suffix> group."
  }
}

variable "name_suffix" {
  description = "6-12 lowercase letters/digits for unique resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{6,12}$", var.name_suffix))
    error_message = "Use 6-12 lowercase letters and digits."
  }
}

variable "location" {
  description = "Only Japan East is allowed in this workshop."
  type        = string
  default     = "japaneast"

  validation {
    condition     = var.location == "japaneast"
    error_message = "Keep the workshop in japaneast."
  }
}

variable "owner" {
  description = "Non-sensitive nickname for resource tags."
  type        = string
  default     = "participant"
}
