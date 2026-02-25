---
name: aws-support
type: local
command: ["uvx", "-m", "awslabs.aws-support-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_SESSION_TOKEN
  - FASTMCP_LOG_LEVEL
env:
  AWS_REGION: "{env:AWS_REGION}"
  AWS_PROFILE: "{env:AWS_PROFILE}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

MCP server for interacting with the AWS Support API. Enables AI assistants to create and
manage AWS support cases programmatically, including opening cases, retrieving case
history, adding communications, resolving cases, and looking up valid service codes,
category codes, and severity levels.

Requires a Business, Enterprise On-Ramp, or Enterprise Support plan — the AWS Support
API is not available on Developer or Basic plans.

## Tools provided

**Case Management**
- **create_support_case** — Open a new support case with subject, service code, category code, severity, and communication body
- **describe_support_cases** — List or retrieve open/resolved cases, optionally filtered by case ID, display ID, or date range; supports pagination
- **add_communication_to_case** — Post an update or additional information to an existing case; supports attachments
- **resolve_support_case** — Mark an existing open case as resolved

**Discovery / Lookup**
- **describe_services** — List all AWS services and their category codes valid for support cases (required before creating a case)
- **describe_severity_levels** — List available severity levels (`low`, `normal`, `high`, `urgent`, `critical`) with descriptions
- **describe_supported_languages** — List languages supported for case content; server auto-detects language and falls back to English if unsupported

**Attachments**
- **add_attachments_to_set** — Upload base64-encoded files (≤5 MB each) into an attachment set (expires after 1 hour) for use when creating a case or adding communication

## When to use

- Opening an AWS Support case directly from a conversation without leaving the IDE
- Checking the status of existing support cases or retrieving case communications
- Posting follow-up information or logs to an open support case
- Looking up the correct service code and category code before filing a case
- Resolving a case once an issue is fixed
- Attaching error logs, config files, or screenshots to a support case

## Caveats

- **Requires a paid support plan** — Business, Enterprise On-Ramp, or Enterprise Support; the Support API is unavailable on Basic/Developer plans.
- The AWS Support API is only available in `us-east-1`; set `AWS_REGION=us-east-1` (the default).
- Attachment sets expire after **1 hour**; create them immediately before creating the case or adding communication.
- Each attachment must be **base64-encoded** and ≤ 5 MB.
- `describe_services` and `describe_severity_levels` should always be called first to obtain valid codes before creating a case.

## Setup

Prerequisites (install once):

```sh
# Install uv (Python package runner)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Python 3.10+
uv python install 3.10
```

Configure AWS credentials in `~/.aws/credentials` or via environment variables.
Optionally add to `~/.config/opencode/opencode.env`:

```
AWS_PROFILE=your-profile-name
AWS_REGION=us-east-1
FASTMCP_LOG_LEVEL=ERROR
```

## opencode.jsonc config

```jsonc
"aws-support": {
  "type": "local",
  "command": [
    "uvx",
    "-m",
    "awslabs.aws-support-mcp-server@latest"
  ],
  "environment": {
    "AWS_REGION": "us-east-1",
    "AWS_PROFILE": "default",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
