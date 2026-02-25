---
name: aws-redshift
type: local
command: ["uvx", "awslabs.redshift-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_REGION
  - AWS_DEFAULT_REGION
  - AWS_PROFILE
  - FASTMCP_LOG_LEVEL
  - LOG_FILE
env:
  AWS_REGION: "{env:AWS_REGION}"
  AWS_DEFAULT_REGION: "{env:AWS_DEFAULT_REGION}"
  AWS_PROFILE: "{env:AWS_PROFILE}"
  FASTMCP_LOG_LEVEL: "{env:FASTMCP_LOG_LEVEL}"
  LOG_FILE: "{env:LOG_FILE}"
---

## Description

MCP server for Amazon Redshift that enables AI assistants to discover, explore, and query Redshift provisioned clusters and serverless workgroups. It provides safe, read-only SQL query execution along with full metadata exploration across databases, schemas, tables, and columns. Supports multi-cluster workflows and cross-cluster data comparisons.

## Tools provided

- `list_clusters` — Discover all available Redshift provisioned clusters and serverless workgroups
- `list_databases` — List all databases in a specified cluster
- `list_schemas` — List all schemas in a specified database
- `list_tables` — List all tables in a specified schema
- `list_columns` — List all columns in a specified table with type and constraint details
- `execute_query` — Execute SQL queries (read-only) against a Redshift cluster with safety protections

## When to use

- Exploring the structure of Redshift clusters, databases, schemas, or tables
- Running ad-hoc SELECT queries against Redshift in a read-only, safe mode
- Comparing data across multiple clusters or provisioned vs. serverless workgroups
- Answering natural-language questions about data stored in Redshift

## Caveats

- Query execution is **read-only** (SELECT); write operations are not supported in the current version
- Requires AWS credentials with appropriate IAM permissions for Redshift Data API and cluster/workgroup access
- AWS region must be configured via `AWS_REGION`, `AWS_DEFAULT_REGION`, or an AWS profile

## Setup

1. Install `uv` from https://docs.astral.sh/uv/
2. Ensure Python 3.10+ is available: `uv python install 3.10`
3. Configure AWS credentials via `aws configure` or environment variables
4. Grant the IAM principal the following permissions:
   - `redshift:DescribeClusters`
   - `redshift-serverless:ListWorkgroups`
   - `redshift-serverless:GetWorkgroup`
   - `redshift-data:ExecuteStatement`
   - `redshift-data:DescribeStatement`
   - `redshift-data:GetStatementResult`
   - `redshift-serverless:GetCredentials`
   - `redshift:GetClusterCredentialsWithIAM`
   - `redshift:GetClusterCredentials`
5. Ensure the database user has `SELECT` on target tables, `USAGE` on schemas, and connection access to databases

## opencode.jsonc config

```jsonc
"aws-redshift": {
  "type": "local",
  "command": ["uvx", "awslabs.redshift-mcp-server@latest"],
  "env": {
    "AWS_PROFILE": "default",
    "AWS_DEFAULT_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "INFO"
  }
}
```
