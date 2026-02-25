---
name: aws-cdk
type: local
command: ["uvx", "awslabs.cdk-mcp-server@latest"]
requires_env: []
optional_env:
  - FASTMCP_LOG_LEVEL
  - AWS_PROFILE
  - AWS_REGION
env:
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

MCP server for AWS Cloud Development Kit (CDK) best practices, infrastructure as code
patterns, and security compliance with CDK Nag. Provides prescriptive guidance for
building AWS applications using CDK, including Solutions Constructs patterns, GenAI CDK
constructs, Lambda layer documentation, Bedrock Agent schema generation, and CDK Nag
security rule explanations.

> **Note**: This server is deprecated upstream. The replacement is the
> [AWS IaC MCP Server](https://awslabs.github.io/mcp/servers/aws-iac-mcp-server), which
> includes all CDK functionality plus additional IaC capabilities.

## Tools provided

- **CDKGeneralGuidance** — Get prescriptive advice for building AWS applications with CDK; structured decision flow for choosing the right approach
- **GetAwsSolutionsConstructPattern** — Find vetted architecture patterns combining multiple AWS services (AWS Solutions Constructs library)
- **SearchGenAICDKConstructs** — Discover GenAI CDK constructs by name or features for AI/ML workloads
- **GenerateBedrockAgentSchema** — Create OpenAPI schemas for Bedrock Agent action groups from Lambda functions using `BedrockAgentResolver`
- **LambdaLayerDocumentationProvider** — Access documentation, code examples, and directory structure info for Lambda layer implementation
- **ExplainCDKNagRule** — Get detailed guidance and Well-Architected context for specific CDK Nag security/compliance rules
- **CheckCDKNagSuppressions** — Validate that CDK Nag suppressions in your code are appropriate and authorized

## When to use

- Starting a new CDK project and need guidance on patterns or architecture
- Looking for pre-built Solutions Constructs patterns for common service combinations
- Building GenAI/ML workloads with CDK and need construct recommendations
- Creating Bedrock Agents with Action Groups and need OpenAPI schema generation
- Encountering CDK Nag warnings and need to understand their security implications
- Reviewing infrastructure code for security compliance before deployment

## Caveats

- **Deprecated**: Upstream has deprecated this server in favor of `awslabs.aws-iac-mcp-server`. It still works but will eventually be removed.
- `GenerateBedrockAgentSchema` requires Lambda functions to use `BedrockAgentResolver` from AWS Lambda Powertools; will generate a fallback script if dependencies are missing.
- The server itself does not invoke the CDK CLI, but guides workflows that require `aws-cdk` CLI to be installed separately.
- CDK Nag suppression review is advisory — always conduct your own security assessment before suppressing rules.

## Setup

Prerequisites (install once):

```sh
# Install uv (Python package runner)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Python 3.10 via uv
uv python install 3.10

# Install AWS CDK CLI
npm install -g aws-cdk
```

No API keys required. Optionally set AWS credentials/profile if tools need AWS account access:

Add to `~/.config/opencode/opencode.env`:
```
AWS_PROFILE=your-profile-name
AWS_REGION=us-east-1
FASTMCP_LOG_LEVEL=ERROR
```

## opencode.jsonc config

```jsonc
"aws-cdk": {
  "type": "local",
  "command": ["uvx", "awslabs.cdk-mcp-server@latest"],
  "environment": {
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
