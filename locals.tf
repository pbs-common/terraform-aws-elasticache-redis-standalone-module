locals {
  name                = var.name != null ? var.name : var.product
  security_group_ids  = var.security_group_ids != null ? var.security_group_ids : [aws_security_group.sg.id]
  subnet_group_name   = var.subnet_group_name != null ? var.subnet_group_name : aws_elasticache_subnet_group.subnet_group.id
  vpc_id              = var.vpc_id != null ? var.vpc_id : data.aws_vpc.vpc[0].id
  subnets             = var.subnets != null ? var.subnets : data.aws_subnets.private_subnets[0].ids
  cname               = var.cname != null ? var.cname : "${local.name}-cache"
  private_hosted_zone = var.create_dns ? data.aws_route53_zone.private_hosted_zone[0].zone_id : null

  vpc_data_lookup_tags = var.vpc_data_lookup_tags != null ? var.vpc_data_lookup_tags : {
    "environment" : var.environment
  }

  subnet_data_lookup_filters = var.subnet_data_lookup_filters != null ? var.subnet_data_lookup_filters : {
    "vpc-id"   = [local.vpc_id]
    "tag:Name" = ["*-private-*"]
  }

  replication_group_description = var.replication_group_description != null ? var.replication_group_description : "Replication group for ${local.name}"
  replication_group_id          = var.replication_group_id != null ? var.replication_group_id : local.name

  sg_name        = var.use_prefix ? null : var.sg_name != null ? var.sg_name : local.name
  sg_name_prefix = var.use_prefix ? var.sg_name != null ? var.sg_name : local.name : null

  automatic_failover_enabled = var.automatic_failover_enabled != null ? var.automatic_failover_enabled : var.nodes >= 2

  creator = "terraform"

  defaulted_tags = merge(
    var.tags,
    {
      Name                                      = local.name
      "${var.organization}:billing:product"     = var.product
      "${var.organization}:billing:environment" = var.environment
      "${var.organization}:billing:owner"       = var.owner
      creator                                   = local.creator
      repo                                      = var.repo
    }
  )

  tags = merge({ for k, v in local.defaulted_tags : k => v if lookup(data.aws_default_tags.common_tags.tags, k, "") != v })
}

data "aws_default_tags" "common_tags" {}
