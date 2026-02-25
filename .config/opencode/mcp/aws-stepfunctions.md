---
name: aws-stepfunctions
type: local
command: ["uvx", "awslabs.stepfunctions-tool-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - STATE_MACHINE_PREFIX
  - STATE_MACHINE_LIST
  - STATE_MACHINE_TAG_KEY
  - STATE_MACHINE_TAG_VALUE
  - STATE_MACHINE_INPUT_SCHEMA_ARN_TAG_KEY
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  STATE_MACHINE_PREFIX: "{env:STATE_MACHINE_PREFIX}"
  STATE_MACHINE_LIST: "{env:STATE_MACHINE_LIST}"
  STATE_MACHINE_TAG_KEY: "{env:STATE_MACHINE_TAG_KEY}"
  STATE_MACHINE_TAG_VALUE: "{env:STATE_MACHINE_TAG_VALUE}"
  STATE_MACHINE_INPUT_SCHEMA_ARN_TAG_KEY: "{env:STATE_MACHINE_INPUT_SCHEMA_ARN_TAG_KEY}"
---

## Description

A Model Context Protocol (MCP) server that acts as a bridge between MCP clients and AWS Step Functions state machines, allowing AI models to invoke state machines as MCP tools without any modifications to their definitions. Supports both Standard and Express workflows, integrates with EventBridge Schema Registry for input validation, and enforces IAM-based security boundaries so models never have direct access to downstream AWS services.

## Tools provided

Dynamically exposes AWS Step Functions state machines as MCP tools. The set of tools is determined at startup by filtering state machines using one or more of:

- **Name prefix** (`STATE_MACHINE_PREFIX`): includes state machines whose names start with the prefix
- **Explicit list** (`STATE_MACHINE_LIST`): includes named state machines directly
- **Tag filter** (`STATE_MACHINE_TAG_KEY` + `STATE_MACHINE_TAG_VALUE`): further filters by state machine tag key=value

Each state machine becomes one MCP tool. Tool documentation is built from three sources combined:

1. The state machine's `Description` property (primary tool description)
2. The `Comment` field in the state machine's ASL definition (workflow context)
3. A JSON Schema fetched from EventBridge Schema Registry if `STATE_MACHINE_INPUT_SCHEMA_ARN_TAG_KEY` is set and the state machine is tagged with a schema ARN

## When to use

- Giving an AI model access to complex, multi-step business processes that coordinate multiple AWS services via existing Step Functions workflows
- Delegating tool execution to state machines that handle downstream AWS service interactions using their own IAM roles (segregation of duties)
- Wrapping existing Step Functions-based orchestration logic as agent tools with no workflow code changes required
- Leveraging Standard workflows for long-running processes requiring status tracking, or Express workflows for high-volume, short-duration synchronous tasks

## Caveats

- The state machine's `Description` field is critical — it becomes the primary MCP tool description and should clearly document when and how to use the workflow
- The `Comment` field in the ASL definition adds supplementary workflow context; populate it with purpose, logic, and expected I/O
- If both `STATE_MACHINE_TAG_KEY` and `STATE_MACHINE_TAG_VALUE` are not set together (only one provided), no state machines are selected and a warning is shown
- If `STATE_MACHINE_PREFIX`, `STATE_MACHINE_LIST`, and tag filters are all empty/unset, all state machines in the region are exposed as tools — use with caution
- The MCP server needs IAM permission to start and describe executions on target state machines
- Credentials must be kept refreshed (especially relevant for Docker deployments using temporary credentials)
- Requires `uv` and Python 3.10+ installed locally

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10: `uv python install 3.10`
3. Ensure AWS credentials (via profile or environment) have `states:StartExecution` and `states:DescribeExecution` permissions on target state machines
4. Set `STATE_MACHINE_PREFIX`, `STATE_MACHINE_LIST`, and/or tag env vars to control which state machines are exposed
5. (Optional) Tag state machines with an EventBridge Schema Registry ARN under a consistent tag key, then set `STATE_MACHINE_INPUT_SCHEMA_ARN_TAG_KEY` for formal input schema support

## opencode.jsonc config

```jsonc
"aws-stepfunctions": {
  "command": "uvx",
  "args": ["awslabs.stepfunctions-tool-mcp-server@latest"],
  "env": {
    "AWS_PROFILE": "your-aws-profile",
    "AWS_REGION": "us-east-1",
    "STATE_MACHINE_PREFIX": "your-state-machine-prefix",
    "STATE_MACHINE_LIST": "your-first-state-machine, your-second-state-machine",
    "STATE_MACHINE_TAG_KEY": "your-tag-key",
    "STATE_MACHINE_TAG_VALUE": "your-tag-value",
    "STATE_MACHINE_INPUT_SCHEMA_ARN_TAG_KEY": "your-state-machine-tag-for-input-schema"
  }
}
```
