---
name: aws-cost-explorer
type: local
command: ["uvx", "awslabs.cost-explorer-mcp-server@latest"]
requires_env:
  - AWS_REGION
optional_env:
  - AWS_PROFILE
  - FASTMCP_LOG_LEVEL
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

The official AWS Cost Explorer MCP Server. Analyzes actual AWS spending and usage data via the AWS Cost Explorer API, enabling AI assistants to break down costs by service/region/tag, compare costs between time periods, identify cost-change drivers, and generate forecasts — all through natural language queries.

**Note:** Each API call costs $0.01. See [AWS Cost Explorer Pricing](https://aws.amazon.com/aws-cost-management/aws-cost-explorer/pricing/).

## Tools provided

- **`get_today_date`** - Returns the current date to correctly anchor relative queries like "last month".
- **`get_dimension_values`** - Lists available values for a Cost Explorer dimension (e.g., SERVICE, REGION, INSTANCE_TYPE).
- **`get_tag_values`** - Lists available values for a specific resource tag key.
- **`get_cost_and_usage`** - Retrieves historical cost and usage data with filtering, grouping, and granularity options.
- **`get_cost_and_usage_comparisons`** - Compares costs between two time periods to surface changes and trends.
- **`get_cost_comparison_drivers`** - Identifies the top 10 drivers of cost change between two periods (usage type shifts, discount changes, infrastructure changes).
- **`get_cost_forecast`** - Generates future cost predictions with 80% or 95% confidence intervals at daily or monthly granularity.

## When to use

- Breaking down AWS bills by service, region, or tag for a specific time period.
- Investigating why an AWS bill increased or decreased compared to a previous period.
- Pinpointing the specific usage types or resource changes that drove a cost spike.
- Forecasting future AWS spending based on historical patterns for budgeting.
- Answering ad hoc cost questions in plain English without navigating the AWS Cost Management console.

## Caveats

- **API charges apply**: every tool call that hits Cost Explorer costs $0.01 per request; complex queries or large date ranges may generate multiple requests.
- **Read-only billing data**: no changes are made to AWS resources — only cost and usage data is queried.
- **IAM permissions required**: the IAM role/user must have `ce:GetCostAndUsage`, `ce:GetDimensionValues`, `ce:GetTags`, `ce:GetCostForecast`, `ce:GetCostAndUsageComparisons`, and `ce:GetCostComparisonDrivers`.
- **Cost Comparison feature**: `get_cost_and_usage_comparisons` and `get_cost_comparison_drivers` use a newer AWS Cost Explorer feature — confirm it is available in your account/region.
- `uv` and Python 3.10+ must be installed on the host.

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Configure AWS credentials (`aws configure` or set `AWS_PROFILE` / `AWS_REGION`).
4. Attach an IAM policy granting the following actions to the IAM principal:
   - `ce:GetCostAndUsage`
   - `ce:GetDimensionValues`
   - `ce:GetTags`
   - `ce:GetCostForecast`
   - `ce:GetCostAndUsageComparisons`
   - `ce:GetCostComparisonDrivers`
5. Add the config block below to `opencode.jsonc`.

## opencode.jsonc config

```jsonc
"aws-cost-explorer": {
  "type": "local",
  "command": ["uvx", "awslabs.cost-explorer-mcp-server@latest"],
  "env": {
    "AWS_PROFILE": "default",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
