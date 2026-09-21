variable "categories" {
  description = "Map of categories passed to the module"
  type = map(object({
    priority = number
  }))
  default = {}
}
