---
name: aws-bedrock-kb-retrieval
type: local
command: ["uvx", "awslabs.bedrock-kb-retrieval-mcp-server@latest"]
requires_env:
  - AWS_PROFILE
  - AWS_REGION
optional_env:
  - FASTMCP_LOG_LEVEL
  - KB_INCLUSION_TAG_KEY
  - BEDROCK_KB_RERANKING_ENABLED
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "ERROR"
  BEDROCK_KB_RERANKING_ENABLED: "false"
---

## Description

MCP server for accessing Amazon Bedrock Knowledge Bases. Enables natural language
retrieval from one or more knowledge bases, with support for filtering by data source,
citation metadata, and optional reranking of results using Amazon Bedrock reranking models.

## Tools provided

- **list_knowledge_bases** — Discover all available knowledge bases (filtered by the
  `KB_INCLUSION_TAG_KEY` tag if set), including their names, IDs, and descriptions
- **list_data_sources** — List data sources associated with a given knowledge base
- **query_knowledge_base** — Retrieve relevant passages from a knowledge base using a
  natural language query; supports data-source filtering and optional reranking

## When to use

- Querying private or internal documentation stored in Amazon Bedrock Knowledge Bases
- Augmenting AI responses with grounded, cited content from your own data sources
- Exploring which knowledge bases and data sources are available in an AWS account
- Narrowing retrieval to specific data sources within a knowledge base
- Improving result relevance by enabling Bedrock reranking

## Caveats

- Knowledge bases must be tagged with `mcp-multirag-kb=true` (or the custom tag key
  set via `KB_INCLUSION_TAG_KEY`) to be discoverable by the server.
- Results with `IMAGE` content type are excluded from query responses.
- Reranking requires additional IAM permissions (`bedrock:Rerank`,
  `bedrock:InvokeModel`), model access enabled in the target region, and is only
  available in specific AWS regions. See the
  [supported regions list](https://docs.aws.amazon.com/bedrock/latest/userguide/rerank-supported.html).
- Requires `uv` and Python 3.10+ installed locally.
- AWS credentials must be configured and the IAM principal must have permissions to
  list/describe knowledge bases, access data sources, and query knowledge bases.

## Setup

**Prerequisites:**
1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Configure the AWS CLI with a profile that has access to Amazon Bedrock and Knowledge Bases.
4. Ensure at least one Bedrock Knowledge Base exists and is tagged with
   `mcp-multirag-kb=true` (or your custom `KB_INCLUSION_TAG_KEY` value).

**Required IAM permissions:**
- `bedrock:ListKnowledgeBases`
- `bedrock:GetKnowledgeBase`
- `bedrock:ListDataSources`
- `bedrock:Retrieve`
- *(optional, for reranking)* `bedrock:Rerank`, `bedrock:InvokeModel`

Set `AWS_PROFILE` and `AWS_REGION` in your environment or `opencode.env`.

## opencode.jsonc config

```jsonc
"aws-bedrock-kb-retrieval": {
  "type": "local",
  "command": ["uvx", "awslabs.bedrock-kb-retrieval-mcp-server@latest"],
  "environment": {
    "AWS_PROFILE": "${AWS_PROFILE}",
    "AWS_REGION": "${AWS_REGION}",
    "FASTMCP_LOG_LEVEL": "ERROR",
    "KB_INCLUSION_TAG_KEY": "mcp-multirag-kb",
    "BEDROCK_KB_RERANKING_ENABLED": "false"
  }
}
```
