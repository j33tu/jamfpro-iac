# Jamf Pro provider configuration.
#
# Credentials are NEVER hardcoded here. Set them as environment variables
# (locally) or as encrypted GitHub Actions secrets (in CI):
#
#   JAMFPRO_INSTANCE_FQDN
#   JAMFPRO_CLIENT_ID
#   JAMFPRO_CLIENT_SECRET
#
# The provider auto-reads JAMFPRO_* env vars, so in most cases you don't
# even need to reference var.* here explicitly -- but we wire them through
# variables.tf too so `terraform plan` fails fast with a clear error if
# something's missing, rather than a cryptic auth failure.

provider "jamfpro" {
  jamfpro_instance_fqdn = var.jamfpro_instance_fqdn
  auth_method            = "oauth2"
  client_id              = var.jamfpro_client_id
  client_secret          = var.jamfpro_client_secret

  # Prevents concurrent applies from racing against Jamf's load balancer
  # and writing inconsistent state across nodes.
  jamfpro_load_balancer_lock = true
}
