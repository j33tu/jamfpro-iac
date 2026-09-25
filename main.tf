resource "jamfpro_policy" "this" {
  for_each = var.policies

  # Top-level operational attributes
  name        = each.key
  category_id = each.value.category_id
  enabled     = each.value.enabled != null ? each.value.enabled : true
  frequency   = each.value.frequency

  # Triggers
  trigger_checkin             = each.value.trigger_checkin
  trigger_enrollment_complete = each.value.trigger_enrollment
  trigger_login               = each.value.trigger_login
  trigger_other               = each.value.trigger_other

  # Scope assignment
  scope {
    all_computers = each.value.all_computers
  }

  # Executable payloads
  payloads {
    dynamic "scripts" {
      for_each = each.value.scripts
      content {
        id         = scripts.value.id
        priority   = scripts.value.priority
        parameter4 = scripts.value.parameter4
        parameter5 = scripts.value.parameter5
      }
    }
  }
}
