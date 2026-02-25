---
name: aws-s3-tables
type: local
command: ["uvx", "awslabs.s3-tables-mcp-server@latest"]
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

The official AWS S3 Tables MCP Server. Enables AI assistants to interact with S3-based table storage (Apache Iceberg format). Supports table bucket and namespace management, SQL querying, CSV-to-table ingestion, metadata discovery, and maintenance/policy inspection. Runs in read-only mode by default; write operations require the `--allow-write` flag.

## Tools provided

- **Table Bucket Management** - Create and list S3 Table Buckets for organizing tabular data at scale. (No delete or update.)
- **Namespace Management** - Define and list namespaces within table buckets for logical data separation. (No delete or update.)
- **Table Management** - Create, rename, and list individual tables within namespaces. (No delete; rename only.)
- **Maintenance Configuration** - Retrieve maintenance settings for tables and buckets. (Read-only.)
- **Policy Management** - Access resource policies for tables and buckets. (Read-only.)
- **Metadata Management** - View table metadata including schema and storage info. Metadata file can be updated.
- **SQL Query Support** - Run read-only SQL queries against S3 Tables for data analysis. Write operations support only appending (INSERT); UPDATE and DELETE are not available.
- **CSV to Table Conversion** - Automatically create S3 Tables from CSV files uploaded to S3 for streamlined data ingestion.
- **Metadata Discovery** - Discover bucket metadata through the S3 Metadata Table for data governance. (Read-only.)

## When to use

- Querying and analyzing data stored in S3 Tables (Apache Iceberg) without leaving the AI assistant.
- Discovering table schemas, namespaces, and bucket configurations in an AWS account.
- Creating new S3 Table Buckets, namespaces, or tables from natural language instructions.
- Ingesting CSV files from S3 directly into queryable S3 Tables.
- Auditing maintenance settings and resource policies on S3 Tables.
- Running ad-hoc SQL analytics against S3-backed tabular datasets.

## Caveats

- **Read-only by default.** The `--allow-write` flag must be explicitly passed to enable create/append operations.
- **No UPDATE or DELETE via SQL.** Write SQL support is limited to INSERT (append). Destructive SQL is not available.
- **No bucket/namespace/table deletion** through the MCP server regardless of write mode.
- Requires IAM permissions appropriate for the operations used; follow the principle of least privilege.
- If enabling write operations, back up your data and carefully review LLM-generated instructions before execution.
- Not recommended for unattended/automated workflows without thorough validation.
- `uv` and Python 3.10+ must be installed on the host.

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Configure AWS credentials: `aws configure` or set `AWS_PROFILE` / `AWS_REGION`.
4. Ensure the IAM identity has S3 Tables permissions (e.g., `s3tables:*` scoped to required resources).
5. To enable write operations, add `"--allow-write"` to the `args` array in the config below.

## opencode.jsonc config

```jsonc
"aws-s3-tables": {
  "type": "local",
  "command": ["uvx", "awslabs.s3-tables-mcp-server@latest"],
  "env": {
    "AWS_PROFILE": "default",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
