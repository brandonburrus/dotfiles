---
name: aws-cloudtrail
type: local
command: ["uvx", "awslabs.cloudtrail-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_SESSION_TOKEN
  - FASTMCP_LOG_LEVEL
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

MCP server for AWS CloudTrail that enables AI agents to query AWS account activity for
security investigations, compliance auditing, and operational troubleshooting. Provides
access to CloudTrail event history (last 90 days of management events) and CloudTrail
Lake for advanced SQL-based analytics across API call history.

## Tools provided

**CloudTrail Events**
- **lookup_events** — Look up CloudTrail events by username, event name, resource name, or other attributes; covers the last 90 days of management events with pagination support

**CloudTrail Lake Analytics**
- **lake_query** — Execute Trino-compatible SQL queries against CloudTrail Lake for complex filtering, aggregation, and advanced security analysis
- **list_event_data_stores** — List available CloudTrail Lake Event Data Stores with their capabilities and event selectors
- **get_query_status** — Get the status of a running or completed CloudTrail Lake query
- **get_query_results** — Retrieve results of a completed CloudTrail Lake query with pagination support for large result sets

## When to use

- Investigating suspicious API activity or potential security incidents in an AWS account
- Auditing user or role activity (who did what, when, and from where)
- Tracking specific API calls and their patterns for compliance purposes
- Running advanced SQL analytics against CloudTrail Lake for complex event correlation
- Listing available CloudTrail Lake Event Data Stores to understand available data sources

## Caveats

- CloudTrail Event History only covers the **last 90 days** of management events; older data requires CloudTrail Lake.
- **CloudTrail Lake must be separately enabled** — the `lake_query`, `list_event_data_stores`, `get_query_status`, and `get_query_results` tools require a configured Event Data Store.
- Required IAM permissions: `cloudtrail:LookupEvents`, `cloudtrail:ListEventDataStores`, `cloudtrail:GetEventDataStore`, `cloudtrail:StartQuery`, `cloudtrail:DescribeQuery`, `cloudtrail:GetQueryResults`.
- This server must run **locally on the same host** as your LLM client.

## Setup

Prerequisites (install once):

```sh
# Install uv (Python package runner)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Python 3.10+
uv python install 3.10
```

Configure AWS credentials with `aws configure` or via environment variables.
Optionally add to `~/.config/opencode/opencode.env`:

```
AWS_PROFILE=your-profile-name
FASTMCP_LOG_LEVEL=ERROR
```

## opencode.jsonc config

```jsonc
"aws-cloudtrail": {
  "type": "local",
  "command": ["uvx", "awslabs.cloudtrail-mcp-server@latest"],
  "environment": {
    "AWS_PROFILE": "default",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
