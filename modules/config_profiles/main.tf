resource "jamfpro_mac_os_configuration_profile" "this" {
  for_each = var.profiles

  name        = each.key
  description = each.value.description
  category_id = each.value.category_id
  level       = each.value.level

  # Dynamically load raw XML payload from the payloads directory
  payloads = file(each.value.payload_path)

  scope {
    all_computers      = false
    computer_group_ids = each.value.smart_groups
  }
}
