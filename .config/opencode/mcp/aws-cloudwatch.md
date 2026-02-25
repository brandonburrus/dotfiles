---
name: aws-cloudwatch
type: local
command: ["uvx", "awslabs.cloudwatch-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - FASTMCP_LOG_LEVEL
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "{env:FASTMCP_LOG_LEVEL}"
---

## Description

The CloudWatch MCP Server enables AI-powered root cause analysis and observability workflows by providing direct access to CloudWatch metrics, alarms, and logs. It consolidates CloudWatch API access into task-oriented tools that eliminate custom integrations and reduce context switching during incident troubleshooting.

## Tools provided

**Metrics**
- `get_metric_data` - Retrieve CloudWatch metric data for any namespace, dimension, and statistic
- `get_metric_metadata` - Get comprehensive metadata about a specific CloudWatch metric
- `get_recommended_metric_alarms` - Get best-practice alarm recommendations with trend and statistical analysis
- `analyze_metric` - Analyze metric data for trend, seasonality, and statistical properties

**Alarms**
- `get_active_alarms` - List currently active CloudWatch alarms across the account
- `get_alarm_history` - Retrieve historical state changes and patterns for an alarm

**Logs**
- `describe_log_groups` - Find metadata about CloudWatch log groups
- `analyze_log_group` - Analyze logs for anomalies, message patterns, and error patterns
- `execute_log_insights_query` - Execute a CloudWatch Logs Insights query and return a query ID
- `get_logs_insight_query_results` - Retrieve results of a completed Logs Insights query by ID
- `cancel_logs_insight_query` - Cancel an in-progress Logs Insights query

## When to use

- Troubleshooting triggered alarms and identifying root causes
- Analyzing log groups for errors, anomalies, or patterns in a time window
- Understanding what a CloudWatch metric measures and how it is calculated
- Getting alarm configuration recommendations (thresholds, evaluation periods) for a metric
- Running ad-hoc Logs Insights queries during incident investigation

## Caveats

- Must be run locally on the same host as the LLM client
- Requires AWS credentials configured via `aws configure` or environment variables
- Required IAM permissions: `cloudwatch:DescribeAlarms`, `cloudwatch:DescribeAlarmHistory`, `cloudwatch:GetMetricData`, `cloudwatch:ListMetrics`, `logs:DescribeLogGroups`, `logs:DescribeQueryDefinitions`, `logs:ListLogAnomalyDetectors`, `logs:ListAnomalies`, `logs:StartQuery`, `logs:GetQueryResults`, `logs:StopQuery`

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Configure AWS credentials: `aws configure` (or set `AWS_PROFILE` / `AWS_REGION` env vars)
4. Add the MCP server config to `opencode.jsonc` (see below)

## opencode.jsonc config

```jsonc
"aws-cloudwatch": {
  "type": "local",
  "command": ["uvx", "awslabs.cloudwatch-mcp-server@latest"],
  "env": {
    "AWS_PROFILE": "<your-aws-profile>",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
