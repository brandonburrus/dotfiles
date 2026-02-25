---
name: aws-billing-cost-management
type: local
command: ["uvx", "awslabs.billing-cost-management-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_SESSION_TOKEN
  - FASTMCP_LOG_LEVEL
  - STORAGE_LENS_MANIFEST_LOCATION
  - STORAGE_LENS_OUTPUT_LOCATION
env:
  AWS_REGION: "{env:AWS_REGION}"
  AWS_PROFILE: "{env:AWS_PROFILE}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

MCP server for AWS Billing and Cost Management. Enables AI assistants to analyze AWS
costs and usage, monitor budgets, detect cost anomalies, get right-sizing and savings
recommendations, query S3 Storage Lens metrics, and access the Pricing Calculator. All
API calls use the caller's AWS credentials and are subject to AWS service limits.

## Tools provided

**Cost Explorer**
- **get_cost_and_usage** — Query historical costs and usage with flexible time ranges, grouping, and filtering
- **get_cost_and_usage_with_resources** — Same as above but includes resource-level detail
- **get_cost_forecast** — Forecast future costs based on historical patterns
- **get_usage_forecast** — Forecast future usage metrics
- **get_cost_and_usage_comparisons** — Compare cost and usage between two time periods
- **get_cost_comparison_drivers** — Identify key factors driving cost changes between periods
- **get_anomalies** — Detect unusual spending patterns and surface root causes
- **get_dimension_values** — List valid dimension values for filtering (e.g. service, region, account)
- **get_tags** — Retrieve cost allocation tag keys and values
- **get_cost_categories** — List cost category definitions

**Reserved Instances & Savings Plans**
- **get_reservation_purchase_recommendation** — Get RI purchase recommendations based on usage
- **get_reservation_coverage** — Analyze what percentage of usage is covered by RIs
- **get_reservation_utilization** — Check how effectively existing RIs are being used
- **get_savings_plans_purchase_recommendation** — Get personalized Savings Plans recommendations
- **get_savings_plans_utilization** — Monitor Savings Plans utilization rates
- **get_savings_plans_coverage** — Analyze Savings Plans coverage across usage
- **get_savings_plans_details** — Retrieve detailed Savings Plans utilization data

**Budgets**
- **describe_budgets** — List budgets and their current status vs. actual and forecasted spend

**Free Tier**
- **get_free_tier_usage** — Monitor Free Tier usage to avoid unexpected charges

**Pricing**
- **get_service_codes** — List AWS service codes for pricing lookups
- **get_service_attributes** — Retrieve attributes available for a service
- **get_attribute_values** — Get valid values for a pricing attribute
- **get_products** — Fetch pricing for specific products/configurations

**Cost Optimization Hub**
- **list_recommendations** — List cost-saving opportunities across your AWS environment
- **list_recommendation_summaries** — Get a high-level summary of savings opportunities
- **get_recommendation** — Retrieve detail for a specific optimization recommendation

**Compute Optimizer**
- **get_ec2_instance_recommendations** — Right-sizing suggestions for EC2 instances
- **get_ebs_volume_recommendations** — Right-sizing suggestions for EBS volumes
- **get_lambda_function_recommendations** — Right-sizing suggestions for Lambda functions
- **get_ecs_service_recommendations** — Right-sizing suggestions for ECS services
- **get_rds_database_recommendations** — Right-sizing suggestions for RDS databases
- **get_auto_scaling_group_recommendations** — Recommendations for Auto Scaling Groups
- **get_idle_recommendations** — Identify idle/underutilized resources
- **get_enrollment_status** — Check Compute Optimizer enrollment status

**Pricing Calculator**
- **get_workload_estimate** — Retrieve a workload estimate from the BCM Pricing Calculator
- **list_workload_estimates** — List all workload estimates
- **list_workload_estimate_usage** — View usage line items within a workload estimate
- **get-preferences** — Get Pricing Calculator preferences

**S3 Storage Lens**
- **storage_lens_run_query** — Run SQL queries against Storage Lens metrics via Athena for storage cost analysis and optimization insights

## When to use

- Analyzing historical or forecasted AWS costs by service, region, account, or tag
- Comparing month-over-month or period-over-period spend and identifying cost drivers
- Detecting and investigating unusual spending anomalies
- Checking budget status and remaining spend headroom
- Getting right-sizing recommendations for EC2, Lambda, RDS, ECS, or EBS resources
- Identifying idle or underutilized resources for cleanup
- Evaluating Reserved Instance or Savings Plans purchase opportunities
- Querying current AWS service pricing for estimate or comparison purposes
- Analyzing S3 storage costs by bucket, storage class, or region using Storage Lens
- Reviewing Pricing Calculator workload estimates

## Caveats

- **Cost Explorer API has a fee** — Each API request to Cost Explorer costs $0.01; heavy usage can add up.
- **Cost Explorer is only available in `us-east-1`** — set `AWS_REGION=us-east-1` for cost data calls.
- **Compute Optimizer enrollment required** — The account must be enrolled in Compute Optimizer before recommendations are available.
- **Storage Lens requires additional setup** — `STORAGE_LENS_MANIFEST_LOCATION` must point to a valid S3 URI with Storage Lens export data; Athena permissions are required.
- Broad IAM permissions are needed — see the full permission list covering `ce:*`, `budgets:ViewBudget`, `compute-optimizer:*`, `cost-optimization-hub:*`, `freetier:GetFreeTierUsage`, `pricing:*`, `bcm-pricing-calculator:*`, and Athena/S3 permissions for Storage Lens.
- Multi-account analysis requires appropriate cross-account access or use of the management/payer account.

## Setup

Prerequisites (install once):

```sh
# Install uv (Python package runner)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Python 3.10+
uv python install 3.10
```

Configure AWS credentials in `~/.aws/credentials` or via environment variables.
Optionally add to `~/.config/opencode/opencode.env`:

```
AWS_PROFILE=your-profile-name
AWS_REGION=us-east-1
FASTMCP_LOG_LEVEL=ERROR
```

For S3 Storage Lens queries, also set:

```
STORAGE_LENS_MANIFEST_LOCATION=s3://your-bucket/storage-lens-data/
STORAGE_LENS_OUTPUT_LOCATION=s3://your-bucket/athena-results/
```

## opencode.jsonc config

```jsonc
"aws-billing-cost-management": {
  "type": "local",
  "command": [
    "uvx",
    "awslabs.billing-cost-management-mcp-server@latest"
  ],
  "environment": {
    "AWS_REGION": "us-east-1",
    "AWS_PROFILE": "default",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
