# --- Provider & Authentication Variables ---

variable "jamfpro_instance_fqdn" {
  type        = string
  description = "The FQDN of the Jamf Pro instance (e.g. mycompany.jamfcloud.com)"
}

variable "jamfpro_client_id" {
  type        = string
  description = "OAuth2 Client ID for Jamf Pro API Access"
  sensitive   = true
}

variable "jamfpro_client_secret" {
  type        = string
  description = "OAuth2 Client Secret for Jamf Pro API Access"
  sensitive   = true
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., production, staging)"
  default     = "production"
}

# --- Infrastructure Data Maps ---

variable "categories" {
  type = map(object({
    priority = number
  }))
  description = "Map of category names and their priority levels"
  default = {
    "Security & Compliance" = { priority = 10 }
  }
}

variable "buildings" {
  type        = list(string)
  description = "List of building names to create in Jamf Pro"
  default     = ["HQ - New York", "Branch - London", "Remote", "mumbai"]
}

variable "scripts_config" {
  type = map(object({
    category_name = string
    info          = string
    notes         = string
    priority      = string
    file_path     = string
  }))
  description = "Map of script definitions"
  default     = {}
}

variable "configuration_profiles" {
  type = map(object({
    description        = string
    category_name      = string
    level              = string
    all_computers      = bool
    redeploy_on_update = bool
    payload_path       = string
  }))
  description = "Map of macOS configuration profiles"
  default     = {}
}
variable "policies" {
  type = map(object({
    category_name      = string
    frequency          = string
    enabled            = optional(bool, true)
    trigger_checkin    = optional(bool, false)
    trigger_enrollment = optional(bool, false)
    trigger_login      = optional(bool, false)
    trigger_other      = optional(string, "")
    all_computers      = optional(bool, false)
    script_names       = optional(list(string), [])
  }))
  description = "Map of policies to execute scripts or maintenance tasks"
  default     = {}
}
