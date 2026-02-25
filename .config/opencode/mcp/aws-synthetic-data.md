---
name: aws-synthetic-data
type: local
command: ["uvx", "awslabs.syntheticdata-mcp-server@latest"]
requires_env:
  - AWS_PROFILE
  - AWS_REGION
optional_env:
  - FASTMCP_LOG_LEVEL
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

MCP server for generating, validating, and managing synthetic data. Translates plain
business descriptions into structured data generation instructions, executes pandas code
in a sandboxed environment, validates multi-table datasets for referential integrity, and
loads the resulting data to storage targets such as Amazon S3.

## Tools provided

- **get_data_gen_instructions** — Accepts a natural-language business description and
  returns structured instructions (schema, relationships, volumes) for generating realistic
  synthetic data.
  - Required: `business_description` (str)

- **execute_pandas_code** — Runs pandas code in a restricted execution environment with
  automatic DataFrame detection. Writes output to a configurable workspace directory.
  - Required: `code` (str), `workspace_dir` (str)
  - Optional: `output_dir` (str)

- **validate_jsonl** — Validates JSON Lines data and converts it to CSV format.
  - Required: `jsonl_data` (str)

- **validate_and_save_data** — Validates multi-table data for structural correctness and
  referential integrity (foreign key relationships), then saves each table as a CSV file.
  - Required: `data` (dict[str, list]), `workspace_dir` (str)
  - Optional: `output_dir` (str)

- **load_to_storage** — Uploads generated data to one or more storage targets (currently
  S3). Supports CSV, JSON, and Parquet formats, partitioning, storage class selection, and
  server-side encryption.
  - Required: `data` (dict[str, list]), `targets` (list of target configs)

## When to use

- Rapidly generating realistic test/dev datasets from a plain-English description of a
  business domain (e.g., e-commerce, healthcare, finance).
- Populating databases, data lakes, or S3 buckets with synthetic data for integration
  testing or demos.
- Validating that a multi-table dataset maintains referential integrity before loading.
- Safely running ad-hoc pandas data-transformation code without risking the host
  environment.
- Assessing a data model for 3NF compliance or other structural quality issues.

## Caveats

- Requires `uv` and Python 3.10+ installed locally.
- AWS credentials must have S3 write permissions when using `load_to_storage` with an S3
  target; other tools require only basic AWS credential configuration.
- Pandas code execution is sandboxed but runs locally — avoid passing untrusted code.
- Only S3 is supported as a storage target in the current release.
- AWS credentials must be kept refreshed on the host (token-based profiles expire).

## Setup

**Prerequisites:**
1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Configure AWS credentials: `aws configure` (or use an AWS profile with `AWS_PROFILE`).

**Required IAM permissions (for S3 upload):**
- `s3:PutObject`
- `s3:GetBucketLocation`
- *(Scope to the target bucket(s) following least-privilege)*

Set `AWS_PROFILE` and `AWS_REGION` in your environment or `opencode.env`.

## opencode.jsonc config

```jsonc
"aws-synthetic-data": {
  "type": "local",
  "command": ["uvx", "awslabs.syntheticdata-mcp-server@latest"],
  "environment": {
    "AWS_PROFILE": "${AWS_PROFILE}",
    "AWS_REGION": "${AWS_REGION}",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
