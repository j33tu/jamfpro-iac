variable "printers" {
  description = "Map of printers to manage"
  type        = any
  default     = {}
}

variable "category_ids" {
  description = "Map of category names to Jamf category IDs"
  type        = map(string)
  default     = {}
}

variable "smart_group_ids" {
  description = "Map of smart group names to Jamf smart group IDs"
  type        = map(string)
  default     = {}
}
