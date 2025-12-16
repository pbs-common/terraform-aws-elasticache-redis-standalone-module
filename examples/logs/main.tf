module "redis" {
  source = "../.."

  create_dns = false
  log_delivery_configurations = [
    {
      destination      = "example-cloudwatch-log-group"
      destination_type = "cloudwatch-logs"
      log_format       = "text"
      log_type         = "slow-log"
    },
    {
      destination      = "example-kinesis-firehose-stream"
      destination_type = "kinesis-firehose"
      log_format       = "json"
      log_type         = "engine-log"
    }
  ]

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
  owner        = var.owner
}
