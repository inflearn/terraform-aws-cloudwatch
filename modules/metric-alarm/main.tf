resource "aws_cloudwatch_metric_alarm" "this" {
  count = var.create_metric_alarm ? 1 : 0

  alarm_name        = var.alarm_name
  alarm_description = var.alarm_description
  actions_enabled   = var.actions_enabled

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions

  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  threshold           = var.threshold
  unit                = var.unit

  datapoints_to_alarm                   = var.datapoints_to_alarm
  treat_missing_data                    = var.treat_missing_data
  evaluate_low_sample_count_percentiles = var.evaluate_low_sample_count_percentiles

  # conflicts with metric_query
  metric_name        = var.metric_name
  namespace          = var.namespace
  period             = var.period
  statistic          = var.statistic
  extended_statistic = var.extended_statistic

  dimensions = var.dimensions

  # conflicts with metric_name
  dynamic "metric_query" {
    for_each = var.metric_query
    content {
      id          = try(metric_query.value.id)
      account_id  = try(metric_query.value.account_id, null)
      label       = try(metric_query.value.label, null)
      return_data = try(metric_query.value.return_data, null)
      expression  = try(metric_query.value.expression, null)

      dynamic "metric" {
        for_each = try(metric_query.value.metric, [])
        content {
          metric_name = try(metric.value.metric_name)
          namespace   = try(metric.value.namespace)
          period      = try(metric.value.period)
          stat        = try(metric.value.stat)
          unit        = try(metric.value.unit, null)
          dimensions  = try(metric.value.dimensions, null)
        }
      }
    }
  }
  threshold_metric_id = var.threshold_metric_id

  tags = var.tags
}
