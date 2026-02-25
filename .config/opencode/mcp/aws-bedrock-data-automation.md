---
name: aws-bedrock-data-automation
type: local
command: ["uvx", "awslabs.aws-bedrock-data-automation-mcp-server@latest"]
requires_env:
  - AWS_BUCKET_NAME
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - BASE_DIR
  - FASTMCP_LOG_LEVEL
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  AWS_BUCKET_NAME: "{env:AWS_BUCKET_NAME}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

MCP server for Amazon Bedrock Data Automation. Enables AI assistants to analyze
unstructured content — documents, images, videos, and audio files — using Amazon
Bedrock Data Automation projects. Integrates with Amazon S3 for asset upload and
result retrieval.

## Tools provided

- **getprojects** — List all available Bedrock Data Automation projects in your
  account
- **getprojectdetails** — Get detailed configuration for a specific project by
  ARN
- **analyzeasset** — Extract structured insights from a local file (document,
  image, video, or audio) using a Bedrock Data Automation project; uploads the
  asset to S3, invokes the project, and returns the results

## When to use

- Extracting structured data or insights from PDFs, images, videos, or audio
  files via a managed Bedrock Data Automation project
- Listing or inspecting existing Bedrock Data Automation projects before
  choosing one for analysis
- Automating document processing pipelines that require multimodal content
  understanding without writing custom Bedrock code

## Caveats

- Amazon Bedrock Data Automation is only available in `us-east-1` and
  `us-west-2`; set `AWS_REGION` accordingly.
- An S3 bucket (`AWS_BUCKET_NAME`) is **required** — the server uploads assets
  and stores results there; ensure the bucket exists and the IAM identity has
  read/write access.
- `analyzeasset` uses the default public project if `projectArn` is omitted;
  results may vary compared to a custom project.
- Requires `uv` and Python 3.10+ installed locally.
- On Windows, use the `uv tool run` invocation form documented on the server
  page rather than `uvx`.

## Setup

**Prerequisites:**
1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Enable Amazon Bedrock Data Automation in your AWS account.
4. Create an S3 bucket:
   ```sh
   aws s3 create-bucket <bucket-name>
   ```
5. Ensure your IAM role/user has permissions for Bedrock Data Automation and
   the S3 bucket.

Set the following in your environment (e.g., `opencode.env`):

```
AWS_PROFILE=your-aws-profile
AWS_REGION=us-east-1          # or us-west-2
AWS_BUCKET_NAME=your-s3-bucket-name
```

`BASE_DIR` is optional; when set it restricts file operations to that directory.

## opencode.jsonc config

```jsonc
"aws-bedrock-data-automation": {
  "type": "local",
  "command": ["uvx", "awslabs.aws-bedrock-data-automation-mcp-server@latest"],
  "environment": {
    "AWS_PROFILE": "${AWS_PROFILE}",
    "AWS_REGION": "${AWS_REGION}",
    "AWS_BUCKET_NAME": "${AWS_BUCKET_NAME}",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
