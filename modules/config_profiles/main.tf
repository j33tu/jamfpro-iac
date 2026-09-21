resource "jamfpro_macos_configuration_profile_plist" "this" {
  for_each = var.config_profiles

  name        = each.key
  description = try(each.value.description, "")
  category_id = try(each.value.category_id, -1)
  level       = try(each.value.level, "computer")

  # Dynamically load payload from the specified file path
  payloads = file(each.value.payload_path)

  scope {
    all_computers      = try(each.value.all_computers, false)
    computer_group_ids = try(each.value.smart_groups, [])
  }
}
