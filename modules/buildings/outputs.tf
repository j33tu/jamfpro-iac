output "building_ids" {
  description = "Map of building names to their Jamf Pro IDs"
  value       = { for k, v in jamfpro_building.this : k => v.id }
}
