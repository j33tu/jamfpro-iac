# Test Resource: Create a baseline category
resource "jamfpro_category" "security" {
  name     = "Security & Compliance"
  priority = 10
}
resource "jamfpro_smart_computer_group" "outdated_macs" {
  name        = "macOS Outdated (< 14.0)"
  category_id = jamfpro_category.security.id

  criteria {
    name        = "Operating System Version"
    priority    = 0
    and_or      = "and"
    search_type = "less than"
    value       = "14.0.0"
  }
}
