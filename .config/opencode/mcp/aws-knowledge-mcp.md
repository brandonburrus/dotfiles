---
name: aws-knowledge-mcp
type: remote
url: "https://knowledge-mcp.global.api.aws"
requires_env: []
---

## Description

A fully managed remote MCP server from AWS Labs that provides up-to-date AWS
documentation, code samples, regional availability data, and other official AWS
content. Indexes a broader range of sources than the local AWS Documentation MCP
server, including What's New posts, blog posts, Builder Center guidance, and
Well-Architected references in addition to the core API and service docs.

No AWS account or authentication required.

## Tools provided

- `search_documentation` — Search across all AWS documentation with optional
  topic-based filtering (reference_documentation, current_awareness,
  troubleshooting, amplify_docs, cdk_docs, cdk_constructs, cloudformation,
  general)
- `read_documentation` — Retrieve and convert an AWS documentation page to
  markdown; supports pagination via `start_index` for long documents
- `recommend` — Get related content recommendations for a given AWS docs URL
  (highly rated, new, similar, journey)
- `list_regions` — Retrieve all AWS regions with their identifiers and
  human-friendly names
- `get_regional_availability` — Check regional availability for AWS products,
  SDK service APIs, and CloudFormation resource types

## When to use

- Looking up AWS service APIs, SDK methods, or CLI commands
- Checking if a service, feature, or CloudFormation resource is available in a
  specific region
- Finding the latest AWS announcements and What's New posts
- Exploring CDK constructs, patterns, and infrastructure-as-code examples
- Troubleshooting AWS errors or misconfiguration
- Getting architectural guidance, best practices, or Well-Architected references
- Building full-stack applications with AWS Amplify

## Caveats

- Requires outbound internet access to `knowledge-mcp.global.api.aws`
- Subject to rate limits (no per-user quota documentation published)
- Not all MCP clients support remote/HTTP transport; use the `fastmcp` proxy
  approach if your client only supports stdio:
  ```jsonc
  "aws-knowledge-mcp": {
    "type": "local",
    "command": ["uvx", "fastmcp", "run", "https://knowledge-mcp.global.api.aws"]
  }
  ```
- Telemetry data is collected but not used for ML model training

## Setup

No API keys or tokens required. The server is publicly accessible.

Ensure your network allows outbound HTTPS to `knowledge-mcp.global.api.aws`.

## opencode.jsonc config

```jsonc
"aws-knowledge-mcp": {
  "type": "remote",
  "url": "https://knowledge-mcp.global.api.aws"
}
```
