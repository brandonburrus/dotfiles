---
name: aws-diagram
type: local
command: ["uvx", "awslabs.aws-diagram-mcp-server@latest"]
requires_env: []
optional_env:
  - FASTMCP_LOG_LEVEL
env:
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

MCP server for generating diagrams using the Python `diagrams` package DSL. Supports AWS
architecture diagrams, sequence diagrams, flow charts, and class diagrams from Python code.
Includes built-in code scanning to ensure secure diagram generation.

## Tools provided

- **generate_diagram** — Execute Python `diagrams` DSL code to produce a diagram image (PNG); supports AWS architecture, sequence, flow, and class diagram types with full customization of layout and styling

## When to use

- Visualizing AWS architecture (e.g., API Gateway → Lambda → DynamoDB) as a professional diagram
- Creating sequence, flow, or class diagrams from structured Python code
- Generating diagrams programmatically as part of documentation or design review workflows
- Any task where a picture of infrastructure or system design is more useful than a text description

## Caveats

- Requires GraphViz to be installed on the host system; diagrams will fail without it
- Only supports the `diagrams` Python package DSL — not Mermaid, PlantUML, or other formats
- Output is a PNG file written to disk; the server returns the file path, not inline image data
- Code is scanned for security before execution but the server still runs arbitrary Python — review generated code before approving in sensitive environments

## Setup

Prerequisites (install once):

```sh
# Install uv (Python package runner)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Python 3.10 via uv
uv python install 3.10

# Install GraphViz (required by the diagrams package)
brew install graphviz          # macOS
# sudo apt-get install graphviz  # Debian/Ubuntu
# choco install graphviz         # Windows (Chocolatey)
```

No AWS credentials or API keys required.

## opencode.jsonc config

```jsonc
"aws-diagram": {
  "type": "local",
  "command": ["uvx", "awslabs.aws-diagram-mcp-server@latest"],
  "environment": {
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
