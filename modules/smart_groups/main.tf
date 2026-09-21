# Example 1: Standard Smart Group targeting macOS Version
resource "jamfpro_smart_computer_group_v2" "macos_outdated" {
  name        = "macOS - Outdated Systems (< 15.0)"
  description = "Managed via Terraform - Catch-all group for pending OS updates"

  criteria {
    priority      = 0
    name          = "Operating System Version"
    search_type   = "less than"
    value         = "15.0.0"
    and_or        = "and"
    opening_paren = false
    closing_paren = false
  }
}

