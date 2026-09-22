output "smart_group_ids" {
  description = "Map of Smart Computer Group names to their Jamf Pro IDs"
  value       = { for k, v in jamfpro_smart_computer_group_v2.this : k => v.id }
}
