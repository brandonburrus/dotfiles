---
name: aws-eks
type: local
command: ["uvx", "awslabs.eks-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - FASTMCP_LOG_LEVEL
  - HTTP_PROXY
  - HTTPS_PROXY
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

The Amazon EKS MCP Server provides AI code assistants with resource management tools and
real-time cluster state visibility for Amazon EKS. It enables LLMs to create and manage
EKS clusters via CloudFormation, deploy containerized applications, manage Kubernetes
resources (CRUD), retrieve logs and events, query CloudWatch metrics, and troubleshoot
issues — all through natural language interactions.

Runs in **read-only mode by default**. Pass `--allow-write` to enable mutating operations
and `--allow-sensitive-data-access` to enable log/event/secret access.

## Tools provided

### EKS Cluster Management
- `manage_eks_stacks` — Generate, deploy, describe, or delete EKS CloudFormation stacks (VPC, subnets, IAM, node pools). Creation takes 15–20 min.

### Kubernetes Resource Management
- `manage_k8s_resource` — Create, replace, patch, delete, or read individual K8s resources
- `apply_yaml` — Apply Kubernetes YAML manifests (single or multi-document) to a cluster
- `list_k8s_resources` — List K8s resources with filtering by namespace, labels, and fields
- `list_api_versions` — List all available API versions in a cluster

### Application Support
- `generate_app_manifest` — Generate K8s Deployment + Service YAML from parameters
- `get_pod_logs` — Retrieve pod/container logs (requires `--allow-sensitive-data-access`)
- `get_k8s_events` — Retrieve K8s events for a resource (requires `--allow-sensitive-data-access`)
- `get_eks_vpc_config` — Get VPC/subnet details including hybrid node CIDR info (requires `--allow-sensitive-data-access`)

### CloudWatch Integration
- `get_cloudwatch_logs` — Fetch logs by resource type/name with time/filter options (requires `--allow-sensitive-data-access`)
- `get_cloudwatch_metrics` — Fetch Container Insights metrics with custom dimensions
- `get_eks_metrics_guidance` — List available CloudWatch metrics for cluster/node/pod/namespace/service resource types

### IAM Integration
- `get_policies_for_role` — Retrieve all policies (managed, inline, assume-role) for an IAM role
- `add_inline_policy` — Add a new inline policy to an IAM role (requires `--allow-write`; never modifies existing policies)

### Troubleshooting
- `search_eks_troubleshoot_guide` — Search the EKS troubleshooting knowledge base for symptoms and fixes
- `get_eks_insights` — Retrieve EKS Insights for misconfigurations and upgrade-readiness issues (requires `--allow-sensitive-data-access`)

## When to use

- Creating new EKS clusters with all prerequisites (VPC, subnets, IAM roles, node pools)
- Deploying containerized applications to EKS via YAML or generated manifests
- Inspecting and managing Kubernetes resources (Pods, Services, Deployments, etc.)
- Debugging application issues via pod logs, K8s events, and CloudWatch logs
- Monitoring cluster/node/pod performance metrics through CloudWatch
- Checking IAM role permissions for EKS service accounts
- Troubleshooting EKS-specific issues (auto mode, bootstrap, controller failures)
- Assessing cluster upgrade readiness

## Caveats

- **Read-only by default**: Mutating operations require `--allow-write` in the command args.
- **Sensitive data gated**: Log/event/secret access requires `--allow-sensitive-data-access`.
- **Kubernetes API access**: Only works if your IAM principal created the cluster or has an EKS Access Entry configured; otherwise K8s API calls will fail with authorization errors.
- **Stack ownership**: `manage_eks_stacks` will only modify/delete stacks it originally created (safety guard).
- **Cluster creation time**: EKS cluster creation via CloudFormation takes 15–20 minutes.
- **Windows command differs**: On Windows use `--from awslabs.eks-mcp-server@latest awslabs.eks-mcp-server.exe` instead.
- **No secret creation**: Avoid creating Kubernetes Secrets through MCP tools; use AWS Secrets Manager or IRSA instead.

## Setup

Requires Python 3.10+, `uv`, and configured AWS CLI credentials.

### IAM Permissions

Attach to your IAM role/user:

**Read-only** (minimum required):
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "eks:DescribeCluster", "eks:DescribeInsight", "eks:ListInsights",
      "ec2:DescribeVpcs", "ec2:DescribeSubnets", "ec2:DescribeRouteTables",
      "cloudformation:DescribeStacks",
      "cloudwatch:GetMetricData",
      "logs:StartQuery", "logs:GetQueryResults",
      "iam:GetRole", "iam:GetRolePolicy", "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies", "iam:GetPolicy", "iam:GetPolicyVersion",
      "eks-mcpserver:QueryKnowledgeBase"
    ],
    "Resource": "*"
  }]
}
```

**Write operations** additionally require: `IAMFullAccess`, `AmazonVPCFullAccess`,
`AWSCloudFormationFullAccess`, and `eks:*` on `*`.

### Environment (optional)

Add to `~/.config/opencode/opencode.env` as needed:
```
AWS_PROFILE=your-profile-name
AWS_REGION=us-east-1
```

## opencode.jsonc config

```jsonc
"aws-eks": {
  "type": "local",
  "command": ["uvx", "awslabs.eks-mcp-server@latest", "--allow-write", "--allow-sensitive-data-access"],
  "environment": {
    "AWS_PROFILE": "{env:AWS_PROFILE}",
    "AWS_REGION": "{env:AWS_REGION}",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
