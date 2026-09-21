terraform {
  required_version = ">= 1.9.0"
  required_providers {
    jamfpro = {
      source  = "deploymenttheory/jamfpro"
      version = "~> 0.18.0"
    }
  }
}

provider "jamfpro" {
  jamfpro_instance_fqdn = var.jamf_fqdn
  auth_method           = "oauth2"
  client_id             = var.jamf_client_id
  client_secret         = var.jamf_client_secret
}
