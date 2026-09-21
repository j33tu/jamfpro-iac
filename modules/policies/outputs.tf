output "policy_ids" {
  value = { for k, v in jamfpro_policy.this : k => v.id }
}
