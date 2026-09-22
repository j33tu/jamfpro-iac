output "profile_ids" {
  description = "Map of Profile names to their Jamf Pro IDs"
  value       = { for k, v in jamfpro_macos_configuration_profile_plist.this : k => v.id }
}
