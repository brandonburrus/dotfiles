---
name: aws-bedrock-agentcore
type: local
command: ["uvx", "awslabs.amazon-bedrock-agentcore-mcp-server@latest"]
requires_env: []
optional_env:
  - FASTMCP_LOG_LEVEL
env:
  FASTMCP_LOG_LEVEL: "{env:FASTMCP_LOG_LEVEL}"
---

## Description

MCP server for Amazon Bedrock AgentCore services that provides search and retrieval of curated AgentCore documentation. Covers all AgentCore platform services including Runtime, Memory, Code Interpreter, Browser, Gateway, Observability, and Identity. Also includes deployment and management tools for AgentCore Runtime, Memory, and Gateway resources.

## Tools provided

- `search_agentcore_docs` - Search curated AgentCore documentation with ranked results and contextual snippets
- `fetch_agentcore_doc` - Fetch full document content by URL for in-depth understanding
- `manage_agentcore_runtime` - Get comprehensive guidance on deploying and managing agents in AgentCore Runtime
- `manage_agentcore_memory` - Get comprehensive guidance on managing AgentCore Memory resources (STM/LTM)
- `manage_agentcore_gateway` - Get comprehensive guidance on deploying and managing MCP Gateways in AgentCore

## When to use

- Building or deploying agents on Amazon Bedrock AgentCore
- Looking up AgentCore API references, tutorials, or best practices
- Troubleshooting AgentCore Runtime deployments or Memory configurations
- Setting up AgentCore Gateway to expose Lambda, OpenAPI, or Smithy-based APIs as agent tools
- Integrating AgentCore services (Code Interpreter, Browser, Identity, Observability) into an agent

## Caveats

- `FASTMCP_LOG_LEVEL` is optional; set to `ERROR` to suppress verbose logs (recommended)
- Requires `uv` and Python 3.10+ installed locally
- Documentation content is fetched live from AWS docs; results depend on network access

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Add the server config to `opencode.jsonc` (see below)

## opencode.jsonc config

```jsonc
"aws-bedrock-agentcore": {
  "type": "local",
  "command": ["uvx", "awslabs.amazon-bedrock-agentcore-mcp-server@latest"],
  "env": {
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
