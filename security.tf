resource "aws_security_group" "sg" {
  description = local.sg_description

  name        = local.sg_name
  name_prefix = local.sg_name_prefix
  vpc_id      = local.vpc_id

  tags = local.tags
}

resource "aws_security_group_rule" "egress" {
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = var.port
  to_port                  = var.port
  source_security_group_id = var.egress_source_sg_id
  cidr_blocks              = var.egress_cidr_blocks
  security_group_id        = aws_security_group.sg.id
}
