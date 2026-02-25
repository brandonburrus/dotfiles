---
name: aws-msk
type: local
command: ["uvx", "awslabs.aws-msk-mcp-server@latest"]
requires_env: []
optional_env:
  - FASTMCP_LOG_LEVEL
  - AWS_PROFILE
  - AWS_REGION
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_SESSION_TOKEN
env:
  FASTMCP_LOG_LEVEL: "{env:FASTMCP_LOG_LEVEL}"
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
---

## Description

An AWS Labs MCP server for Amazon Managed Streaming for Kafka (MSK). It provides structured access to MSK APIs, enabling AI assistants to create, manage, monitor, and optimize MSK clusters (both provisioned and serverless). The server runs in read-only mode by default; pass `--allow-writes` to enable write operations.

## Tools provided

- **describe_cluster_operation** - Gets information about a specific cluster operation
- **get_cluster_info** - Retrieves various types of information about MSK clusters
- **get_global_info** - Gets global information about MSK resources
- **create_cluster** - Creates a new MSK cluster (provisioned or serverless)
- **update_broker_storage** - Updates storage size of brokers
- **update_broker_type** - Updates broker instance type
- **update_broker_count** - Updates number of brokers in a cluster
- **update_cluster_configuration** - Updates configuration of a cluster
- **update_monitoring** - Updates monitoring settings
- **update_security** - Updates security settings
- **reboot_broker** - Reboots brokers in a cluster
- **get_configuration_info** - Gets information about MSK configurations
- **create_configuration** - Creates a new MSK configuration
- **update_configuration** - Updates an existing configuration
- **describe_vpc_connection** - Gets information about a VPC connection
- **create_vpc_connection** - Creates a new VPC connection
- **delete_vpc_connection** - Deletes a VPC connection
- **reject_client_vpc_connection** - Rejects a client VPC connection request
- **put_cluster_policy** - Puts a resource policy on a cluster
- **associate_scram_secret** - Associates SCRAM secrets with a cluster
- **disassociate_scram_secret** - Disassociates SCRAM secrets from a cluster
- **list_tags_for_resource** - Lists all tags for an MSK resource
- **tag_resource** - Adds tags to an MSK resource
- **untag_resource** - Removes tags from an MSK resource
- **list_customer_iam_access** - Lists IAM access information for a cluster
- **get_cluster_telemetry** - Retrieves telemetry data for MSK clusters
- **get_cluster_best_practices** - Gets best practices and recommendations for MSK clusters

## When to use

- Creating and configuring new Amazon MSK clusters (provisioned or serverless)
- Monitoring MSK cluster performance, health, and telemetry
- Managing MSK security, access controls, and SCRAM secrets
- Managing VPC connections for MSK clusters
- Getting best practice recommendations for cluster sizing and configuration
- Troubleshooting MSK cluster issues

## Caveats

- The server runs in read-only mode by default; add `--allow-writes` to the command args to enable mutating operations
- Most tools require specifying an AWS region; the server will prompt for one if not provided
- AWS credentials must be configured via environment variables, `~/.aws/credentials`, or an IAM role

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10: `uv python install 3.10`
3. Configure AWS credentials via `aws configure` or environment variables
4. Add the server configuration to your MCP client (see below)
5. To enable write operations, add `"--allow-writes"` to the `args` array

## opencode.jsonc config

```jsonc
"aws-msk": {
  "type": "local",
  "command": ["uvx", "awslabs.aws-msk-mcp-server@latest"],
  "env": {
    "FASTMCP_LOG_LEVEL": "ERROR",
    "AWS_PROFILE": "default",
    "AWS_REGION": "us-east-1"
  }
}
```
