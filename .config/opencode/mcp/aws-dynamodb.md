---
name: aws-dynamodb
type: local
command: ["uvx", "awslabs.dynamodb-mcp-server@latest"]
requires_env:
  - AWS_REGION
optional_env:
  - AWS_PROFILE
  - DDB_MCP_READONLY
  - FASTMCP_LOG_LEVEL
  - MYSQL_CLUSTER_ARN
  - MYSQL_SECRET_ARN
  - MYSQL_DATABASE
  - MYSQL_HOSTNAME
  - MYSQL_PORT
  - MYSQL_MAX_QUERY_RESULTS
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

The official AWS DynamoDB MCP Server. Provides expert DynamoDB data modeling guidance, model validation against DynamoDB Local, source database analysis for migrations, schema conversion, cost/performance analysis, and type-safe Python data access layer code generation.

## Tools provided

- `dynamodb_data_modeling` - Loads the full DynamoDB Data Modeling Expert prompt; guides requirements gathering, access pattern analysis, and schema design with enterprise-level patterns and cost optimization.
- `dynamodb_data_model_validation` - Spins up DynamoDB Local (Docker/Podman/Finch/Java), deploys the data model from `dynamodb_data_model.json`, runs all access patterns, and saves results to `dynamodb_model_validation.json`.
- `source_db_analyzer` - Analyzes existing MySQL/PostgreSQL/SQL Server databases (via RDS Data API or direct connection) to extract schema and access patterns for migration planning.
- `generate_resources` - Generates CDK app code to deploy DynamoDB tables from `dynamodb_data_model.json`.
- `dynamodb_data_model_schema_converter` - Converts `dynamodb_data_model.md` into a structured `schema.json` (tables, indexes, entities, fields, access patterns). Validates automatically with up to 8 iterations.
- `dynamodb_data_model_schema_validator` - Validates `schema.json` for code generation compatibility: field types, GSI mappings, pattern IDs, and operation enums.
- `generate_data_access_layer` - Generates type-safe Python code (Pydantic entities + boto3 repositories) from `schema.json`.
- `compute_performances_and_costs` - Calculates RCU/WCU and estimated monthly costs from access patterns; appends a cost report to `dynamodb_data_model.md`.

## When to use

- Designing a new DynamoDB schema from scratch via natural language conversation.
- Migrating from a relational database (MySQL, PostgreSQL, SQL Server) to DynamoDB.
- Validating an existing DynamoDB data model against real access patterns using DynamoDB Local.
- Estimating DynamoDB costs before provisioning.
- Generating a CDK deployment app or a Python data access layer from a data model.

## Caveats

- **Data model validation** requires a container runtime (Docker, Podman, Finch, nerdctl) or Java JRE 17+ in `PATH`/`JAVA_HOME`.
- **Source DB analysis (managed mode)** requires AWS credentials with RDS Data API and Secrets Manager permissions and a running RDS instance.
- Best modeling results are achieved with reasoning-capable models (Claude Sonnet 4/4.5, OpenAI o3, Gemini 2.5).
- `DDB_MCP_READONLY=true` is recommended when only design/analysis tools are needed and no live DynamoDB writes are intended.
- Schema file paths must be within the current working directory; path traversal is blocked for security.

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Configure AWS credentials (`aws configure` or set `AWS_PROFILE`/`AWS_REGION`).
4. For validation: ensure Docker, Podman, Finch, nerdctl, or Java 17+ is available.
5. For MySQL source analysis: set the relevant `MYSQL_*` env vars (see optional_env above).

## opencode.jsonc config

```jsonc
"aws-dynamodb": {
  "type": "local",
  "command": ["uvx", "awslabs.dynamodb-mcp-server@latest"],
  "env": {
    "AWS_PROFILE": "default",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
