---
name: aws-sns-sqs
type: local
command: ["uvx", "awslabs.amazon-sns-sqs-mcp-server@latest"]
requires_env:
  - AWS_REGION
optional_env:
  - AWS_PROFILE
  - FASTMCP_LOG_LEVEL
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

The official AWS SNS/SQS MCP Server. Acts as a bridge between MCP clients and Amazon SNS/SQS, enabling generative AI models to create, configure, and manage SNS topics, SQS queues, subscriptions, and messages. Implements a security model that restricts mutation operations to resources tagged by the server itself, preventing accidental modification of pre-existing infrastructure.

## Tools provided

- **SNS topics** - Create, list, and delete SNS topics (creation/deletion gated by `--allow-resource-creation`).
- **SNS subscriptions** - Create, list, and manage subscriptions between SNS topics and SQS queues or other endpoints.
- **SQS queues** - Create, list, and delete SQS queues (creation/deletion gated by `--allow-resource-creation`).
- **Messaging** - Send messages to SNS topics and receive/delete messages from SQS queues.

Resource creation and deletion are **disabled by default**; pass `--allow-resource-creation` in `args` to enable them. All mutative operations (update, delete) are blocked for resources that do not carry the `mcp_server_version` tag applied at creation time.

## When to use

- Building or testing SNS/SQS messaging pipelines with AI assistance.
- Inspecting existing SNS topics and SQS queues and their subscriptions.
- Sending test messages to topics or draining queues during development.
- Prototyping event-driven architectures without leaving the editor.

## Caveats

- **Read-only by default**: resource creation and deletion require the `--allow-resource-creation` flag.
- **Tag-scoped mutations**: only resources tagged `mcp_server_version` (i.e., created through this server) can be modified or deleted.
- **A2P messaging** (Application-to-Person / SMS) mutative operations are disabled by default for security.
- Requires an AWS profile with at minimum `AmazonSQSReadOnlyAccess` + `AmazonSNSReadOnlyAccess`; full CRUD needs `AmazonSNSFullAccess` + `AmazonSQSFullAccess`.
- `uv` and Python 3.10+ must be installed on the host.

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Configure AWS credentials (`aws configure` or set `AWS_PROFILE` / `AWS_REGION`).
4. Grant the IAM principal at minimum `AmazonSQSReadOnlyAccess` and `AmazonSNSReadOnlyAccess`; add `AmazonSNSFullAccess` and `AmazonSQSFullAccess` if resource creation is needed.
5. Add the config block below to `opencode.jsonc` (append `"--allow-resource-creation"` to `args` when full CRUD is required).

## opencode.jsonc config

```jsonc
"aws-sns-sqs": {
  "type": "local",
  "command": ["uvx", "awslabs.amazon-sns-sqs-mcp-server@latest"],
  "env": {
    "AWS_PROFILE": "default",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
