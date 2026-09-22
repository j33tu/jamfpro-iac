variable "categories" {
  type = map(object({
    priority = number
  }))
  description = "Map of category names to their priority values"
  default     = {}
}
