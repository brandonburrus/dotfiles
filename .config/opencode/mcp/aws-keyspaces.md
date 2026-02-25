---
name: aws-keyspaces
type: local
command: ["uvx", "awslabs.amazon-keyspaces-mcp-server@latest"]
requires_env:
  - DB_CASSANDRA_USERNAME
  - DB_CASSANDRA_PASSWORD
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - DB_USE_KEYSPACES
  - DB_CASSANDRA_CONTACT_POINTS
  - DB_CASSANDRA_PORT
  - DB_CASSANDRA_LOCAL_DATACENTER
  - DB_KEYSPACES_ENDPOINT
  - DB_KEYSPACES_REGION
  - FASTMCP_LOG_LEVEL
env:
  FASTMCP_LOG_LEVEL: "ERROR"
  DB_USE_KEYSPACES: "true"
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
---

## Description

The official AWS Labs Amazon Keyspaces (for Apache Cassandra) MCP Server. Enables AI assistants to explore database schemas, execute read-only CQL SELECT queries, and analyze query performance against Amazon Keyspaces or any Apache Cassandra cluster that supports password authentication.

## Tools provided

- `listKeyspaces` - Lists all keyspaces in the connected database.
- `listTables` - Lists all tables within a specified keyspace.
- `describeKeyspace` - Returns detailed metadata about a keyspace.
- `describeTable` - Returns detailed schema information (columns, types, partition/clustering keys, indexes) for a table.
- `executeQuery` - Executes a read-only CQL SELECT query and returns results. Write/DDL statements are blocked.
- `analyzeQueryPerformance` - Analyzes a CQL query's performance characteristics and returns optimization suggestions (partition key usage, allow filtering warnings, etc.).

## When to use

- Exploring an Amazon Keyspaces or Apache Cassandra schema through natural language questions.
- Running ad-hoc SELECT queries without writing CQL directly.
- Diagnosing slow queries or getting performance recommendations before executing against production.
- Auditing table structures, partition keys, and clustering columns during a migration or design review.
- Investigating data in a Keyspaces keyspace when debugging application issues.

## Caveats

- **Python 3.10 or 3.11 required** — Python 3.12+ is not fully supported because the Cassandra driver depends on the `asyncore` module that was removed in 3.12.
- **Read-only** — only CQL SELECT queries are permitted; all mutating and DDL statements are rejected.
- **Amazon Keyspaces requires the Starfield TLS certificate** — download `sf-class2-root.crt` from `https://certs.secureserver.net/repository/sf-class2-root.crt` and place it at `~/.keyspaces-mcp/certs/sf-class2-root.crt` before connecting.
- Connection settings can be supplied via environment variables or a `~/.keyspaces-mcp/env` file; env vars take precedence.
- IAM policies for the connecting user should follow least-privilege; the server itself does not perform write operations but cannot prevent the agent from invoking other AWS SDK calls.
- The Cassandra C driver may require native C dependencies (`libev`, `openssl`) for binary installation; if the driver fails to install, try `pip install cassandra-driver --no-binary :all:`.

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10 or 3.11: `uv python install 3.11`
3. Download the Starfield certificate (Amazon Keyspaces only):
   ```bash
   mkdir -p ~/.keyspaces-mcp/certs
   curl -o ~/.keyspaces-mcp/certs/sf-class2-root.crt \
     https://certs.secureserver.net/repository/sf-class2-root.crt
   ```
4. Create `~/.keyspaces-mcp/env` with connection settings:
   ```ini
   DB_USE_KEYSPACES=true
   DB_KEYSPACES_ENDPOINT=cassandra.us-east-1.amazonaws.com
   DB_KEYSPACES_REGION=us-east-1
   DB_CASSANDRA_USERNAME=<your-keyspaces-username>
   DB_CASSANDRA_PASSWORD=<your-keyspaces-password>
   ```
   For Apache Cassandra instead:
   ```ini
   DB_USE_KEYSPACES=false
   DB_CASSANDRA_CONTACT_POINTS=127.0.0.1
   DB_CASSANDRA_PORT=9042
   DB_CASSANDRA_LOCAL_DATACENTER=datacenter1
   DB_CASSANDRA_USERNAME=<cassandra-user>
   DB_CASSANDRA_PASSWORD=<cassandra-password>
   ```
5. Verify access: `uvx awslabs.amazon-keyspaces-mcp-server@latest`

## opencode.jsonc config

```jsonc
"aws-keyspaces": {
  "type": "local",
  "command": ["uvx", "awslabs.amazon-keyspaces-mcp-server@latest"],
  "env": {
    "FASTMCP_LOG_LEVEL": "ERROR",
    "DB_USE_KEYSPACES": "true",
    "AWS_PROFILE": "default",
    "AWS_REGION": "us-east-1"
  }
}
```
