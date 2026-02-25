---
name: aws-ccapi
type: local
command: ["uvx", "awslabs.ccapi-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - FASTMCP_LOG_LEVEL
  - SECURITY_SCANNING
  - DEFAULT_TAGS
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "ERROR"
  SECURITY_SCANNING: "enabled"
  DEFAULT_TAGS: "enabled"
---

## Description

AWS Cloud Control API (CCAPI) MCP Server enables LLMs to directly create and
manage over 1,100 AWS resources through natural language using AWS Cloud Control
API and IaC Generator, following Infrastructure as Code best practices. Includes
a secure token-based workflow that enforces credential validation, user
explanation, and optional Checkov security scanning before any resource mutation.

## Tools provided

**Core / session tools:**
- `check_environment_variables()` — verifies AWS credentials are configured; returns `environment_token`
- `get_aws_session_info(environment_token)` — returns account ID, region, auth type; returns `credentials_token`
- `get_aws_account_info()` — convenience wrapper for the two above (no params required)
- `generate_infrastructure_code(credentials_token)` — prepares resource properties and a CloudFormation template for scanning; returns `generated_code_token`
- `explain(generated_code_token)` — explains what will be created/modified in human-readable form; returns `explained_token`
- `run_checkov(explained_token)` — runs Checkov security scan on the generated CF template; returns `security_scan_token`

**CRUDL tools:**
- `create_resource(...)` — creates an AWS resource via Cloud Control API
- `get_resource(...)` — reads all properties of a specific resource
- `update_resource(...)` — applies changes to an existing resource (JSON Patch)
- `delete_resource(...)` — deletes a resource (requires double confirmation)
- `list_resources(...)` — enumerates all resources of a given type

**Utility tools:**
- `get_resource_schema_information(...)` — returns the CloudFormation schema for any resource type
- `get_resource_request_status(request_token)` — polls status of a pending create/update/delete
- `create_template(...)` — generates a CloudFormation template from existing resources via IaC Generator

## When to use

- Creating, reading, updating, or deleting any of 1,100+ AWS resources through
  conversation without writing IaC manually
- Listing all resources of a given type in an account/region
- Generating CloudFormation templates from existing live resources (IaC reverse-engineering)
- Looking up the full CloudFormation schema for a resource type to understand all properties
- Checking the status of an in-progress Cloud Control API mutation
- Any task that benefits from the secure explain-before-execute workflow with optional
  Checkov security scanning

## Caveats

- Only covers resources supported by AWS Cloud Control API and IaC Generator;
  see https://docs.aws.amazon.com/cloudcontrolapi/latest/userguide/supported-resources.html
- `create_template` only generates CloudFormation JSON/YAML (not Terraform or CDK directly,
  though an LLM can convert the output)
- Generated templates are intended for importing existing resources into CloudFormation
  stacks and may not always work for net-new deployments in another account/region
- When running alongside other infrastructure MCP servers (CDK, CFN, Terraform), LLMs may
  choose tools from either server; be explicit about which you want used
- Rate limiting may affect bulk operations; some resource types don't support all CRUDL ops
- Requires AWS credentials to be valid and refreshed (especially for SSO profiles)

## Setup

AWS credentials are resolved via boto3's standard chain — no additional secrets are needed
if you already have a working AWS profile or environment variables.

**Option 1 — Named profile (recommended):**
```bash
aws configure --profile my-profile
# or configure SSO:
aws configure sso --profile my-sso-profile
aws sso login --profile my-sso-profile
```
Set `AWS_PROFILE` in `opencode.env` (see below).

**Option 2 — Environment variables:**
Export `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` in your shell or add them
to `opencode.env`. Set `AWS_REGION` if you want a region other than `us-east-1`.

**Required IAM permissions** (minimum):
```json
{
  "Effect": "Allow",
  "Action": [
    "cloudcontrol:ListResources",
    "cloudcontrol:GetResource",
    "cloudcontrol:CreateResource",
    "cloudcontrol:DeleteResource",
    "cloudcontrol:UpdateResource",
    "cloudformation:CreateGeneratedTemplate",
    "cloudformation:DescribeGeneratedTemplate",
    "cloudformation:GetGeneratedTemplate"
  ],
  "Resource": "*"
}
```

**`opencode.env` entries** (add as needed):
```
AWS_PROFILE=my-profile
AWS_REGION=us-east-1
```

## opencode.jsonc config

```jsonc
"aws-ccapi": {
  "type": "local",
  "command": ["uvx", "awslabs.ccapi-mcp-server@latest"],
  "environment": {
    "AWS_PROFILE": "{env:AWS_PROFILE}",
    "AWS_REGION": "{env:AWS_REGION}",
    "FASTMCP_LOG_LEVEL": "ERROR",
    "SECURITY_SCANNING": "enabled",
    "DEFAULT_TAGS": "enabled"
  }
}
```

**Read-only variant** (no mutations allowed):
```jsonc
"aws-ccapi": {
  "type": "local",
  "command": ["uvx", "awslabs.ccapi-mcp-server@latest", "--readonly"],
  "environment": {
    "AWS_PROFILE": "{env:AWS_PROFILE}",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
