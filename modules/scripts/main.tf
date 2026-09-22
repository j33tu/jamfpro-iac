resource "jamfpro_script" "this" {
  for_each = var.scripts

  name            = each.key
  category_id     = each.value.category_id
  info            = each.value.info
  notes           = each.value.notes
  priority        = each.value.priority
  script_contents = file(each.value.file_path)
}
