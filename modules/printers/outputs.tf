output "printer_ids" {
  description = "Map of printer name => Jamf Pro printer ID"
  value       = { for name, p in jamfpro_printer.this : name => p.id }
}
