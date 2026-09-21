# Printer definitions. PPD files live in ./ppds/ alongside this module and
# are read in as raw content -- Terraform doesn't "discover" them on its
# own, we have to explicitly point at each file (see the PPD discussion:
# `ppd` is just a filename label, `ppd_contents` is the actual driver data).

resource "jamfpro_printer" "this" {
  for_each = var.printers

  name         = each.key
  category     = each.value.category
  uri          = each.value.uri
  cups_name    = each.value.cups_name
  location     = each.value.location
  model        = each.value.model
  make_default = each.value.make_default
  use_generic  = each.value.use_generic

  # Only set PPD fields when NOT using the generic driver.
  ppd          = each.value.use_generic ? null : "${each.key}.ppd"
  ppd_contents = each.value.use_generic ? null : file("${path.module}/ppds/${each.value.ppd_filename}")
}

# Deploy each printer to its scoped smart group via a policy.
resource "jamfpro_policy" "deploy_printer" {
  for_each = var.printers

  name    = "Deploy - ${each.key}"
  enabled = true

  printers {
    leave_existing_default = false

    printer {
      id           = jamfpro_printer.this[each.key].id
      action       = "install"
      make_default = each.value.make_default
    }
  }

  scope {
    computer_group_ids = [var.smart_group_ids[each.value.scope_group_name]]
  }
}
