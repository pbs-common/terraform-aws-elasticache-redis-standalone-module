resource "aws_elasticache_replication_group" "replication_group" {
  description          = local.replication_group_description
  replication_group_id = substr(local.replication_group_id, 0, 40) # Max length is 40

  apply_immediately           = var.apply_immediately
  at_rest_encryption_enabled  = var.at_rest_encryption_enabled
  auth_token                  = var.auth_token
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  automatic_failover_enabled  = local.automatic_failover_enabled
  data_tiering_enabled        = var.data_tiering_enabled
  engine                      = var.engine
  engine_version              = var.engine_version
  final_snapshot_identifier   = var.final_snapshot_identifier
  global_replication_group_id = var.global_replication_group_id
  kms_key_id                  = var.kms_key_id
  maintenance_window          = var.maintenance_window
  multi_az_enabled            = var.multi_az_enabled
  node_type                   = var.node_type
  notification_topic_arn      = var.notification_topic_arn
  num_cache_clusters          = var.nodes
  parameter_group_name        = var.parameter_group_name == null ? module.aws_elasticache_parameter_group[0].name : var.parameter_group_name
  port                        = var.port
  preferred_cache_cluster_azs = var.preferred_cache_cluster_azs
  security_group_ids          = local.security_group_ids
  snapshot_arns               = var.snapshot_arns
  snapshot_retention_limit    = var.snapshot_retention_limit
  snapshot_window             = var.snapshot_window
  subnet_group_name           = local.subnet_group_name
  transit_encryption_enabled  = var.transit_encryption_enabled
  user_group_ids              = var.user_group_ids

  dynamic "log_delivery_configuration" {
    for_each = var.log_delivery_configurations
    content {
      destination      = log_delivery_configuration.value.destination
      destination_type = log_delivery_configuration.value.destination_type
      log_format       = log_delivery_configuration.value.log_format
      log_type         = log_delivery_configuration.value.log_type
    }
  }

  tags = local.tags
}

module "aws_elasticache_parameter_group" {
  count  = var.parameter_group_name == null ? 1 : 0
  source = "github.com/pbs/terraform-aws-elasticache-parameter-group-module?ref=1.1.1"

  name         = local.name
  organization = var.organization
  environment  = var.environment
  product      = var.product
  owner        = var.owner
  repo         = var.repo
}
