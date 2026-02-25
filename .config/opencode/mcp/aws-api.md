---
name: aws-api
type: local
command: ["uvx", "awslabs.aws-api-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_REGION
  - AWS_API_MCP_PROFILE_NAME
  - AWS_API_MCP_WORKING_DIR
  - AWS_API_MCP_ALLOW_UNRESTRICTED_LOCAL_FILE_ACCESS
  - READ_OPERATIONS_ONLY
  - REQUIRE_MUTATION_CONSENT
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_SESSION_TOKEN
  - EXPERIMENTAL_AGENT_SCRIPTS
  - AWS_API_MCP_TELEMETRY
env:
  AWS_REGION: "{env:AWS_REGION}"
---

## Description

The AWS API MCP Server enables AI assistants to interact with AWS services and
resources by executing AWS CLI commands. It acts as a bridge between AI assistants
and AWS, allowing creation, inspection, and management of AWS resources across all
available services. It also helps with CLI command selection and provides access to
the latest AWS API features — including services released after the model's knowledge
cutoff date.

## Tools provided

- `call_aws` — Executes AWS CLI commands with validation and proper error handling
- `suggest_aws_commands` — Suggests the 5 most relevant AWS CLI commands for a
  natural language query, including full parameter details for recent commands that
  may not be in the model's training data
- `get_execution_plan` *(experimental, requires `EXPERIMENTAL_AGENT_SCRIPTS=true`)* —
  Provides structured step-by-step guidance for complex AWS tasks via reusable agent
  scripts

## When to use

- Listing, inspecting, or managing AWS resources (EC2, S3, IAM, Lambda, RDS, etc.)
- Running AWS CLI commands without leaving the AI assistant
- Discovering the correct CLI syntax for AWS operations, including recently released APIs
- Automating multi-step AWS workflows (with experimental agent scripts)
- Safe, read-only exploration of an AWS account (use `READ_OPERATIONS_ONLY=true`)

## Caveats

- **Single-user only**: Each server instance must serve one user with their own
  credentials. Not designed for multi-tenant environments.
- **IAM controls are primary**: The `READ_OPERATIONS_ONLY` env var adds a second layer
  but IAM permissions are the authoritative security boundary.
- **File system access**: By default, file operations are restricted to a temp working
  directory (`AWS_API_MCP_WORKING_DIR`). Set `AWS_API_MCP_ALLOW_UNRESTRICTED_LOCAL_FILE_ACCESS`
  to `unrestricted` only if explicitly needed.
- **Prompt injection risk**: Do not connect this server to data sources containing
  untrusted user-generated content (e.g., raw CloudWatch logs).
- **Denylisted operations**: `aws deploy install/uninstall` and `aws emr ssh/sock/get/put`
  are blocked by the server regardless of IAM permissions.
- Some read-only AWS API operations can return sensitive data (credentials, secrets) in
  their output even when using a `ReadOnlyAccess` IAM role.

## Setup

1. **Configure AWS credentials** using one of the standard methods (environment
   variables, `~/.aws/credentials`, IAM role, etc.). See the
   [boto3 credentials guide](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html).

2. **Set `AWS_API_MCP_PROFILE_NAME`** (recommended) to select a specific named profile
   rather than relying on boto3's default credential chain when multiple profiles exist.

3. **Ensure Python 3.10+** and `uv` are installed:
   ```sh
   pip install uv   # or: brew install uv
   ```

4. **Set `AWS_REGION`** in your environment (defaults to `us-east-1` if unset).

No API keys specific to this server are required — it uses your existing AWS credentials.

Add to `~/.config/opencode/opencode.env` (adjust region as needed):
```
AWS_REGION=us-east-1
# AWS_API_MCP_PROFILE_NAME=my-profile
# READ_OPERATIONS_ONLY=true
```

## opencode.jsonc config

```jsonc
"aws-api": {
  "type": "local",
  "command": ["uvx", "awslabs.aws-api-mcp-server@latest"],
  "environment": {
    "AWS_REGION": "{env:AWS_REGION}"
  }
}
```
