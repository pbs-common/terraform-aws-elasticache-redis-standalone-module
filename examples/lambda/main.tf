module "lambda" {
  source = "github.com/pbs/terraform-aws-lambda-module?ref=2.0.0"

  handler  = "index.handler"
  filename = "./artifacts/handler.zip"
  runtime  = "python3.13"

  architectures = ["arm64"]

  add_vpc_config = true

  environment_vars = {
    "REDIS_PRIMARY_ENDPOINT" = module.redis.primary_endpoint_address
    "REDIS_READER_ENDPOINT"  = module.redis.reader_endpoint_address
  }

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
}

module "redis" {
  source = "../.."

  private_hosted_zone = var.private_hosted_zone

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
}

resource "aws_security_group_rule" "redis_ingress_rule" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = module.lambda.sg
  security_group_id        = module.redis.sg_ids[0]
}
