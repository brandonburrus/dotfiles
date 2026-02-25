---
name: aws-cloudwatch-applicationsignals
type: local
command: ["uvx", "awslabs.cloudwatch-applicationsignals-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - MCP_CLOUDWATCH_APPLICATION_SIGNALS_LOG_LEVEL
  - AUDITOR_LOG_PATH
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
---

## Description

Provides comprehensive monitoring and observability tools for AWS services via AWS Application Signals. Enables AI assistants to audit service health, analyze performance metrics, track SLO compliance, investigate issues with distributed tracing, and perform root cause analysis with 100% trace visibility via Transaction Search.

## Tools provided

- `audit_services` — Primary tool: comprehensive service health auditing with wildcard discovery, SLO compliance, and root cause analysis
- `audit_slos` — Primary SLO compliance monitoring with breach detection and multi-dimensional root cause analysis
- `audit_service_operations` — Operation-level performance analysis targeting specific API endpoints
- `audit_group_health` — Health assessment for all services in a named group
- `get_group_dependencies` — Map intra-group and cross-group service dependencies
- `get_group_changes` — Track recent deployments across a group
- `list_group_services` — Discover services belonging to a group (wildcard support)
- `list_grouping_attribute_definitions` — List custom grouping attribute definitions
- `list_monitored_services` — Discover all monitored services in the environment
- `get_service_detail` — Service metadata, metrics, and associated log groups
- `list_service_operations` — List recently active operations for a service
- `list_slos` — List all Service Level Objectives with names and ARNs
- `get_slo` — Detailed SLO configuration including metrics, thresholds, and goals
- `query_service_metrics` — CloudWatch metrics for latency, throughput, and error rates
- `search_transaction_spans` — 100% sampled trace data via CloudWatch Logs Insights (OpenTelemetry spans)
- `query_sampled_traces` — X-Ray sampled trace analysis (5% sampling)
- `analyze_canary_failures` — Deep-dive canary failure analysis with artifact inspection and service correlation
- `list_change_events` — Correlate deployments and config changes with service performance issues
- `list_slis` — Legacy SLI status report (use `audit_services` instead)
- `get_enablement_guide` — AI-guided enablement of Application Signals via autonomous code modifications

## When to use

- Investigating service health degradation, SLO breaches, or elevated error/latency rates
- Performing root cause analysis for incidents using traces, logs, metrics, and change events together
- Monitoring SLO compliance and tracking budget burn across multiple services
- Analyzing canary failures and correlating them with backend service errors or deployments
- Discovering which deployments or configuration changes caused a performance regression
- Querying 100% of OpenTelemetry span data for accurate error breakdowns (not just sampled X-Ray)
- Enabling Application Signals on EC2, ECS, Lambda, or EKS services via guided instrumentation

## Caveats

- Application Signals must be enabled in your AWS account and region before use (one-time setup via CloudWatch console)
- `query_sampled_traces` uses X-Ray's 5% sampling — prefer `search_transaction_spans` or `audit_slos` for accuracy
- `list_service_operations` only returns operations invoked within the last 24 hours; empty results do not mean no operations exist
- `search_transaction_spans` queries can return large result sets — always include a `LIMIT` clause

## Setup

1. **Enable Application Signals**: In the AWS Console, go to CloudWatch → Services → "Start discovering your Services" → Enable Application Signals (creates the `AWSServiceRoleForCloudWatchApplicationSignals` service-linked role).
2. **AWS credentials**: Configure `~/.aws/credentials` with a profile that has the required IAM permissions (see below).
3. **Install uv**: `curl -LsSf https://astral.sh/uv/install.sh | sh` then `uv python install 3.10`.
4. **Required IAM permissions**: `application-signals:*` (list/get/batch), `cloudwatch:GetMetricData`, `logs:StartQuery/GetQueryResults`, `xray:GetTraceSummaries/BatchGetTraces`, `synthetics:GetCanary/GetCanaryRuns`, `s3:GetObject/ListBucket`, `iam:GetRole/ListAttachedRolePolicies/GetPolicy/GetPolicyVersion`.

## opencode.jsonc config

```jsonc
"aws-cloudwatch-applicationsignals": {
  "type": "local",
  "command": ["uvx", "awslabs.cloudwatch-applicationsignals-mcp-server@latest"],
  "env": {
    "AWS_PROFILE": "default",
    "AWS_REGION": "us-east-1"
  }
}
```
