output "profile_ids" {
  description = "Map of macOS configuration profile names to Jamf IDs"
  value       = { for k, v in jamfpro_macos_configuration_profile_plist.this : k => v.id }
}
