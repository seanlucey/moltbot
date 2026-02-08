resource "aws_cloudwatch_log_group" "cw_log_group" {
  name = "/ecs/${var.name}"
  retention_in_days = 14
}
