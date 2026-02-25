---
name: aws-aurora-postgresql
type: local
command: ["uvx", "awslabs.postgres-mcp-server@latest"]
requires_env:
  - AWS_REGION
optional_env:
  - AWS_PROFILE
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - FASTMCP_LOG_LEVEL
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

An AWS Labs MCP server for Amazon Aurora PostgreSQL (and Amazon RDS for PostgreSQL). Translates natural language into Postgres-compatible SQL queries and executes them against a configured Aurora PostgreSQL or RDS PostgreSQL database. Also supports Aurora PostgreSQL cluster creation via LLM prompts.

## Tools provided

- **Natural language to SQL**: Converts human-readable questions and commands into Postgres-compatible SQL and executes them against the connected database.
- **Cluster creation**: Creates new Aurora PostgreSQL clusters on demand via LLM prompt (e.g., "Create an Aurora PostgreSQL cluster named 'mycluster' in us-west-2 region").
- **Multi-endpoint connection management**: Connects to multiple database endpoints using different connection methods (pgwire, pgwire_iam, rdsapi) via LLM prompts.

## When to use

- Querying or exploring Aurora PostgreSQL or RDS PostgreSQL databases using natural language.
- Running ad-hoc SQL against Aurora databases without writing SQL manually.
- Provisioning new Aurora PostgreSQL clusters from your LLM client.
- Integrating Aurora PostgreSQL data into agentic workflows.

## Caveats

- Must run locally on the same host as your LLM client (not a remote MCP server).
- Requires Docker runtime installed if using the Docker-based installation.
- Write queries are disabled by default; pass `--allow_write_query` to enable them.
- `rdsapi` and `pgwire_iam` connection methods are only supported for Aurora PostgreSQL (APG), not RDS PostgreSQL (RPG).
- `rdsapi` requires the RDS Data API to be enabled on the Aurora cluster and appropriate IAM permissions.
- `pgwire` / `pgwire_iam` require VPC security groups to allow inbound connections from the MCP server host.
- AWS credentials stay on your local machine and are used only to authenticate with AWS services.

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10: `uv python install 3.10`
3. Configure AWS credentials (`aws configure` or environment variables).
4. Ensure the AWS IAM principal has permissions for RDS Data API and/or Secrets Manager as needed.
5. Add the config block below to your `opencode.jsonc`.

### Connection methods

| Method       | Description                                              | Supported DB types |
|--------------|----------------------------------------------------------|--------------------|
| `pgwire`     | Direct PostgreSQL wire protocol connection               | APG, RPG           |
| `pgwire_iam` | Same as pgwire but with IAM authentication               | APG only           |
| `rdsapi`     | RDS Data API (no direct DB network access required)      | APG only           |

Invoke connections via LLM prompts, for example:
> Connect to database named postgres in Aurora PostgreSQL cluster 'my-cluster' with database_type as APG, using rdsapi as connection method in us-west-2 region

## opencode.jsonc config

```jsonc
"aws-aurora-postgresql": {
  "type": "local",
  "command": "uvx",
  "args": [
    "awslabs.postgres-mcp-server@latest"
    // Add "--allow_write_query" to enable INSERT/UPDATE/DELETE
  ],
  "env": {
    "AWS_PROFILE": "${AWS_PROFILE}",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
