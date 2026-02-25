---
name: aws-appsync
type: local
command: ["uvx", "awslabs.aws-appsync-mcp-server@latest"]
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

The official AWS AppSync MCP Server. Enables AI assistants to manage and interact with AWS AppSync APIs through natural language. Supports creating and configuring GraphQL APIs, data sources, resolvers, schemas, functions, API keys, caching, channel namespaces, and custom domain names. Runs in read-only mode by default; write operations require the `--allow-write` flag.

## Tools provided

- **create_api** - Creates a new AppSync API with the given name and configuration.
- **create_graphql_api** - Creates a new GraphQL API with configurable authentication type (API_KEY by default).
- **create_api_key** - Generates an API key for authenticating with an AppSync API, with optional description and expiry.
- **create_api_cache** - Configures caching for an AppSync API with TTL, caching behavior, and cache instance type.
- **create_datasource** - Connects an API to a backend service (DynamoDB, Lambda, RDS, Elasticsearch, etc.) with service role and source-specific config.
- **create_function** - Creates a reusable AppSync function for complex business logic, associated with a data source.
- **create_channel_namespace** - Sets up a channel namespace for real-time pub/sub subscriptions with configurable auth modes.
- **create_domain_name** - Configures a custom domain name for an AppSync API using an ACM certificate ARN.
- **create_resolver** - Creates a resolver connecting a GraphQL field to a data source, supporting UNIT and PIPELINE kinds.
- **create_schema** - Creates or updates the GraphQL schema definition for an API.

## When to use

- Building or scaffolding a new AWS AppSync GraphQL API from natural language descriptions.
- Adding data sources (DynamoDB tables, Lambda functions, RDS databases) to an existing AppSync API.
- Creating resolvers that wire GraphQL query/mutation/subscription fields to backend data sources.
- Defining or updating GraphQL schemas for AppSync APIs.
- Setting up real-time subscription channel namespaces.
- Configuring API caching, custom domain names, or API keys.
- Exploring existing AppSync resources in read-only mode before making changes.

## Caveats

- **Read-only by default.** All create/write tools are blocked unless `--allow-write` is explicitly added to the `args` array.
- Requires IAM permissions for AWS AppSync; follow the principle of least privilege.
- Use temporary credentials (STS) or AWS profiles rather than long-lived access keys where possible.
- If enabling write operations, back up existing API configurations and carefully review LLM-generated instructions before execution.
- Not recommended for unattended/automated workflows without thorough human validation.
- `uv` and Python 3.10+ must be installed on the host.
- Be mindful of AWS AppSync service quotas and limits in your account/region.

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Configure AWS credentials: `aws configure` or set `AWS_PROFILE` / `AWS_REGION`.
4. Ensure the IAM identity has appropriate AppSync permissions (e.g., `appsync:*` scoped to required resources).
5. To enable write operations, add `"--allow-write"` to the `args` array in the config below.

## opencode.jsonc config

```jsonc
"aws-appsync": {
  "type": "local",
  "command": ["uvx", "awslabs.aws-appsync-mcp-server@latest"],
  "env": {
    "AWS_PROFILE": "default",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
