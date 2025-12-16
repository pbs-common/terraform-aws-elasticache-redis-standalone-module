# PBS TF ElastiCache Redis Standalone Module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-elasticache-redis-standalone-module?ref=x.y.z
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

Provisions an Elasticache Redis (or Valkey) cluster (with Cluster Mode Disabled).

> ℹ️ Note the confusing terminology around `Cluster Mode`. The `Cluster Mode` setting is a Redis feature that allows data to be sharded among nodes in a cluster, and requires some additional configuration to connect with it correctly. A Redis cluster that does not have `Cluster Mode` enabled is a set of standalone Redis nodes that have a single primary node for reading and writing and replica nodes for reading.

By default, it will provision one writer and one reader node, but that can be adjusted by setting the `nodes` variable to a different value.

This module also assumes that connections are established through a private DNS record created in Route53. This makes it so that replacement of the ElastiCache cluster can be made in a fashion that is transparent to application configurations. This can be adjusted by setting `create_dns` to `false`.

Integrate this module like so:

```hcl
module "redis" {
  source = "github.com/pbs/terraform-aws-elasticache-redis-standalone-module?ref=x.y.z"

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo

  # Optional Parameters
}
```

## Adding This Version of the Module

If this repo is added as a subtree, then the version of the module should be close to the version shown here:

`x.y.z`

Note, however that subtrees can be altered as desired within repositories.

Further documentation on usage can be found [here](./docs).

Below is automatically generated documentation on this Terraform module using [terraform-docs][terraform-docs]

---

