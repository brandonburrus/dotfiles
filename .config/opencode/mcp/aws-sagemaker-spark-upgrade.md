---
name: aws-sagemaker-spark-upgrade
type: local
command: ["uvx", "mcp-proxy-for-aws@latest"]
requires_env: []
---

## Description

A fully managed remote MCP server that provides specialized tools and guidance for upgrading Apache Spark applications on Amazon EMR. It accelerates Spark version upgrades (2.4 through 3.5 / EMR 5.x through 7.x) through automated project analysis, code transformation, dependency management, EMR job validation, and data quality checks for both PySpark and Scala applications on EMR-EC2 and EMR Serverless.

## Tools provided

- Project analysis and step-by-step upgrade plan generation with risk assessment
- Automated PySpark and Scala code transformation for API changes and deprecations
- Maven/SBT/pip dependency and build environment updates for target Spark versions
- Iterative compile/build error resolution
- Unit, integration, and EMR validation job execution and monitoring
- Data quality validation comparing outputs between old and new Spark versions
- EMR job submission and monitoring (EMR-EC2 and EMR Serverless)
- Upgrade progress tracking and analysis listing/description

## When to use

- You need to upgrade a Spark application from one EMR release to a newer one (e.g., EMR 5.x → 7.x)
- You want automated code transformation to handle Spark API changes and deprecations
- You need to validate a Spark upgrade by running test jobs on EMR and comparing data outputs
- You want to reuse or customize a previously generated upgrade plan

## Caveats

- Supports EMR-EC2 (source: 5.20.0+, target: up to 7.12.0) and EMR Serverless (source: 6.6.0+, target: up to 7.12.0)
- Requires an accessible EMR cluster or EMR Serverless application and an S3 staging path for artifacts
- This server is in preview and subject to change
- Requires configuring a local AWS CLI profile with an IAM role that has EMR and S3 permissions

## Setup

1. **Configure the AWS CLI profile** with the IAM role that has the necessary EMR and S3 permissions:
   ```bash
   export SMUS_MCP_REGION=us-east-1
   export IAM_ROLE=arn:aws:iam::111122223333:role/spark-upgrade-role

   aws configure set profile.spark-upgrade-profile.role_arn ${IAM_ROLE}
   aws configure set profile.spark-upgrade-profile.source_profile default
   aws configure set profile.spark-upgrade-profile.region ${SMUS_MCP_REGION}
   ```

2. Add the MCP server configuration to your client (see below).

3. Refer to the [full setup documentation](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-spark-upgrade-agent-setup.html) for IAM policy details and client-specific configuration (Kiro, Cline, GitHub Copilot).

## opencode.jsonc config

```jsonc
"aws-sagemaker-spark-upgrade": {
  "type": "local",
  "command": ["uvx", "mcp-proxy-for-aws@latest",
    "https://sagemaker-unified-studio-mcp.us-east-1.api.aws/spark-upgrade/mcp",
    "--service", "sagemaker-unified-studio-mcp",
    "--profile", "spark-upgrade-profile",
    "--region", "us-east-1",
    "--read-timeout", "180"
  ]
}
```
