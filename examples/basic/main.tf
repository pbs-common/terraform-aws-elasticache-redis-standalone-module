module "redis" {
  source = "../.."

  private_hosted_zone = var.private_hosted_zone

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
}
