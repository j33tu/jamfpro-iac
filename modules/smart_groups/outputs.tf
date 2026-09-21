output "group_ids" {
  description = "Map of smart group names to their Jamf IDs"
  value       = { for k, v in jamfpro_smart_computer_group.this : k => v.id }
}
