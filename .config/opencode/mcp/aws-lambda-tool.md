---
name: aws-lambda-tool
type: local
command: ["uvx", "awslabs.lambda-tool-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - FUNCTION_PREFIX
  - FUNCTION_LIST
  - FUNCTION_TAG_KEY
  - FUNCTION_TAG_VALUE
  - FUNCTION_INPUT_SCHEMA_ARN_TAG_KEY
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FUNCTION_PREFIX: "{env:FUNCTION_PREFIX}"
  FUNCTION_LIST: "{env:FUNCTION_LIST}"
  FUNCTION_TAG_KEY: "{env:FUNCTION_TAG_KEY}"
  FUNCTION_TAG_VALUE: "{env:FUNCTION_TAG_VALUE}"
  FUNCTION_INPUT_SCHEMA_ARN_TAG_KEY: "{env:FUNCTION_INPUT_SCHEMA_ARN_TAG_KEY}"
---

## Description

A Model Context Protocol (MCP) server that acts as a bridge between MCP clients and AWS Lambda functions, allowing AI models to invoke Lambda functions as MCP tools without code changes. Useful for accessing private resources (internal applications, databases, VPC-connected services) without exposing them to the public internet.

## Tools provided

Dynamically exposes AWS Lambda functions as MCP tools. The set of tools is determined at startup by filtering Lambda functions using one or more of:

- **Name prefix** (`FUNCTION_PREFIX`): includes functions whose names start with the prefix
- **Explicit list** (`FUNCTION_LIST`): includes named functions directly
- **Tag filter** (`FUNCTION_TAG_KEY` + `FUNCTION_TAG_VALUE`): further filters by Lambda tag key=value

Each Lambda function becomes one MCP tool. The tool name is the function name; the tool description is the Lambda function's `Description` property. If `FUNCTION_INPUT_SCHEMA_ARN_TAG_KEY` is set, the server fetches formal JSON Schema from EventBridge Schema Registry for input documentation.

## When to use

- Giving an AI model access to internal/private APIs or databases via Lambda without public network exposure
- Delegating tool execution to Lambda functions that interact with other AWS services (using the function's IAM role)
- Wrapping existing Lambda-based business logic as agent tools with no Lambda code changes required
- Enforcing segregation of duties: the model can only invoke Lambda; Lambda handles downstream AWS access

## Caveats

- The Lambda function's `Description` field is critical — it becomes the MCP tool description and should clearly document when and how to use the function, including expected parameters
- If both `FUNCTION_TAG_KEY` and `FUNCTION_TAG_VALUE` are not set together (only one provided), no functions are selected and a warning is shown
- If `FUNCTION_PREFIX`, `FUNCTION_LIST`, and tag filters are all empty/unset, all Lambda functions in the region are exposed as tools — use with caution
- The MCP server needs IAM permission to call `lambda:InvokeFunction` on the target functions
- Credentials must be kept refreshed (especially relevant for Docker deployments using temporary credentials)
- Requires `uv` and Python 3.10+ installed locally

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10: `uv python install 3.10`
3. Ensure the AWS credentials (via profile or environment) have `lambda:InvokeFunction` permission on the target functions
4. Set `FUNCTION_PREFIX`, `FUNCTION_LIST`, and/or tag env vars to control which Lambda functions are exposed
5. (Optional) Tag Lambda functions with an EventBridge Schema Registry ARN under a consistent tag key, then set `FUNCTION_INPUT_SCHEMA_ARN_TAG_KEY` for formal input schema support

## opencode.jsonc config

```jsonc
"aws-lambda-tool": {
  "command": "uvx",
  "args": ["awslabs.lambda-tool-mcp-server@latest"],
  "env": {
    "AWS_PROFILE": "your-aws-profile",
    "AWS_REGION": "us-east-1",
    "FUNCTION_PREFIX": "your-function-prefix",
    "FUNCTION_LIST": "your-first-function, your-second-function",
    "FUNCTION_TAG_KEY": "your-tag-key",
    "FUNCTION_TAG_VALUE": "your-tag-value",
    "FUNCTION_INPUT_SCHEMA_ARN_TAG_KEY": "your-function-tag-for-input-schema"
  }
}
```
