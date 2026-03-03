---
name: mcp-setup-instruction
description: Create a new MCP instruction file in the global catalog at ~/.config/opencode/mcp/ — use this when adding a new MCP server to the catalog so it can be installed into projects via the install-mcp skill
---

## What I do

Research an MCP server and produce a well-formed instruction file at
`~/.config/opencode/mcp/<name>.md`. The instruction file acts as the catalog
entry for the server — it is what `install-mcp` reads to install the server
into a project's `opencode.jsonc`.

## When to use me

Load this skill when:
- The user wants to add a new MCP server to the global catalog
- The user provides a GitHub URL, npm package name, README, or server name to document
- A just-installed server needs a catalog entry for future projects

## Workflow

### 1. Gather source material

If the user provides a URL (README, GitHub repo, npm page), fetch it with
WebFetch. If only a package name or server name is given, construct the likely
README URL:
- npm package `foo-mcp` → `https://raw.githubusercontent.com/<org>/<repo>/main/README.md`
  or fall back to `https://www.npmjs.com/package/foo-mcp`
- GitHub repo URL → append `/blob/main/README.md` or fetch raw

Skim for:
- Package name / install command
- Server type: `local` (stdio, launched by the client) vs `remote` (HTTP/SSE URL)
- Authentication method: API key env var, OAuth, header token, or none
- Complete tool list with descriptions
- Configuration options (flags, env vars)
- Prerequisites and setup steps

### 2. Determine the frontmatter

Choose values for each frontmatter field:

| Field | When to include |
|---|---|
| `name` | Always — lowercase, hyphenated, matches filename (e.g. `chrome-devtools`) |
| `type` | Always — `local` or `remote` |
| `command` | Local only — full array: `["npx", "-y", "pkg@latest"]` or `["uvx", "pkg"]` or `["binary"]` |
| `url` | Remote only — full HTTPS URL to the MCP endpoint |
| `oauth` | Remote only, when OAuth is used — set to `true` |
| `requires_env` | When env vars MUST be set for the server to work at all |
| `optional_env` | When env vars improve behavior but are not mandatory |
| `env` | Local only, when the process needs specific env vars injected — map of `VAR: "{env:KEY}"` |

**Command patterns by ecosystem:**
- npm package: `["npx", "-y", "package-name@latest"]`
- Python package (uv): `["uvx", "package-name@latest"]`
- Globally installed binary: `["binary-name"]`
- Local script: `["node", "/path/to/server.js"]`

### 3. Write the file

Create `~/.config/opencode/mcp/<name>.md` with exactly this structure:

```markdown
---
name: <name>
type: local | remote
# local:
command: ["npx", "-y", "package@latest"]
# remote:
url: "https://..."
# remote + oauth:
oauth: true
requires_env:
  - KEY_NAME
optional_env:
  - KEY_NAME
env:
  PROCESS_VAR: "{env:KEY_NAME}"
---

## Description

<2-4 sentences: what the server does, who made it, what it's built on>

## Tools provided

<List all tools. Group under bold subheadings if there are 6+ tools.>
<Each tool: backtick name — short description>

## When to use

<3-6 bullets: concrete situations where this server provides value>

## Caveats

<Important limits, gotchas, cost warnings, permissions needed, or token
 bloat concerns. Omit section if there are genuinely no caveats.>

## Setup

<Step-by-step instructions: install prerequisites, obtain keys, configure env.
 Show exact lines to add to ~/.config/opencode/opencode.env where needed.>

## opencode.jsonc config

<The minimal working config block. Add variant blocks (headless, isolated,
 alternative flags, etc.) only if they are meaningfully different use-cases.>
```

### 4. Section-writing guidelines

**Description**
- Identify the author/org ("The official X MCP server from Y")
- Name the underlying technology if notable (Puppeteer, Playwright, AWS SDK, etc.)
- One sentence on the primary use-case

**Tools provided**
- Use flat list for <6 tools; bold subheadings for larger sets
- Be specific: `navigate_page — navigate to a URL` not `navigate_page — navigation`
- List optional/experimental tools separately and note how to enable them

**When to use**
- Write from the agent's perspective ("when you need to…", "for debugging…")
- Contrast against alternatives when relevant (e.g. Playwright vs chrome-devtools)

**Caveats**
- Telemetry/data collection — note opt-out flag if one exists
- Token budget impact — call out servers that add many tools to context
- Permissions — note sensitive capabilities (full browser content, write access, etc.)
- Runtime dependencies — Docker, Java, specific Node/Python version, etc.
- Cost warnings — APIs that charge per call

**Setup**
- Number the steps
- Show exact shell commands
- For API keys: link to where to obtain them
- For env vars: show the exact line to add to `~/.config/opencode/opencode.env`

**opencode.jsonc config**
- Always show the minimal working config first
- Add named variants as separate fenced blocks only when the variant represents a
  materially different deployment mode (headless, isolated session, slim mode,
  read-only, connecting to existing instance, etc.)
- For local servers with optional env, show variant with `environment` block
- Configs must be self-contained — no placeholder values without comments
  explaining what to substitute

### 5. Quality checks before saving

- `name` in frontmatter matches the filename (without `.md`)
- `type` is exactly `local` or `remote`
- `command` is a JSON array, not a string
- All tools from the README are listed (don't summarize — enumerate)
- No sections are empty or contain placeholder text
- `opencode.jsonc config` blocks are valid JSONC (no trailing commas, comments OK)
- Caveats section covers telemetry if the server collects usage data

## Reference examples

Three representative patterns from the catalog:

**Local, no auth** (`playwright.md`):
```yaml
name: playwright
type: local
command: ["npx", "@playwright/mcp@latest"]
requires_env: []
```

**Local, required env + optional env + env map** (`aws-dynamodb.md`):
```yaml
name: aws-dynamodb
type: local
command: ["uvx", "awslabs.dynamodb-mcp-server@latest"]
requires_env:
  - AWS_REGION
optional_env:
  - AWS_PROFILE
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "ERROR"
```

**Remote, auth header** (`github.md`):
```yaml
name: github
type: remote
url: "https://api.githubcopilot.com/mcp/"
requires_env:
  - GITHUB_TOKEN
```
opencode.jsonc uses `"headers": { "Authorization": "Bearer {env:GITHUB_TOKEN}" }`

**Remote, OAuth** (`sentry.md`):
```yaml
name: sentry
type: remote
url: "https://mcp.sentry.dev/mcp"
oauth: true
requires_env: []
```
opencode.jsonc uses `"oauth": {}`

**Remote, optional key** (`context7.md`):
```yaml
name: context7
type: remote
url: "https://mcp.context7.com/mcp"
optional_env:
  - CONTEXT7_API_KEY
```
opencode.jsonc shows variant with `"headers": { "CONTEXT7_API_KEY": "{env:CONTEXT7_API_KEY}" }`
