---
name: aws-aurora-mysql
type: local
command: ["uvx", "awslabs.mysql-mcp-server@latest"]
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

An AWS Labs MCP server for Amazon Aurora MySQL. Translates natural language into MySQL-compatible SQL queries and executes them against a configured Aurora MySQL database via the AWS RDS Data API or a direct MySQL connection.

## Tools provided

- **Natural language to SQL**: Converts human-readable questions and commands into MySQL-compatible SQL and executes them against the connected Aurora MySQL (or RDS MySQL / RDS MariaDB) database.

## When to use

- Querying or exploring Aurora MySQL, RDS MySQL, or RDS MariaDB databases using natural language.
- Running ad-hoc SQL against Aurora MySQL databases without writing SQL manually.
- Integrating Aurora MySQL data into agentic workflows where you want the LLM to reason over relational data.

## Caveats

- Must run locally on the same host as your LLM client (not a remote MCP server).
- Requires Docker runtime if using the Docker-based installation.
- Write queries are disabled by default; pass `--readonly False` to enable INSERT/UPDATE/DELETE/DDL.
- **RDS Data API method** (`--resource_arn`) requires the Aurora cluster to have the RDS Data API enabled and the IAM principal to have `rds-data:*` and `secretsmanager:GetSecretValue` permissions.
- **Direct connection method** (`--hostname`) uses `asyncmy` and requires network access from the MCP server host to the MySQL endpoint (VPC / security-group rules may apply).
- The `--port` parameter is optional and defaults to 3306.
- AWS credentials remain on your local machine and are used only to authenticate with AWS services.

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10: `uv python install 3.10`
3. Configure AWS credentials (`aws configure` or environment variables).
4. Store your MySQL username/password in AWS Secrets Manager.
5. Enable the RDS Data API on your Aurora MySQL cluster (required for Option 1 only): https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/data-api.html
6. Add the config block below to your `opencode.jsonc`, choosing the connection method that fits your setup.

### Connection methods

| Method | Arg | Description |
|---|---|---|
| RDS Data API | `--resource_arn` | Uses AWS RDS Data API; no direct network path to DB required |
| Direct MySQL | `--hostname` | Uses asyncmy; works with Aurora MySQL, RDS MySQL, RDS MariaDB, self-hosted MySQL/MariaDB |

## opencode.jsonc config

```jsonc
"aws-aurora-mysql": {
  "type": "local",
  "command": "uvx",
  "args": [
    "awslabs.mysql-mcp-server@latest",
    // Option 1 – RDS Data API (Aurora MySQL only, Data API must be enabled):
    "--resource_arn", "<your-aurora-cluster-arn>",
    // Option 2 – Direct connection (Aurora MySQL, RDS MySQL, RDS MariaDB):
    // "--hostname", "<your-db-hostname>",
    "--secret_arn", "<your-secrets-manager-secret-arn>",
    "--database", "<your-database-name>",
    "--region", "us-east-1",
    "--readonly", "True"
    // Set "--readonly", "False" to allow write queries
  ],
  "env": {
    "AWS_PROFILE": "${AWS_PROFILE}",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
