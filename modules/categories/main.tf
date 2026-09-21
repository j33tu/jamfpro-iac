# Categories are Jamf Pro's basic grouping/organization mechanism for
# policies, printers, config profiles, etc. Defining them centrally here
# means other modules can reference module.categories.ids["Printers"]
# instead of hardcoding category names as free-text strings everywhere.

resource "jamfpro_category" "this" {
  for_each = toset(var.category_names)

  name     = each.value
  priority = var.priority
}
