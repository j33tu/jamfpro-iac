output "category_ids" {
  description = "Map of category names to their Jamf Pro IDs"
  value       = { for k, v in jamfpro_category.this : k => v.id }
}
