variable "name" {
  description = "The VNet name supplied by the calling root module."
  type        = string
}

variable "resource_group_name" {
  description = "The existing resource group name."
  type        = string
}

variable "location" {
  description = "Region for this workshop's VNet."
  type        = string
  default     = "japaneast"

  validation {
    condition     = var.location == "japaneast"
    error_message = "Use japaneast in this workshop."
  }
}

variable "address_space" {
  description = "Private IP address ranges reserved for the empty VNet."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "tags" {
  description = "Non-sensitive labels from the caller."
  type        = map(string)
  default     = {}
}
