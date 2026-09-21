output "profile_ids" {
  value = { for k, v in jamfpro_mac_os_configuration_profile.this : k => v.id }
}
