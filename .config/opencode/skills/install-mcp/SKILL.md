---
name: install-mcp
description: Install an MCP server from the global catalog into the current project's .opencode/opencode.jsonc
---

## What I do

Guide the full workflow for installing an MCP server from the global catalog at
`~/.config/opencode/mcp/` into the **current project's**
`.opencode/opencode.jsonc` (i.e. in `context.worktree`).

MCP servers are always installed at the project level, not globally. This
keeps tool context scoped to where it's actually needed.

## Workflow

### 1. Read the catalog file

Read `~/.config/opencode/mcp/<name>.md`. Parse the YAML frontmatter to extract:
- `type` — `local` or `remote`
- `command` — array of command + args (local only)
- `url` — server URL (remote only)
- `oauth` — present and `true` if OAuth is used
- `requires_env` — list of env var names that must be set before install
- `optional_env` — list of env var names that improve behavior if set
- `env` — map of environment variable names to their `{env:KEY}` references
  (used in the `environment` block for local servers)

If the file doesn't exist, list the available catalog files in
`~/.config/opencode/mcp/` and tell the user which names are valid.

### 2. Notify about required env vars

If `requires_env` is non-empty, tell the user:
- Which keys are required
- That each key must be set in `~/.config/opencode/opencode.env` before
  OpenCode can use the server (refer them to the catalog file's Setup section
  for where to obtain each value)
- The exact lines to add, e.g. `KEY_NAME=your_value_here`

Do **not** read or inspect `opencode.env` — assume the user has already set
things up correctly, or will do so before restarting OpenCode. Continue with
the install regardless.

### 3. Locate the project config

The target config file is `.opencode/opencode.jsonc` relative to the current
project root (git worktree). If `.opencode/` does not exist, create it. If
`.opencode/opencode.jsonc` does not exist, create it with this minimal
skeleton:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
  }
}
```

### 4. Check for existing entry

Read `.opencode/opencode.jsonc`. If an entry with the same name already exists
under `"mcp"`, tell the user it is already installed and show the current
config. Ask if they want to overwrite it. If no, stop.

### 5. Build the config block

Construct the JSON object for the new MCP entry based on `type`:

**Remote without OAuth:**
```jsonc
"<name>": {
  "type": "remote",
  "url": "<url>"
}
```

**Remote with headers (optional env vars exist in the catalog frontmatter):**
```jsonc
"<name>": {
  "type": "remote",
  "url": "<url>",
  "headers": {
    "KEY_NAME": "{env:KEY_NAME}"
  }
}
```

**Remote with OAuth:**
```jsonc
"<name>": {
  "type": "remote",
  "url": "<url>",
  "oauth": {}
}
```

**Local:**
```jsonc
"<name>": {
  "type": "local",
  "command": [<command array>],
  "environment": {
    "ENV_VAR_NAME": "{env:KEY_NAME}"
  }
}
```

Only include the `environment` block if `env` is non-empty in the frontmatter.
Only include `headers` if `optional_env` is non-empty in the frontmatter.

### 6. Write to .opencode/opencode.jsonc

Add the new entry to the `"mcp"` block in `.opencode/opencode.jsonc`. Preserve
all existing entries, comments, and formatting.

### 7. Post-install instructions

After writing the config, tell the user:

- The server was added as `"<name>"` in `.opencode/opencode.jsonc`
- **If OAuth:** Run `opencode mcp auth <name>` to authenticate
- **If local or remote with env vars:** Remind the user that any required or
  optional keys must be set in `~/.config/opencode/opencode.env`. If they
  haven't already sourced that file in their shell, they should add:
  ```sh
  source ~/.config/opencode/opencode.env
  ```
  to `~/.zshrc`, then restart OpenCode for the server to be picked up.
- **If remote, no auth:** Restart OpenCode for the server to be picked up
- Show the exact config block that was written

## Adding new catalog entries

To add a new MCP server to the catalog, create
`~/.config/opencode/mcp/<name>.md` with this structure:

```markdown
---
name: <name>
type: local | remote
# local only:
command: ["npx", "-y", "package-name"]
# remote only:
url: "https://..."
# if OAuth:
oauth: true
# env vars that MUST be set before install:
requires_env:
  - KEY_NAME
# env vars that improve behavior but aren't required:
optional_env:
  - KEY_NAME
# map of env var name in the process to the {env:} reference (local servers):
env:
  PROCESS_VAR_NAME: "{env:KEY_NAME}"
---

## Description
...

## Tools provided
...

## When to use
...

## Caveats
...

## Setup
Instructions for getting API keys, tokens, etc.
Add to `~/.config/opencode/opencode.env`:
  KEY_NAME=value_here

## opencode.jsonc config
The exact JSON block that gets written (for reference).
```
