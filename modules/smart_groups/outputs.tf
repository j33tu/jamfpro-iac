output "smart_group_ids" {
  description = "Map of created Smart Group IDs for policy scoping"
  value = {
    macos_outdated  = jamfpro_smart_computer_group_v2.macos_outdated.id
    custom_ea_check = jamfpro_smart_computer_group_v2.custom_ea_check.id
  }
}
