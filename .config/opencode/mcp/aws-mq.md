---
name: aws-mq
type: local
command: ["uvx", "awslabs.amazon-mq-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - FASTMCP_LOG_LEVEL
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
---

## Description

The Amazon MQ MCP Server enables AI assistants to create, configure, and manage
Amazon MQ message brokers (RabbitMQ and ActiveMQ) via MCP tools. It acts as a
bridge between MCP clients and the Amazon MQ service, with built-in security
controls that restrict mutations to only resources the server itself created
(enforced via automatic resource tagging).

## Tools provided

- `list_brokers` — Lists all Amazon MQ brokers in the account/region
- `describe_broker` — Returns detailed configuration and status for a specific broker
- `create_broker` — Creates a new RabbitMQ or ActiveMQ broker *(requires `--allow-resource-creation` flag)*
- `update_broker` — Updates configuration of a tagged broker
- `reboot_broker` — Reboots a tagged broker
- `delete_broker` — Deletes a tagged broker
- `create_configuration` — Creates a broker configuration *(requires `--allow-resource-creation` flag)*
- `describe_configuration` — Returns details for a broker configuration
- `list_configurations` — Lists available broker configurations
- `update_configuration` — Updates a tagged broker configuration

## When to use

- Creating, inspecting, or managing Amazon MQ brokers (RabbitMQ or ActiveMQ)
- Listing brokers and their configuration in an AWS account
- Rebooting or updating broker settings without leaving the AI assistant
- Auditing broker configurations and tags
- Automating message broker provisioning in dev/test environments

## Caveats

- **Resource creation is off by default**: The `create_broker` and
  `create_configuration` tools are only exposed when the server is started with
  the `--allow-resource-creation` flag. Omit it for read/update-only access.
- **Tag-gated mutations**: The server only allows `update`, `reboot`, and `delete`
  on resources it created (identified by an auto-applied `mcp_server_version` tag).
  Pre-existing brokers cannot be mutated through this server.
- **IAM permissions**: Read-only usage requires `AmazonMQReadOnlyAccess`; mutating
  operations require `AmazonMQFullAccess`. Follow least-privilege and scope to a
  dedicated role.
- **Network security**: Brokers should be created with `publicly_accessible: false`
  wherever possible. Rotate broker user credentials regularly.
- **Single region per instance**: The server targets one region (set via
  `AWS_REGION`). Run separate instances for multi-region management.

## Setup

1. **Install `uv`** (Python package runner):
   ```sh
   brew install uv   # macOS
   # or: pip install uv
   ```

2. **Install Python 3.10+** via uv:
   ```sh
   uv python install 3.10
   ```

3. **Configure an AWS profile** with the appropriate Amazon MQ permissions:
   - Read-only: attach `AmazonMQReadOnlyAccess`
   - Full management: attach `AmazonMQFullAccess`

4. **Set environment variables** in `~/.config/opencode/opencode.env`:
   ```
   AWS_PROFILE=your-aws-profile
   AWS_REGION=us-east-1
   ```

5. *(Optional)* To enable broker/configuration creation, add the
   `--allow-resource-creation` flag to the `args` array in the config below.

## opencode.jsonc config

```jsonc
"aws-mq": {
  "type": "local",
  "command": ["uvx", "awslabs.amazon-mq-mcp-server@latest"],
  "environment": {
    "AWS_PROFILE": "{env:AWS_PROFILE}",
    "AWS_REGION": "{env:AWS_REGION}",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
