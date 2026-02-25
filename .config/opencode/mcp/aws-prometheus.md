---
name: aws-prometheus
type: local
command: ["uvx", "awslabs.prometheus-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - FASTMCP_LOG_LEVEL
env:
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

MCP server for querying AWS Managed Prometheus (Amazon Managed Service for Prometheus / APS).
Executes instant and range PromQL queries, lists available metrics, discovers workspaces, and
retrieves server configuration — all with AWS SigV4 authentication and automatic retries with
exponential backoff.

## Tools provided

- **GetAvailableWorkspaces** — List all APS workspaces in a region; returns workspace IDs, aliases, and status
- **ExecuteQuery** — Run an instant PromQL query against a specific workspace; accepts optional evaluation timestamp
- **ExecuteRangeQuery** — Run a PromQL query over a time range with configurable start, end, and step interval
- **ListMetrics** — Retrieve all metric names available in a workspace, returned as a sorted list
- **GetServerInfo** — Return the configured URL, region, profile, and service info for a workspace

## When to use

- Investigating application or infrastructure health via PromQL against AWS Managed Prometheus
- Querying CPU, memory, or custom metrics from EKS, EC2, or other AWS workloads instrumented with Prometheus
- Building alert triage workflows that need to pull live or historical metric data
- Comparing metric trends over time using range queries (e.g., `rate(...)` over a window)
- Discovering what metrics exist in a workspace before writing dashboards or alerts

## Caveats

- Requires an existing AWS Managed Prometheus (APS) workspace; this server does not create workspaces
- AWS credentials must be configured with `aps:QueryMetrics` and `aps:GetLabels` permissions (at minimum)
- The `--url` and `--region` args (or `AWS_REGION` env var) must match the target workspace's region
- Network access to the APS endpoint is required; private workspaces may need VPC/VPN connectivity
- Python 3.10+ and `uv`/`uvx` must be available on the host

## Setup

Prerequisites (install once):

```sh
# Install uv (Python package runner)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Python 3.10 via uv
uv python install 3.10
```

Configure AWS credentials (standard AWS CLI profile or environment variables):

```sh
aws configure          # sets up ~/.aws/credentials and ~/.aws/config
# or export AWS_PROFILE=<profile-name>
```

The workspace URL follows the pattern:
`https://aps-workspaces.<region>.amazonaws.com/workspaces/<workspace-id>`

Use `GetAvailableWorkspaces` to discover workspace IDs programmatically; no manual URL
lookup is required if the correct region is set.

## opencode.jsonc config

```jsonc
"aws-prometheus": {
  "type": "local",
  "command": [
    "uvx",
    "awslabs.prometheus-mcp-server@latest"
  ],
  "environment": {
    "AWS_PROFILE": "default",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
