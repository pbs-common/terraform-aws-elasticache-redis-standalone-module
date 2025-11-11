module "redis" {
  source = "../.."

  private_hosted_zone = var.private_hosted_zone

  parameter_group_name = module.parameters.name

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
}

module "parameters" {
  source = "github.com/pbs/terraform-aws-elasticache-parameter-group-module?ref=0.0.1"

  name = var.product
}