[terraform-docs]: https://github.com/terraform-docs/terraform-docs

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.20.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_elasticache_replication_group.replication_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_route53_record.primary_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.reader_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_route53_zone.private_hosted_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnets.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Tag used to group resources according to owner | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Whether any database modifications are applied immediately, or during the next maintenance window. | `bool` | `false` | no |
| <a name="input_at_rest_encryption_enabled"></a> [at\_rest\_encryption\_enabled](#input\_at\_rest\_encryption\_enabled) | Whether to enable encryption at rest. Because there is a performance hit to enabling this feature, the default is false. Consider setting to true if your application can tolerate it. | `bool` | `false` | no |
| <a name="input_auth_token"></a> [auth\_token](#input\_auth\_token) | Password used to access a password protected server. Can be specified only if transit\_encryption\_enabled = true. | `string` | `null` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Specifies whether minor version engine upgrades will be applied automatically to the underlying nodes during the maintenance window. Only supported for engine type "redis" and if the engine version is 6 or higher. | `bool` | `true` | no |
| <a name="input_automatic_failover_enabled"></a> [automatic\_failover\_enabled](#input\_automatic\_failover\_enabled) | Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If null, will be enabled if `nodes` > 1. If true, `nodes` must be greater than 1. | `bool` | `null` | no |
| <a name="input_cname"></a> [cname](#input\_cname) | The value to use for the CNAME record if `create_dns` is true. The primary endpoint will be <cname>.<private\_hosted\_zone>, and the reader endpoint will be <cname>-ro.<private\_hosted\_zone>. If null, the name variable will be used instead. | `string` | `null` | no |
| <a name="input_create_dns"></a> [create\_dns](#input\_create\_dns) | Whether to create DNS records for the primary and reader endpoints. | `bool` | `true` | no |
| <a name="input_data_tiering_enabled"></a> [data\_tiering\_enabled](#input\_data\_tiering\_enabled) | Enables data tiering. Data tiering is only supported for replication groups using the r6gd node type. This parameter must be set to true when using r6gd nodes. | `bool` | `false` | no |
| <a name="input_dns_ttl"></a> [dns\_ttl](#input\_dns\_ttl) | TTL for DNS records. | `number` | `300` | no |
| <a name="input_egress_cidr_blocks"></a> [egress\_cidr\_blocks](#input\_egress\_cidr\_blocks) | List of CIDR blocks to assign to the egress rule of the security group. If null, `egress_security_group_ids` must be used. | `list(string)` | <pre>[<br/>  "10.0.0.0/8"<br/>]</pre> | no |
| <a name="input_egress_source_sg_id"></a> [egress\_source\_sg\_id](#input\_egress\_source\_sg\_id) | List of security group ID to assign to the egress rule of the security group. If null, `egress_cidr_blocks` must be used. | `string` | `null` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The engine to use ('valkey' or 'redis') | `string` | `"redis"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Version number of the cache engine to be used. If not set, defaults to the latest version. See Describe Cache Engine Versions in the AWS Documentation for supported versions. When engine is redis and the version is 6 or higher, the major and minor version can be set, e.g., 6.2, or the minor version can be unspecified which will use the latest version at creation time, e.g., 6.x. Otherwise, specify the full version desired, e.g., 5.0.6. | `string` | `null` | no |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | Name of your final cluster snapshot. If omitted, no final snapshot will be made. | `string` | `null` | no |
| <a name="input_global_replication_group_id"></a> [global\_replication\_group\_id](#input\_global\_replication\_group\_id) | The ID of the global replication group to which this replication group should belong. If this parameter is specified, the replication group is added to the specified global replication group as a secondary replication group; otherwise, the replication group is not part of any global replication group. If global\_replication\_group\_id is set, the num\_node\_groups parameter cannot be set. | `string` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if at\_rest\_encryption\_enabled = true. | `string` | `null` | no |
| <a name="input_log_delivery_configurations"></a> [log\_delivery\_configurations](#input\_log\_delivery\_configurations) | List of log delivery configurations. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster#log-delivery-configuration | <pre>list(object({<br/>    destination      = string<br/>    destination_type = string<br/>    log_format       = string<br/>    log_type         = string<br/>  }))</pre> | `[]` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Specifies the weekly time range for when maintenance on the cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period. Example: sun:05:00-sun:09:00. | `string` | `"mon:07:00-mon:08:00"` | no |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | Whether to enable Multi-AZ. If Multi-AZ is enabled, the value of nodes must be at least 2. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the ElastiCache Redis instance. If null, will default to product. | `string` | `null` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | ElastiCache node type | `string` | `"cache.t3.micro"` | no |
| <a name="input_nodes"></a> [nodes](#input\_nodes) | Number of nodes (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2. Updates will occur before other modifications. Conflicts with num\_node\_groups, the deprecatednumber\_cache\_clusters, or the deprecated cluster\_mode. | `number` | `2` | no |
| <a name="input_notification_topic_arn"></a> [notification\_topic\_arn](#input\_notification\_topic\_arn) | ARN of an SNS topic to send ElastiCache notifications to. Example: arn:aws:sns:us-east-1:012345678999:my\_sns\_topic. | `string` | `null` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Name of the parameter group to be created. | `string` | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | The port number on which each of the cache nodes will accept connections. Cannot be provided with replication\_group\_id. Changing this value will re-create the resource. | `number` | `6379` | no |
| <a name="input_preferred_cache_cluster_azs"></a> [preferred\_cache\_cluster\_azs](#input\_preferred\_cache\_cluster\_azs) | List of availability zones in which to create cluster. | `list(string)` | `null` | no |
| <a name="input_private_hosted_zone"></a> [private\_hosted\_zone](#input\_private\_hosted\_zone) | Private hosted zone to create DNS records in. If null, `create_dns` must be set to false. | `string` | `null` | no |
| <a name="input_replication_group_description"></a> [replication\_group\_description](#input\_replication\_group\_description) | Description of the replication group to be created. If null, one will be generated using the name of the nodes. | `string` | `null` | no |
| <a name="input_replication_group_id"></a> [replication\_group\_id](#input\_replication\_group\_id) | Replication group identifier. This parameter is stored as a lowercase string. If null, the name of the nodes will be used. | `string` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | One or more VPC security groups associated with the nodes. If null, use the one provided by this module. | `list(string)` | `null` | no |
| <a name="input_sg_name"></a> [sg\_name](#input\_sg\_name) | Name of the security group to be created. If null, will use the name of the nodes. | `string` | `null` | no |
| <a name="input_snapshot_arns"></a> [snapshot\_arns](#input\_snapshot\_arns) | Single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. The object name cannot contain any commas. Changing snapshot\_arns forces a new resource. | `list(string)` | `null` | no |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | Number of days for which ElastiCache will retain automatic cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot\_retention\_limit is not supported on cache.t1.micro cache nodes. | `number` | `null` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your nodes. Example: 05:00-09:00 | `string` | `null` | no |
| <a name="input_subnet_data_lookup_filters"></a> [subnet\_data\_lookup\_filters](#input\_subnet\_data\_lookup\_filters) | Values of the `filter` blocks in the `aws_subnets` data source used in this module. If null, one will be guessed using the resolved VPC and a `Name` filter of `*-private-*`. Ignored if `subnets` is populated. | `map(any)` | `null` | no |
| <a name="input_subnet_group_name"></a> [subnet\_group\_name](#input\_subnet\_group\_name) | Name of the subnet group to be used for the cluster. Changing this value will re-create the resource. If null, will use the subnet group created by this module. | `string` | `null` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet IDs to create cluster nodes in. If null, a list will be generated by looking up subnets in the resolved VPC. | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_transit_encryption_enabled"></a> [transit\_encryption\_enabled](#input\_transit\_encryption\_enabled) | Whether to enable encryption at rest. Because there is a performance hit to enabling this feature, the default is false. Consider setting to true if your application can tolerate it. | `bool` | `false` | no |
| <a name="input_use_prefix"></a> [use\_prefix](#input\_use\_prefix) | Whether to use prefixes in the resource names. If false, will use a fully specified name for resources. | `bool` | `true` | no |
| <a name="input_user_group_ids"></a> [user\_group\_ids](#input\_user\_group\_ids) | User Group ID to associate with the replication group. Only a maximum of one (1) user group ID is valid. NOTE: This argument is a set because the AWS specification allows for multiple IDs. However, in practice, AWS only allows a maximum size of one. | `list(string)` | `null` | no |
| <a name="input_vpc_data_lookup_tags"></a> [vpc\_data\_lookup\_tags](#input\_vpc\_data\_lookup\_tags) | Value of the `tags` parameter in the `aws_vpc` data source used in this module. If null, a dynamic lookup based on `environment` will be used. Ignored if `vpc_id` is populated. | `map(string)` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to create the nodes in. If null, one will be guessed based on `vpc_data_lookup_tags`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the ElastiCache replication group |
| <a name="output_engine_version_actual"></a> [engine\_version\_actual](#output\_engine\_version\_actual) | Because ElastiCache pulls the latest minor or patch for a version, this attribute returns the running version of the cache engine. |
| <a name="output_member_clusters"></a> [member\_clusters](#output\_member\_clusters) | Identifiers of all the nodes that are part of this replication group. |
| <a name="output_name"></a> [name](#output\_name) | The name of the ElastiCache replication group |
| <a name="output_primary_endpoint_address"></a> [primary\_endpoint\_address](#output\_primary\_endpoint\_address) | Address of the endpoint for the primary node in the replication group. |
| <a name="output_reader_endpoint_address"></a> [reader\_endpoint\_address](#output\_reader\_endpoint\_address) | Address of the endpoint for the reader node in the replication group. |
| <a name="output_sg_ids"></a> [sg\_ids](#output\_sg\_ids) | The security group ids |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags |
