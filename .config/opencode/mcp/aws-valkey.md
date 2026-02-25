---
name: aws-valkey
type: local
command: ["uvx", "awslabs.valkey-mcp-server@latest"]
requires_env:
  - VALKEY_HOST
  - VALKEY_PORT
optional_env:
  - VALKEY_USERNAME
  - VALKEY_PWD
  - VALKEY_USE_SSL
  - VALKEY_CA_PATH
  - VALKEY_SSL_KEYFILE
  - VALKEY_SSL_CERTFILE
  - VALKEY_CERT_REQS
  - VALKEY_CA_CERTS
  - VALKEY_CLUSTER_MODE
  - FASTMCP_LOG_LEVEL
env:
  VALKEY_HOST: "127.0.0.1"
  VALKEY_PORT: "6379"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

The official AWS Labs MCP server for Amazon ElastiCache and MemoryDB Valkey datastores. Provides full CRUD access to all major Valkey data types (Strings, Lists, Sets, Sorted Sets, Hashes, Streams, Bitmaps, JSON documents, HyperLogLog) via natural language. Supports standalone and clustered deployments, SSL/TLS, connection pooling, and an optional readonly mode to prevent accidental writes.

## Tools provided

- `string_*` - SET, GET, SETRANGE, GETRANGE, APPEND, INCR, DECR, STRLEN, and related string operations.
- `list_*` - LPUSH, RPUSH, LPOP, RPOP, LRANGE, LLEN, and other list management operations.
- `set_*` - SADD, SREM, SMEMBERS, SISMEMBER, SCARD, and set operations (union, intersect, diff).
- `zset_*` (Sorted Sets) - ZADD, ZRANGE, ZRANK, ZSCORE, ZREM, and leaderboard-style operations.
- `hash_*` - HSET, HGET, HMGET, HGETALL, HDEL, HEXISTS, HINCRBY, and hash field operations.
- `stream_*` - XADD, XREAD, XRANGE, XTRIM, and stream management operations.
- `bitmap_*` - SETBIT, GETBIT, BITCOUNT, BITOP bitwise operations on strings.
- `json_*` - JSON.SET, JSON.GET, JSON.DEL, JSON.ARRAPPEND with path-based access via JSONPath.
- `hyperloglog_*` - PFADD, PFCOUNT, PFMERGE for probabilistic cardinality counting.
- `key_*` - DEL, EXISTS, EXPIRE, TTL, SCAN, TYPE, and general key management.

## When to use

- Querying or updating data in an Amazon ElastiCache (Valkey) or MemoryDB cluster during development or debugging.
- Caching API responses, session state, or computed results in a Valkey-backed store.
- Managing leaderboards, activity streams, or real-time counters without writing raw Valkey commands.
- Storing and retrieving JSON documents or binary bitmap data alongside other Valkey data types.
- Inspecting live cluster state (key expiry, TTLs, type introspection) during incident response.

## Caveats

- **Connectivity**: The agent must be able to reach the Valkey host/port. For Amazon ElastiCache/MemoryDB, this typically requires running inside the same VPC or through a bastion/tunnel.
- **SSL/TLS**: ElastiCache and MemoryDB clusters enforce TLS in transit by default; set `VALKEY_USE_SSL=true` and supply the appropriate certificate env vars.
- **Authentication**: Set `VALKEY_USERNAME` and `VALKEY_PWD` for clusters with ACL/password auth enabled.
- **Cluster mode**: Set `VALKEY_CLUSTER_MODE=true` when connecting to a Valkey cluster (sharded) deployment.
- **Readonly mode**: Pass `--readonly` in `args` to disable all write tools; recommended for production clusters where only reads are needed.
- `uv` and Python 3.10+ must be installed locally; the server is fetched and run via `uvx`.

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Ensure the Valkey host is reachable from your machine (VPC, SSH tunnel, or local instance).
4. Set `VALKEY_HOST` and `VALKEY_PORT` to point at your ElastiCache Primary Endpoint, MemoryDB Cluster Endpoint, or local Valkey instance.
5. For TLS clusters (ElastiCache/MemoryDB default): set `VALKEY_USE_SSL=true` and configure cert vars as needed.
6. For authenticated clusters: set `VALKEY_USERNAME` and `VALKEY_PWD`.

## opencode.jsonc config

```jsonc
"aws-valkey": {
  "type": "local",
  "command": ["uvx", "awslabs.valkey-mcp-server@latest"],
  "env": {
    "VALKEY_HOST": "127.0.0.1",
    "VALKEY_PORT": "6379",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```

To enable readonly mode, add `"--readonly"` to the args:

```jsonc
"aws-valkey": {
  "type": "local",
  "command": ["uvx", "awslabs.valkey-mcp-server@latest", "--readonly"],
  "env": {
    "VALKEY_HOST": "your-cluster-endpoint",
    "VALKEY_PORT": "6379",
    "VALKEY_USE_SSL": "true",
    "VALKEY_USERNAME": "your-username",
    "VALKEY_PWD": "your-password",
    "VALKEY_CLUSTER_MODE": "true",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
