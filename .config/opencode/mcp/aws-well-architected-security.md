---
name: aws-well-architected-security
type: local
command: ["uvx", "awslabs.well-architected-security-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - FASTMCP_LOG_LEVEL
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "{env:FASTMCP_LOG_LEVEL}"
---

## Description

An MCP server that provides operational tools for monitoring and assessing AWS environments against the AWS Well-Architected Framework Security Pillar. It enables AI assistants to evaluate security posture, monitor compliance status, and optimize security costs. It integrates with AWS security services such as GuardDuty, Security Hub, Inspector, and IAM Access Analyzer.

## Tools provided

- **CheckSecurityServices** - Monitor operational status of GuardDuty, Security Hub, Inspector, and IAM Access Analyzer across regions
- **GetSecurityFindings** - Retrieve and filter security findings from Security Hub, GuardDuty, and Inspector by severity, resource type, or service
- **GetResourceComplianceStatus** - Monitor resource compliance against security standards and identify non-compliant resources
- **GetStoredSecurityContext** - Retrieve historical security operations data for trend analysis and posture comparison over time
- **ExploreAwsResources** - Discover and inventory AWS resources across services and regions for operational security visibility
- **AnalyzeSecurityPosture** - Comprehensive evaluation of security posture against the Well-Architected Framework with prioritized recommendations

## When to use

- Auditing your AWS security posture against the Well-Architected Security Pillar
- Generating operational security reports or dashboards for stakeholders
- Monitoring compliance status across resources and regions
- Investigating active security findings from GuardDuty, Security Hub, or Inspector
- Identifying resources that are missing encryption or not meeting security standards
- Performing cost optimization of security service spending

## Caveats

- Requires AWS credentials with read-only permissions for the relevant security services
- Does not perform automated remediation — findings must be addressed through separate workflows
- Rate limiting should be considered to avoid hitting AWS API limits in large accounts
- Sensitive security findings may be surfaced; avoid exposing output in untrusted environments

## Setup

1. Install `uv` if not already available: https://docs.astral.sh/uv/getting-started/installation/
2. Ensure AWS credentials are configured (via `~/.aws/credentials`, environment variables, or an IAM role)
3. Recommended: create a dedicated IAM role with least-privilege read-only permissions for security services (GuardDuty, Security Hub, Inspector, IAM Access Analyzer, Config, S3, EC2, etc.)
4. Add the server to your MCP client configuration (see below)

## opencode.jsonc config

```jsonc
"aws-well-architected-security": {
  "type": "local",
  "command": ["uvx", "awslabs.well-architected-security-mcp-server@latest"],
  "env": {
    "AWS_PROFILE": "your-aws-profile",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
