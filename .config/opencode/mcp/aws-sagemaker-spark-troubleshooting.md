---
name: aws-sagemaker-spark-troubleshooting
type: local
command: ["uvx", "mcp-proxy-for-aws@latest"]
requires_env: []
---

## Description

A fully managed remote MCP server that provides specialized tools for troubleshooting Apache Spark applications on Amazon EMR, AWS Glue, and Amazon SageMaker Notebooks. It automates failure analysis by connecting to platform-specific Spark history servers (EMR Persistent UI, Glue Studio Spark UI, EMR Serverless Spark History Server) to extract telemetry and identify root causes. Also provides a code recommendation engine for actionable PySpark/Scala fixes on EMR-EC2 and AWS Glue workloads.

## Tools provided

- Troubleshoot failed Spark jobs on Amazon EMR on EC2 (by step/cluster ID)
- Troubleshoot failed Spark jobs on AWS Glue (by job run ID and job name)
- Troubleshoot failed Spark jobs on Amazon EMR Serverless (by application and job run ID)
- Request code fix recommendations for failed EMR-EC2 and Glue PySpark workloads
- Automated feature extraction from Spark event logs and resource usage metrics
- GenAI root cause analysis correlating telemetry with a Spark knowledge base

## When to use

- A Spark job on EMR, Glue, or EMR Serverless has failed and you need root cause analysis
- You want AI-generated code fix recommendations for a failed PySpark job
- You need to analyze memory problems, configuration errors, or code bugs in Spark applications
- You want to review Spark event logs and performance metrics conversationally

## Caveats

- Only supports **failed** Spark workloads; running or successful jobs are not analyzed
- Code recommendations are only available for Amazon EMR-EC2 and AWS Glue PySpark applications (not Scala, not EMR Serverless)
- Glue Studio Spark UI event log size limit: 512 MB (2 GB for rolling logs)
- The server is regional; cross-region troubleshooting is not supported
- This server is in preview and subject to change
- Requires deploying a CloudFormation stack and configuring a local AWS CLI profile with an IAM role

## Setup

1. **Deploy the CloudFormation stack** for your region via the [setup documentation](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/spark-troubleshooting-agent-setup.html).

2. **Configure the AWS CLI profile** using the outputs from the stack:
   ```bash
   export SMUS_MCP_REGION=us-east-1
   export IAM_ROLE=arn:aws:iam::111122223333:role/spark-troubleshooting-role-xxxxxx

   aws configure set profile.smus-mcp-profile.role_arn ${IAM_ROLE}
   aws configure set profile.smus-mcp-profile.source_profile default
   aws configure set profile.smus-mcp-profile.region ${SMUS_MCP_REGION}
   ```

3. Add the MCP server configuration to your client (see below). Two separate endpoints are available: one for troubleshooting and one for code recommendations.

## opencode.jsonc config

```jsonc
// Spark Troubleshooting
"aws-sagemaker-spark-troubleshooting": {
  "type": "local",
  "command": ["uvx", "mcp-proxy-for-aws@latest",
    "https://sagemaker-unified-studio-mcp.us-east-1.api.aws/spark-troubleshooting/mcp",
    "--service", "sagemaker-unified-studio-mcp",
    "--profile", "smus-mcp-profile",
    "--region", "us-east-1",
    "--read-timeout", "180"
  ]
},
// Spark Code Recommendation (optional, separate endpoint)
"aws-sagemaker-spark-code-rec": {
  "type": "local",
  "command": ["uvx", "mcp-proxy-for-aws@latest",
    "https://sagemaker-unified-studio-mcp.us-east-1.api.aws/spark-code-recommendation/mcp",
    "--service", "sagemaker-unified-studio-mcp",
    "--profile", "smus-mcp-profile",
    "--region", "us-east-1",
    "--read-timeout", "180"
  ]
}
```
