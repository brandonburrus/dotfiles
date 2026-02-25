---
name: aws-qbusiness-anonymous
type: local
command: ["uvx", "awslabs.amazon-qbusiness-anonymous-mcp-server@latest"]
requires_env:
  - QBUSINESS_APPLICATION_ID
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - FASTMCP_LOG_LEVEL
env:
  QBUSINESS_APPLICATION_ID: "{env:QBUSINESS_APPLICATION_ID}"
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

MCP server for querying an Amazon Q Business application created in **anonymous mode**.
Lets an AI agent send natural-language queries to the Q Business application and receive
answers grounded in the content ingested into it — without requiring end-user authentication.

Read-only: the server cannot create, modify, or delete any resources in your account.

## Tools provided

- **QBusinessQueryTool** — Takes a natural-language `query` string, calls the Amazon Q
  Business `ChatSync` API against the configured anonymous-mode application, and returns
  the application's response.

## When to use

- Querying a private knowledge base or document corpus indexed in Amazon Q Business
  without requiring user sign-in (anonymous access mode)
- Building AI workflows that need to retrieve enterprise content (wikis, runbooks,
  policies) through Q Business
- Prototyping Q Business integrations before adding authenticated user flows

## Caveats

- Only works with Q Business applications explicitly created with **anonymous mode**
  access enabled; standard (IAM Identity Center) applications are not supported.
- Requires an IAM user/role with at least `qbusiness:ChatSync` permission on the target
  application — follow least-privilege principles.
- The server is stateless; each tool call starts a new conversation turn (no persistent
  session memory across calls unless the client manages context).
- Windows users need a different invocation style (`uv tool run --from ...`) — see the
  upstream docs for details.

## Setup

1. **Create an anonymous-mode Q Business application** in the AWS Console:
   https://docs.aws.amazon.com/amazonq/latest/qbusiness-ug/create-anonymous-application.html

2. **Configure IAM** — attach a policy with at minimum `qbusiness:ChatSync` to the
   credentials you will use:
   https://docs.aws.amazon.com/amazonq/latest/qbusiness-ug/security_iam_id-based-policy-examples.html

3. **Install prerequisites**:

   ```sh
   # Install uv
   curl -LsSf https://astral.sh/uv/install.sh | sh

   # Install Python 3.10
   uv python install 3.10

   # Configure AWS credentials
   aws configure
   ```

4. **Set environment variables** (e.g. in `~/.config/opencode/opencode.env`):

   ```
   QBUSINESS_APPLICATION_ID=<your-q-business-app-id>
   AWS_PROFILE=<your-aws-profile>
   AWS_REGION=us-east-1
   ```

## opencode.jsonc config

```jsonc
"aws-qbusiness-anonymous": {
  "type": "local",
  "command": [
    "uvx",
    "awslabs.amazon-qbusiness-anonymous-mcp-server@latest"
  ],
  "environment": {
    "QBUSINESS_APPLICATION_ID": "<your-q-business-app-id>",
    "AWS_PROFILE": "default",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
