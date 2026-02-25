# Amazon Neptune MCP Server

## Description

MCP server for Amazon Neptune that enables querying and inspecting Neptune graph databases.
Supports openCypher and Gremlin for Neptune Database, and openCypher for Neptune Analytics.
Provides graph schema inspection and connectivity status checks.

## Tools provided

| Tool | Description |
|------|-------------|
| Run Query | Execute openCypher or Gremlin queries against the configured Neptune graph |
| Get Schema | Retrieve the graph schema as a text string |
| Get Status | Check whether the Neptune graph is "Available" or "Unavailable" |

## When to use

- Querying a Neptune graph database or analytics graph from an AI assistant
- Inspecting graph schema to understand node labels, edge types, and properties
- Verifying connectivity to a Neptune instance before running queries
- Exploring or traversing graph data using openCypher or Gremlin

## Caveats

- Neptune Database resides in a **private VPC** — the server must have network access to that VPC (e.g. via a bastion, VPN, or running inside the VPC)
- Neptune Analytics can be accessed via a public endpoint (if configured) or a private endpoint
- The server will execute **any** query sent to it, including mutating writes — scope IAM permissions carefully to allow/deny specific data plane actions
- Requires AWS CLI configured with a profile that has IAM permissions to access and query Neptune
- Endpoint format differs by product:
  - Neptune Database: `neptune-db://<Cluster Endpoint>`
  - Neptune Analytics: `neptune-graph://<Graph Identifier>`

## Setup

1. Install `uv`:
   ```bash
   curl -Ls https://astral.sh/uv/install.sh | sh
   ```

2. Install Python 3.10 via uv:
   ```bash
   uv python install 3.10
   ```

3. Ensure AWS CLI is configured with a profile that has Neptune access:
   ```bash
   aws configure --profile your-aws-profile
   ```

4. Add the config block below to `opencode.jsonc`, substituting your Neptune endpoint and AWS profile.

## opencode.jsonc config

```jsonc
{
  "mcp": {
    "aws-neptune": {
      "command": "uvx",
      "args": ["awslabs.amazon-neptune-mcp-server@latest"],
      "env": {
        "NEPTUNE_ENDPOINT": "neptune-db://your-neptune-cluster-id.region.neptune.amazonaws.com",
        "AWS_PROFILE": "your-aws-profile",
        "AWS_REGION": "us-east-1",
        "FASTMCP_LOG_LEVEL": "ERROR"
      }
    }
  }
}
```
