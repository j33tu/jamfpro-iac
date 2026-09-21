variable "jamfpro_instance_fqdn" {
  type        = string
  description = "Jamf Pro FQDN (e.g. https://tenant.jamfcloud.com)"
}

variable "jamfpro_client_id" {
  type      = string
  sensitive = true
}

variable "jamfpro_client_secret" {
  type      = string
  sensitive = true
}
