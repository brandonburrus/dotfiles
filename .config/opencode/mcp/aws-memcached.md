---
name: aws-memcached
type: local
command: ["uvx", "awslabs.memcached-mcp-server@latest"]
requires_env:
  - MEMCACHED_HOST
optional_env:
  - MEMCACHED_PORT
  - MEMCACHED_TIMEOUT
  - MEMCACHED_CONNECT_TIMEOUT
  - MEMCACHED_RETRY_TIMEOUT
  - MEMCACHED_MAX_RETRIES
  - MEMCACHED_USE_TLS
  - MEMCACHED_TLS_CERT_PATH
  - MEMCACHED_TLS_KEY_PATH
  - MEMCACHED_TLS_CA_CERT_PATH
  - MEMCACHED_TLS_VERIFY
  - FASTMCP_LOG_LEVEL
env:
  MEMCACHED_HOST: "{env:MEMCACHED_HOST}"
  MEMCACHED_PORT: "11211"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

An AWS Labs MCP server for Amazon ElastiCache Memcached. Provides full Memcached protocol access — get, set, delete, and introspection — over a secure, managed connection to any Memcached endpoint, including Amazon ElastiCache Memcached clusters.

## Tools provided

- **get**: Retrieve the value stored at a given key.
- **set**: Store a value at a key with an optional TTL expiry.
- **add**: Store a value only if the key does not already exist.
- **replace**: Update a value only if the key already exists.
- **delete**: Remove a key from the cache.
- **increment / decrement**: Atomically adjust a numeric counter stored at a key.
- **flush**: Invalidate all keys in the cache (disabled in readonly mode).
- **stats**: Return server statistics and metadata.

## When to use

- Inspecting or querying data in an ElastiCache Memcached cluster during development or debugging.
- Integrating Memcached cache operations into agentic workflows (e.g., read-through cache checks, cache warm-up).
- Monitoring cache hit/miss ratios and server statistics via the `stats` tool.
- Read-only exploration of production caches using `--readonly` mode to ensure no accidental writes.

## Caveats

- Must run locally on the same host as your LLM client (not a remote MCP server).
- Requires network access from the host to the Memcached endpoint (VPC / security-group rules apply for ElastiCache).
- ElastiCache Memcached clusters are not publicly accessible by default; use a VPN, bastion host, or AWS Systems Manager port-forwarding to reach them.
- `--readonly` flag blocks all write operations (set, add, replace, delete, flush, increment, decrement); any write attempt returns an error.
- SSL/TLS support is available but must be explicitly enabled via `MEMCACHED_USE_TLS=true` along with the appropriate certificate paths.
- No AWS credentials are required — the server connects directly to the Memcached protocol endpoint.

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10: `uv python install 3.10`
3. Ensure your Memcached host is reachable from this machine (configure VPC, security groups, or tunneling as needed).
4. For ElastiCache-specific connection guidance: https://github.com/awslabs/mcp/blob/main/src/memcached-mcp-server/ELASTICACHECONNECT.md
5. Set `MEMCACHED_HOST` to your Memcached endpoint and optionally override `MEMCACHED_PORT` (default `11211`).
6. Add the config block below to your `opencode.jsonc`.

### Optional: readonly mode

Add `"--readonly"` to `args` to prevent any write operations — recommended for production caches.

### Optional: SSL/TLS

Set `MEMCACHED_USE_TLS=true` and provide paths for `MEMCACHED_TLS_CERT_PATH`, `MEMCACHED_TLS_KEY_PATH`, and `MEMCACHED_TLS_CA_CERT_PATH` in `env`.

## opencode.jsonc config

```jsonc
"aws-memcached": {
  "type": "local",
  "command": "uvx",
  "args": [
    "awslabs.memcached-mcp-server@latest"
    // Uncomment to enable readonly mode (recommended for production):
    // "--readonly"
  ],
  "env": {
    "MEMCACHED_HOST": "<your-memcached-host>",
    "MEMCACHED_PORT": "11211",
    "FASTMCP_LOG_LEVEL": "ERROR"
    // Optional SSL/TLS:
    // "MEMCACHED_USE_TLS": "true",
    // "MEMCACHED_TLS_CERT_PATH": "/path/to/client-cert.pem",
    // "MEMCACHED_TLS_KEY_PATH": "/path/to/client-key.pem",
    // "MEMCACHED_TLS_CA_CERT_PATH": "/path/to/ca-cert.pem",
    // "MEMCACHED_TLS_VERIFY": "true"
  }
}
```
