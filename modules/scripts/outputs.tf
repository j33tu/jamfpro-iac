output "script_ids" {
  description = "Map of script names to their Jamf Pro IDs"
  value       = { for k, v in jamfpro_script.this : k => v.id }
}
