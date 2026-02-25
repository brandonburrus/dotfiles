---
name: aws-aurora-dsql
type: local
command: ["uvx", "awslabs.aurora-dsql-mcp-server@latest", "--cluster_endpoint", "{env:DSQL_CLUSTER_ENDPOINT}", "--region", "{env:AWS_REGION}", "--database_user", "{env:DSQL_DATABASE_USER}"]
requires_env:
  - DSQL_CLUSTER_ENDPOINT
  - AWS_REGION
  - DSQL_DATABASE_USER
optional_env:
  - AWS_PROFILE
  - FASTMCP_LOG_LEVEL
env:
  DSQL_CLUSTER_ENDPOINT: "{env:DSQL_CLUSTER_ENDPOINT}"
  AWS_REGION: "{env:AWS_REGION}"
  DSQL_DATABASE_USER: "{env:DSQL_DATABASE_USER}"
  AWS_PROFILE: "{env:AWS_PROFILE}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

The official AWS Labs Aurora DSQL MCP Server. Connects to an Amazon Aurora DSQL cluster and enables AI assistants to convert natural-language questions into Postgres-compatible SQL queries, execute them, inspect schemas, and search Aurora DSQL documentation — all with read-only safety by default.

## Tools provided

**Database Operations** (require `--cluster_endpoint`, `--database_user`, and `--region`):

- `readonly_query` - Execute a single read-only SQL query against the configured DSQL cluster.
- `transact` - Execute SQL statements in a transaction. In read-only mode (default) all statements are validated to be non-mutating; pass `--allow-writes` at startup to enable DDL/DML.
- `get_schema` - Retrieve table schema information from the connected cluster.

**Documentation & Recommendations:**

- `dsql_search_documentation` - Search Aurora DSQL documentation by phrase. Parameters: `search_phrase` (required), `limit` (optional).
- `dsql_read_documentation` - Read a specific Aurora DSQL documentation page. Parameters: `url` (required), `start_index` (optional), `max_length` (optional).
- `dsql_recommend` - Get Aurora DSQL best-practice recommendations for a given documentation URL. Parameters: `url` (required).

## When to use

- Querying an Aurora DSQL cluster via natural language without writing SQL by hand.
- Inspecting table schemas in a DSQL cluster during development or debugging.
- Searching or reading Aurora DSQL documentation inline while coding.
- Validating read-only access patterns before enabling writes (`--allow-writes`).

## Caveats

- **Mandatory parameters:** `--cluster_endpoint`, `--database_user`, and `--region` must all be supplied; the server will not start without them.
- **Read-only by default:** write operations (INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, etc.) are blocked unless the server is started with `--allow-writes`.
- AWS credentials must grant IAM login permission for the specified `database_user`. See [Using database roles with IAM roles](https://docs.aws.amazon.com/aurora-dsql/latest/userguide/using-database-and-iam-roles.html).
- The server must run locally on the same host as the LLM client (no remote/container deployment via SSE/HTTP).
- Uses `AWS_PROFILE` or defaults to the `default` AWS credentials profile; explicit `--profile` flag is not supported in Docker deployments.
- Knowledge-server requests (documentation tools) default to a 30-second timeout; increase with `--knowledge-timeout` on slow networks.

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Create an Aurora DSQL cluster: https://docs.aws.amazon.com/aurora-dsql/latest/userguide/getting-started.html
4. Configure AWS credentials: `aws configure` or set `AWS_PROFILE`.
5. Set the required environment variables:
   - `DSQL_CLUSTER_ENDPOINT` — full cluster endpoint, e.g. `01abc2ldefg3hijklmnopqurstu.dsql.us-east-1.on.aws`
   - `AWS_REGION` — region of the cluster, e.g. `us-east-1`
   - `DSQL_DATABASE_USER` — database username, e.g. `admin`

## opencode.jsonc config

```jsonc
"aws-aurora-dsql": {
  "type": "local",
  "command": [
    "uvx",
    "awslabs.aurora-dsql-mcp-server@latest",
    "--cluster_endpoint", "<your-dsql-cluster-endpoint>",
    "--region", "us-east-1",
    "--database_user", "admin",
    "--profile", "default"
  ],
  "env": {
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
