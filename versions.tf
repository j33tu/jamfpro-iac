terraform {
  required_version = ">= 1.7.0"

  required_providers {
    jamfpro = {
      source  = "deploymenttheory/jamfpro"
      version = "~> 0.20"
    }
  }
}
