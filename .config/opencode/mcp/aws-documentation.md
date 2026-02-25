---
name: aws-documentation
type: local
command: ["uvx", "awslabs.aws-documentation-mcp-server@latest"]
requires_env: []
optional_env:
  - FASTMCP_LOG_LEVEL
  - AWS_DOCUMENTATION_PARTITION
  - MCP_USER_AGENT
env:
  FASTMCP_LOG_LEVEL: "ERROR"
  AWS_DOCUMENTATION_PARTITION: "aws"
---

## Description

MCP server for AWS documentation. Fetches and converts AWS documentation pages
to markdown, searches the AWS documentation corpus, and returns content
recommendations. Supports both global AWS (`aws`) and AWS China (`aws-cn`)
partitions.

## Tools provided

- **read_documentation** — Fetch an AWS documentation page and convert it to
  markdown (supports pagination via `start_index`)
- **search_documentation** — Search AWS docs using the official AWS
  Documentation Search API; supports filtering by product type and guide type
  (global partition only)
- **recommend** — Get content recommendations related to a given docs page URL
  (global partition only)
- **get_available_services** — List AWS services available in China regions
  (China partition only)

## When to use

- Fetching the full text of a specific AWS documentation page
- Searching across AWS documentation when you need prose content rather than
  structured API data
- Getting "related pages" recommendations to explore a topic further
- Looking up which services are available in AWS China regions

## Caveats

- `search_documentation` and `recommend` are **not available** when
  `AWS_DOCUMENTATION_PARTITION=aws-cn`; use `get_available_services` instead.
- Behind a corporate proxy that blocks certain User-Agent strings, set
  `MCP_USER_AGENT` to your browser's User-Agent string.
- Requires `uv` and Python 3.10+ installed locally.

## Setup

No API keys or credentials required. The server makes unauthenticated HTTP
requests to public AWS documentation endpoints.

**Prerequisites:**
1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`

No entries needed in `opencode.env`.

## opencode.jsonc config

```jsonc
"aws-documentation": {
  "type": "local",
  "command": ["uvx", "awslabs.aws-documentation-mcp-server@latest"],
  "environment": {
    "FASTMCP_LOG_LEVEL": "ERROR",
    "AWS_DOCUMENTATION_PARTITION": "aws"
  }
}
```
