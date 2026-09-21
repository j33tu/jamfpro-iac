# ==============================================================================
# Jamf Pro Authentication & Global Settings
# ==============================================================================

variable "jamfpro_instance_fqdn" {
  description = "Your Jamf Pro instance URL, e.g. https://yourorg.jamfcloud.com"
  type        = string
}

variable "jamfpro_client_id" {
  description = "Client ID for the Jamf Pro API role/integration used by Terraform"
  type        = string
  sensitive   = true
}

variable "jamfpro_client_secret" {
  description = "Client secret for the Jamf Pro API role/integration used by Terraform"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Logical environment name, used for tagging/naming (e.g. production, staging)"
  type        = string
  default     = "production"
}

# ==============================================================================
# Module Resource Maps
# ==============================================================================

variable "categories" {
  description = "Map of categories to create in Jamf Pro"
  type        = any
  default     = {}

}

variable "smart_groups" {
  description = "Map of smart computer groups to configure"
  type        = any
  default     = {}
}

variable "printers" {
  description = "Map of printers and PPD configurations to deploy"
  type        = any
  default     = {}
}

variable "config_profiles" {
  description = "Map of macOS configuration profiles (.mobileconfig) to manage"
  type        = any
  default     = {}
}

variable "policies" {
  description = "Map of Jamf policies (scripts, packages, scopes, triggers) to manage"
  type        = any
  default     = {}
}
