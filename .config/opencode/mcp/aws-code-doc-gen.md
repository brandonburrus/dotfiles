---
name: aws-code-doc-gen
type: local
command: ["uvx", "awslabs.code-doc-gen-mcp-server@latest"]
requires_env: []
optional_env:
  - FASTMCP_LOG_LEVEL
env:
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

> **Deprecation notice:** This server is deprecated and will be archived. Modern
> LLMs handle documentation generation effectively via native file/code tools.
> See [RFC #2004](https://github.com/awslabs/mcp/issues/2004) for details.

MCP server that automatically analyzes a repository's structure using
[repomix](https://github.com/yamadashy/repomix) and generates comprehensive,
structured documentation (README, API docs, backend/frontend docs, deployment
guides) for code projects. Works in a multi-step workflow: analyze → create
context → plan → generate document templates.

## Tools provided

- **prepare_repository** — Runs repomix against a project root, extracts
  directory structure, and returns a `ProjectAnalysis` template for the client
  to complete
- **create_context** — Wraps a completed `ProjectAnalysis` into a
  `DocumentationContext` (tracks state throughout the workflow)
- **plan_documentation** — Produces a `DocumentationPlan` (document types and
  section outlines) based on the project analysis
- **generate_documentation** — Generates document templates with section
  scaffolding for the client to fill with content

## When to use

- Bootstrapping documentation for a new or undocumented code project
- Generating structured README, API reference, or deployment guides from a
  repository layout
- Pairing with the AWS Diagram MCP server to include architecture diagrams in
  generated docs
- Producing CDK/Terraform infrastructure documentation alongside the AWS CDK
  MCP server

## Caveats

- **Deprecated** — the upstream project plans to archive this server; prefer
  prompting your AI assistant directly ("Generate comprehensive documentation
  for this project…") for new workflows.
- Requires `repomix >= 0.2.6` installed in the Python environment
  (`pip install repomix>=0.2.6`) before the server can analyze a repository.
- Requires `uv` and Python 3.10+ installed locally.
- No AWS credentials are needed; the server operates entirely on local files.

## Setup

**Prerequisites:**
1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Install repomix: `pip install repomix>=0.2.6`

No API keys, AWS credentials, or `opencode.env` entries required.

## opencode.jsonc config

```jsonc
"aws-code-doc-gen": {
  "type": "local",
  "command": ["uvx", "awslabs.code-doc-gen-mcp-server@latest"],
  "environment": {
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
