output "policy_ids" {
  description = "Map of policy names to their Jamf Pro IDs"
  value       = { for k, v in jamfpro_policy.this : k => v.id }
}
