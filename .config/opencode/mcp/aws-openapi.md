---
name: aws-openapi
type: local
command: ["uvx", "awslabs.openapi-mcp-server@latest"]
optional_env:
  - API_NAME
  - API_BASE_URL
  - API_SPEC_URL
  - API_SPEC_PATH
  - AUTH_TYPE
  - AUTH_USERNAME
  - AUTH_PASSWORD
  - AUTH_TOKEN
  - AUTH_API_KEY
  - AUTH_API_KEY_NAME
  - AUTH_API_KEY_IN
  - LOG_LEVEL
  - ENABLE_PROMETHEUS
  - ENABLE_OPERATION_PROMPTS
  - UVICORN_TIMEOUT_GRACEFUL_SHUTDOWN
  - UVICORN_GRACEFUL_SHUTDOWN
env:
  LOG_LEVEL: "ERROR"
  ENABLE_PROMETHEUS: "false"
  ENABLE_OPERATION_PROMPTS: "true"
  UVICORN_TIMEOUT_GRACEFUL_SHUTDOWN: "5.0"
  UVICORN_GRACEFUL_SHUTDOWN: "true"
---

## Description

MCP server that dynamically generates Model Context Protocol tools and prompts
directly from an OpenAPI 3.x specification (JSON or YAML). LLMs can discover and
call any API that has an OpenAPI spec without requiring hand-written tool
definitions. Supports local spec files, remote spec URLs, multiple authentication
schemes, and optional Prometheus metrics.

## Tools provided

Tools are generated dynamically from the OpenAPI spec you point the server at.
The server creates one MCP tool per API operation (HTTP method + path), plus
additional prompt resources:

- **`<operation_id>` tools** — One tool per OpenAPI operation; tool name, input
  schema, and description are derived directly from the spec
- **Operation-specific prompts** — Natural language prompts for each API
  operation that help the LLM understand how and when to invoke the endpoint
- **API documentation prompt** — A single comprehensive prompt describing the
  entire API surface

For reference, pointing the server at the Swagger Petstore spec produces tools
such as `addPet`, `findPetsByStatus`, `getPetById`, `updatePet`, `deletePet`,
`getInventory`, `placeOrder`, etc.

## When to use

- Interacting with any REST API that exposes an OpenAPI 3.x specification
- Rapidly prototyping AI-driven API integrations without writing tool wrappers
- Exploring unfamiliar APIs — the LLM can discover available operations from
  the generated prompts and docs
- Calling internal or third-party AWS-adjacent APIs (e.g., custom API Gateway
  endpoints that publish an OpenAPI spec) from an agent session

## Caveats

- Requires `uv` / `uvx` on the host; install from https://docs.astral.sh/uv/
- Only OpenAPI **3.x** specs are supported (Swagger 2.x is not)
- YAML specs require the `[yaml]` extra:
  `pip install "awslabs.openapi-mcp-server[yaml]"`
- GET operations with query parameters are mapped to MCP **tools** (not
  resources) to improve LLM usability — this differs from the strict MCP
  resource model
- Prometheus metrics are disabled by default; enable with `ENABLE_PROMETHEUS=true`
  (requires the `[prometheus]` extra)
- The server validates the spec at startup but does not fail on minor issues
  or non-standard extensions — it logs warnings instead
- Authentication credentials (tokens, API keys, passwords) must be passed via
  environment variables; they are not stored by the server

## Setup

**Prerequisites:**
1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Obtain your API's OpenAPI spec URL or local file path

**Required environment variables** (set per-server in `opencode.jsonc`):
- `API_NAME` — short identifier for your API (e.g., `petstore`)
- `API_BASE_URL` — base URL the server will use to make API calls
- `API_SPEC_URL` — URL to fetch the OpenAPI spec (mutually exclusive with
  `API_SPEC_PATH`)
- `API_SPEC_PATH` *(alternative)* — absolute path to a local spec file

**Authentication variables** (add whichever apply):
- `AUTH_TYPE` — one of `none` (default), `basic`, `bearer`, `api_key`
- `AUTH_USERNAME` / `AUTH_PASSWORD` — for `basic` auth
- `AUTH_TOKEN` — for `bearer` auth
- `AUTH_API_KEY` — for `api_key` auth
- `AUTH_API_KEY_NAME` — header/query/cookie param name (default: `api_key`)
- `AUTH_API_KEY_IN` — placement: `header`, `query`, or `cookie`

## opencode.jsonc config

```jsonc
"aws-openapi": {
  "type": "local",
  "command": ["uvx", "awslabs.openapi-mcp-server@latest"],
  "environment": {
    "API_NAME": "your-api-name",
    "API_BASE_URL": "https://api.example.com",
    "API_SPEC_URL": "https://api.example.com/openapi.json",
    "LOG_LEVEL": "ERROR",
    "ENABLE_PROMETHEUS": "false",
    "ENABLE_OPERATION_PROMPTS": "true",
    "UVICORN_TIMEOUT_GRACEFUL_SHUTDOWN": "5.0",
    "UVICORN_GRACEFUL_SHUTDOWN": "true"
  }
}
```
