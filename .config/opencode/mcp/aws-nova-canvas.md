---
name: aws-nova-canvas
type: local
command: ["uvx", "awslabs.nova-canvas-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - FASTMCP_LOG_LEVEL
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

MCP server for generating images using Amazon Nova Canvas via Amazon Bedrock.
Supports text-to-image generation, color-palette-guided image generation, and
saving output images to a local workspace directory.

## Tools provided

- **generate_image** — Generate one or more images (1–5) from a text prompt.
  Supports customizable dimensions (320–4096 px), quality options, negative
  prompting, `cfg_scale` (1.1–10.0), and seeded generation for reproducibility.
- **generate_image_with_colors** — Generate images guided by a specific color
  palette (up to 10 hex color values). Same customization options as
  `generate_image`.

Both tools save output images to a user-specified workspace directory (created
automatically if it does not exist).

## When to use

- Generating images from natural-language descriptions using Amazon Nova Canvas
- Producing images that must match a specific color palette or brand colors
- Automating image creation as part of a content or design workflow via an AI
  coding assistant

## Caveats

- Requires an AWS account with **Amazon Bedrock** and **Amazon Nova Canvas**
  enabled in the target region (default: `us-east-1`).
- The IAM user/role associated with `AWS_PROFILE` must have Bedrock and Nova
  Canvas permissions.
- AWS credentials are used locally via boto3; they are never sent anywhere
  other than AWS API endpoints.
- Requires `uv` and Python 3.10+ installed locally.
- On Windows, use `uv tool run --from awslabs.nova-canvas-mcp-server@latest
  awslabs.nova-canvas-mcp-server.exe` instead of `uvx`.

## Setup

**Prerequisites:**
1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Enable Amazon Bedrock and Amazon Nova Canvas in your AWS account.
4. Configure AWS credentials: `aws configure` (or use environment variables /
   an existing named profile).

Set `AWS_PROFILE` and `AWS_REGION` in your environment (e.g., `opencode.env`)
or directly in the config block below.

## opencode.jsonc config

```jsonc
"aws-nova-canvas": {
  "type": "local",
  "command": ["uvx", "awslabs.nova-canvas-mcp-server@latest"],
  "environment": {
    "AWS_PROFILE": "default",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
