module "categories" {
  source     = "./modules/categories"
  categories = var.categories
}

module "smart_groups" {
  source       = "./modules/smart_groups"
  smart_groups = var.smart_groups

  depends_on = [module.categories]
}

module "printers" {
  source          = "./modules/printers"
  printers        = var.printers
  category_ids    = module.categories.category_ids
  smart_group_ids = module.smart_groups.group_ids

  depends_on = [module.smart_groups]
}

module "config_profiles" {
  source          = "./modules/config_profiles"
  profiles        = var.config_profiles
  category_ids    = module.categories.category_ids
  smart_group_ids = module.smart_groups.group_ids

  depends_on = [module.smart_groups]
}

module "policies" {
  source          = "./modules/policies"
  policies        = var.policies
  category_ids    = module.categories.category_ids
  smart_group_ids = module.smart_groups.group_ids

  depends_on = [
    module.smart_groups,
    module.config_profiles,
    module.printers
  ]
}
