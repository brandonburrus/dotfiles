---
name: aws-sagemaker-ai
type: local
command: ["uvx", "awslabs.sagemaker-ai-mcp-server@latest"]
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

The Amazon SageMaker AI MCP Server provides tools for high-performance, low-cost AI/ML
model development on AWS. Currently focused on **SageMaker HyperPod** cluster management —
enabling full lifecycle operations for HyperPod clusters orchestrated with Amazon EKS or
Slurm, including cluster deployment via CloudFormation, node management, and software
updates.

Runs in **read-only mode by default**. Pass `--allow-write` to enable mutating operations
(create/delete clusters, update/delete nodes) and `--allow-sensitive-data-access` to
enable access to logs, events, and resource details.

## Tools provided

### HyperPod Cluster Management
- `manage_hyperpod_stacks` — Deploy, describe, or delete HyperPod CloudFormation stacks
  (VPC, networking, compute). Interfaces with the same managed templates as the HyperPod
  console UI. Only modifies stacks it originally created (safety guard). Cluster creation
  takes ~30 minutes. Requires `--allow-write` for deploy/delete operations.

### HyperPod Cluster Node Operations
- `manage_hyperpod_cluster_nodes` — Manages HyperPod cluster nodes with multiple operations:
  - `list_clusters` — List SageMaker HyperPod clusters with filtering support
  - `list_nodes` — List nodes in a cluster with pagination and filtering
  - `describe_node` — Get detailed info about a specific cluster node (requires `--allow-sensitive-data-access`)
  - `update_software` — Trigger AMI/software updates for all nodes or specific instance groups (requires `--allow-write`)
  - `batch_delete` — Delete multiple nodes from a cluster in one operation (requires `--allow-write`)

## When to use

- Setting up SageMaker HyperPod clusters optimized for distributed training/inference
- Managing HyperPod cluster lifecycle (create, describe, delete) via CloudFormation
- Listing and inspecting HyperPod cluster nodes and their status
- Triggering software/AMI updates across cluster node groups
- Cleaning up unused HyperPod nodes or clusters to control costs

Best used alongside:
- **aws-api** for full SageMaker API coverage beyond HyperPod
- **aws-documentation** or **aws-knowledge-mcp** for SageMaker documentation
- **aws-eks** for EKS cluster management when using EKS-orchestrated HyperPod

## Caveats

- **Read-only by default**: Mutating operations (deploy, delete, update_software,
  batch_delete) require `--allow-write` in the command args.
- **Sensitive data gated**: Node describe and log access requires `--allow-sensitive-data-access`.
- **Cluster creation time**: HyperPod cluster creation takes approximately 30 minutes.
- **Stack ownership**: `manage_hyperpod_stacks` will only modify/delete stacks it
  originally created (enforced safety guard).
- **STDIO only**: Designed for local STDIO use with a single user's credentials; not
  intended for network/multi-user operation.
- **No secrets through MCP**: Do not pass credentials or secrets in prompts or templates;
  use AWS Secrets Manager, Parameter Store, or IRSA instead.
- **Windows command differs**: On Windows use
  `--from awslabs.sagemaker-ai-mcp-server@latest awslabs.sagemaker-ai-mcp-server.exe`
  instead of the standard `awslabs.sagemaker-ai-mcp-server@latest` arg.

## Setup

Requires Python 3.10+, `uv`, and configured AWS CLI credentials.

### IAM Permissions

**Read-only** (minimum required):
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "sagemaker:ListClusters",
      "sagemaker:DescribeCluster",
      "sagemaker:ListClusterNodes",
      "sagemaker:DescribeClusterNode",
      "cloudformation:DescribeStacks"
    ],
    "Resource": "*"
  }]
}
```

**Write operations** additionally require (attach AWS managed policies):
- `IAMFullAccess`
- `AmazonVPCFullAccess`
- `AWSCloudFormationFullAccess`
- `AmazonSageMakerFullAccess`
- `AmazonS3FullAccess`
- `AWSLambda_FullAccess`
- `CloudWatchLogsFullAccess`
- `AmazonFSxFullAccess`
- `eks:*` on `*` (custom inline policy)

> **Security note**: These are broad permissions. Use dedicated IAM roles with least
> privilege, separate roles for read-only vs. write, and enable AWS CloudTrail auditing.

### Environment (optional)

Add to `~/.config/opencode/opencode.env` as needed:
```
AWS_PROFILE=your-profile-name
AWS_REGION=us-east-1
```

## opencode.jsonc config

```jsonc
"aws-sagemaker-ai": {
  "type": "local",
  "command": ["uvx", "awslabs.sagemaker-ai-mcp-server@latest", "--allow-write", "--allow-sensitive-data-access"],
  "environment": {
    "AWS_PROFILE": "{env:AWS_PROFILE}",
    "AWS_REGION": "{env:AWS_REGION}",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
