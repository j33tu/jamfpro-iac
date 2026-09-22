resource "jamfpro_building" "this" {
  for_each = toset(var.building_names)

  name = each.value
}
