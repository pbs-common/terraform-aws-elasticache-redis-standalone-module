resource "aws_elasticache_subnet_group" "subnet_group" {
  count      = local.create_subnet_group ? 1 : 0
  name       = local.name
  subnet_ids = local.subnets
}
