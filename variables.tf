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
variable "category_name" {
  type        = string
  description = "Category name for custom configuration profiles and scripts"
  default     = "Security & Compliance"
}

variable "building_names" {
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
