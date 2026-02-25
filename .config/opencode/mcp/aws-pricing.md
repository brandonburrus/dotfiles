---
name: aws-pricing
type: local
command: ["uvx", "awslabs.aws-pricing-mcp-server@latest"]
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

The official AWS Pricing MCP Server. Provides real-time AWS pricing data via the AWS Pricing API, enabling AI assistants to query service costs, compare pricing across regions, and analyze infrastructure cost using natural language. Also supports bulk pricing downloads and IaC project scanning (CDK/Terraform) for automated cost analysis. All pricing API calls are free of charge.

## Tools provided

- **Service catalog exploration** - Discover all AWS services with available pricing information.
- **Pricing attribute discovery** - Identify filterable dimensions (instance types, regions, storage classes, etc.) for any AWS service.
- **Real-time pricing queries** - Fetch current pricing with advanced filtering, multi-option comparisons, and pattern matching.
- **Multi-region price comparison** - Compare pricing across AWS regions in a single query.
- **Bulk pricing data access** - Download complete pricing datasets in CSV/JSON for offline analysis.
- **Cost report generation** - Create detailed cost analysis reports with unit pricing, calculation breakdowns, and usage scenarios.
- **IaC project analysis** - Scan CDK and Terraform projects to automatically identify AWS services and estimate costs.
- **Architecture cost guidance** - Get architecture patterns and cost considerations, especially for Amazon Bedrock services.
- **Cost optimization recommendations** - Receive AWS Well-Architected Framework aligned suggestions for cost reduction.

## When to use

- Estimating costs for new AWS architectures or service selections before deployment.
- Comparing instance types, storage classes, or region pricing to choose the most cost-effective option.
- Generating cost breakdowns for existing or planned infrastructure projects (CDK/Terraform).
- Answering ad hoc pricing questions in plain English without needing to navigate the AWS Pricing console.
- Building cost-aware design recommendations aligned with the Well-Architected Framework.

## Caveats

- **Accuracy not guaranteed**: the AI may not always construct filters correctly or identify the absolute cheapest option — verify critical pricing decisions in the AWS Pricing console.
- **`pricing:*` permissions required**: the IAM role/user must have `pricing:*` granted; no user-specific billing data is accessed.
- **AWS Pricing API region**: `AWS_REGION` controls which regional pricing endpoint is used (for latency), not which service region's prices are returned — prices for any region can be queried regardless.
- `uv` and Python 3.10+ must be installed on the host.

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Configure AWS credentials (`aws configure` or set `AWS_PROFILE` / `AWS_REGION`).
4. Grant the IAM principal `pricing:*` permissions (e.g., attach the `AWSPriceListServiceFullAccess` managed policy or a custom policy allowing `pricing:*`).
5. Add the config block below to `opencode.jsonc`.

## opencode.jsonc config

```jsonc
"aws-pricing": {
  "type": "local",
  "command": ["uvx", "awslabs.aws-pricing-mcp-server@latest"],
  "env": {
    "AWS_PROFILE": "default",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
