resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/aws/ecs/app-logs"
  retention_in_days = 30
  tags = {
    Environment = "dev"
  }
}

resource "aws_cloudwatch_log_stream" "app_log_stream" {
  name           = "app-log-stream"
  log_group_name = aws_cloudwatch_log_group.app_log_group.name
}
