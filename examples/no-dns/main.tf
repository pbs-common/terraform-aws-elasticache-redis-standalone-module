module "redis" {
  source = "../.."

  create_dns = false

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
}
