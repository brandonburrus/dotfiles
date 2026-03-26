---
name: opencode-create-plugin
description: Create a new OpenCode plugin by gathering requirements, choosing the right placement and hook strategy, writing a valid JS/TS plugin file with typed exports, and registering dependencies as needed. This skill is for OpenCode (opencode.ai) only — do NOT use for GitHub Copilot hooks; use rsg-create-hook instead.
compatibility: opencode
---

## What I do

Produce a complete, working OpenCode plugin file — JavaScript or TypeScript — with the correct named export structure, properly typed hooks, and any required `package.json` dependencies. Covers local file plugins, global file plugins, and npm-published plugins. Includes all event categories: tool interception, session lifecycle, shell environment injection, custom tools, TUI control, and compaction hooks.

## When to use me

Load this skill when:
- The user wants to hook into OpenCode events (session start/end, tool calls, file edits, permissions, etc.)
- The user wants to intercept or modify tool arguments before/after execution
- The user wants to add custom tools available to the AI alongside built-in tools
- The user wants to inject environment variables into all shell sessions
- The user wants to send notifications, log structured data, or integrate with external services
- The user wants to customize or replace the session compaction prompt
- The user wants to protect sensitive files (e.g. `.env`) from being read by the AI
- The user wants to publish a plugin to npm for others to use

## Plugin anatomy

A plugin is a **JavaScript or TypeScript file** placed in a plugins directory, or an npm package listed in `opencode.json`. It exports one or more named async functions. Each function receives a context object and returns a hooks object.

### File placement

| Scope | Path | When to use |
|---|---|---|
| **Global** (all projects) | `~/.config/opencode/plugins/<name>.ts` | Default — use for most plugins |
| **Project-local** | `.opencode/plugins/<name>.ts` | Only when plugin references project-specific paths, secrets, or scripts |
| **npm package** | Listed in `opencode.json` `plugin` array | When publishing for others or managing via package registry |

Default to **global** placement unless the user explicitly asks for project-local, or the plugin is clearly tied to a specific repository (e.g. reads a project `.env`, runs a project-specific build script, or references hardcoded project paths).

For project-local plugins, resolve the project root as the nearest ancestor directory containing a `.git` file or folder from the current working directory. If it cannot be determined, ask the user for the project path.

### Registering an npm plugin

Add the package name to the `plugin` array in `opencode.json`. OpenCode installs it automatically via Bun at startup:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["opencode-wakatime", "@my-org/custom-plugin"]
}
```

npm plugins and their dependencies are cached in `~/.cache/opencode/node_modules/`.

### Basic structure

```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const MyPlugin: Plugin = async ({ project, client, $, directory, worktree }) => {
  // Initialization code runs once at startup

  return {
    // Hook implementations go here
  }
}
```

The plugin function receives:

| Parameter | Type | Description |
|---|---|---|
| `project` | object | Current project information |
| `directory` | string | Current working directory |
| `worktree` | string | Git worktree path |
| `client` | object | OpenCode SDK client for interacting with the AI and server |
| `$` | function | Bun's shell API for executing commands |

### TypeScript support

Always prefer TypeScript (`.ts` extension) for new plugins. Import the `Plugin` type from `@opencode-ai/plugin` for full type safety on all hooks and event payloads:

```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const MyPlugin: Plugin = async (ctx) => {
  return {
    // All hook names and signatures are type-checked
  }
}
```

For custom tools, also import the `tool` helper:

```typescript
import { type Plugin, tool } from "@opencode-ai/plugin"
```

### JavaScript (no types)

Use `.js` when the user prefers JavaScript or explicitly avoids TypeScript:

```javascript
export const MyPlugin = async ({ project, client, $, directory, worktree }) => {
  return {
    // hooks
  }
}
```

---

## Available events

Hook names are keys in the returned object. Misspelled hook names silently do nothing — always use the exact names below.

### Tool events
- `tool.execute.before` — fires before any tool runs; can modify args or throw to block execution
- `tool.execute.after` — fires after a tool completes; can inspect results

### Session events
- `session.created` — new session opened
- `session.updated` — session metadata changed
- `session.deleted` — session removed
- `session.idle` — AI finished responding (useful for notifications)
- `session.status` — session status changed
- `session.error` — session encountered an error
- `session.diff` — file diff produced during session
- `session.compacted` — session was compacted

### Shell events
- `shell.env` — fires when a shell environment is prepared; inject env vars here

### Compaction hooks (experimental)
- `experimental.session.compacting` — fires before the LLM generates a continuation summary; modify `output.context` to inject extra context, or set `output.prompt` to replace the entire compaction prompt

### Command events
- `command.executed` — a slash command was executed

### File events
- `file.edited` — a file was edited
- `file.watcher.updated` — the file watcher detected a change

### Message events
- `message.updated` — a message was updated
- `message.removed` — a message was removed
- `message.part.updated` — a message part was updated
- `message.part.removed` — a message part was removed

### Permission events
- `permission.asked` — OpenCode is requesting permission for an action
- `permission.replied` — a permission request was answered

### LSP events
- `lsp.client.diagnostics` — LSP diagnostics received
- `lsp.updated` — LSP state updated

### Todo events
- `todo.updated` — todo list was updated

### TUI events
- `tui.prompt.append` — text was appended to the TUI prompt
- `tui.command.execute` — a command was executed in the TUI
- `tui.toast.show` — a toast notification was shown

### Server / installation events
- `server.connected` — server connection established
- `installation.updated` — installation state changed

---

## Dependencies

Local plugins can import external npm packages. Add a `package.json` to the **same config directory** as the plugin (not the plugin directory itself):

| Plugin location | `package.json` location |
|---|---|
| `~/.config/opencode/plugins/` | `~/.config/opencode/package.json` |
| `.opencode/plugins/` | `.opencode/package.json` |

```json
{
  "dependencies": {
    "shescape": "^2.1.0"
  }
}
```

OpenCode runs `bun install` automatically at startup. The plugin can then import the package normally:

```typescript
import { escape } from "shescape"
```

Only add a `package.json` when the plugin imports packages that are not built into Bun or Node. Standard built-ins (`fs`, `path`, `crypto`, etc.) and Bun globals (`$`, `fetch`, etc.) do not require `package.json` entries.

---

## Workflow

### 1. Gather requirements

Ask the user or infer from context:
- **Purpose** — what should the plugin do? What event or behavior should it respond to?
- **Hook(s) needed** — which events from the list above are relevant?
- **Scope** — global (all projects) or project-local? Default to global.
- **Language** — TypeScript (default) or JavaScript?
- **Dependencies** — does the plugin need any external npm packages?
- **Custom tools** — should the plugin register new tools the AI can call?
- **Plugin name** — what should the exported function and file be called?

Batch all questions into a single message. Do not ask one at a time.

### 2. Choose placement

Apply the placement rules from the Plugin anatomy section:
- **Global** (`~/.config/opencode/plugins/`) for most plugins
- **Project-local** (`.opencode/plugins/`) only for project-specific plugins
- **npm** only when the user is publishing or managing via registry

### 3. Handle dependencies

If the plugin imports any external packages:
1. Check whether `package.json` exists at the config directory level
2. If not, create it with the required dependencies
3. If it exists, add the new dependencies to the existing file
4. Note that `bun install` runs automatically — no manual step needed

### 4. Write the plugin

Structure the plugin file:
1. **Imports** — `Plugin` type and `tool` helper if needed; any external package imports
2. **Named export** — `export const <PluginName>: Plugin = async (ctx) => { ... }`
   - Use a descriptive PascalCase name matching the file's purpose (e.g. `EnvProtection`, `NotificationPlugin`)
   - The export must be **named**, not default
3. **Initialization block** — any setup code that runs once (logging, connecting to services)
4. **Returned hooks object** — keys are event names from the Available events section

For `tool.execute.before` and `tool.execute.after`, the signature is:
```typescript
"tool.execute.before": async (input, output) => {
  // input.tool — name of the tool being called (e.g. "read", "bash", "edit")
  // output.args — the tool's arguments (mutable)
  // throw an Error to block execution
}
```

For `shell.env`:
```typescript
"shell.env": async (input, output) => {
  // input.cwd — current working directory
  // output.env — environment variables object (mutable)
  output.env.MY_VAR = "value"
}
```

For custom tools, use the `tool` helper:
```typescript
tool: {
  mytool: tool({
    description: "What the tool does",
    args: {
      param: tool.schema.string(),
    },
    async execute(args, context) {
      return `result`
    },
  }),
},
```

### 5. Validate before saving

Before writing the file, verify:
- [ ] Export is a **named** async function — not `export default`
- [ ] The function **returns** an object with hook keys (not void)
- [ ] All hook names exactly match the canonical names in the Available events section
- [ ] TypeScript files use `Plugin` type on the exported function
- [ ] If `tool` helper is used, it is imported from `@opencode-ai/plugin`
- [ ] External package imports have a corresponding `package.json` entry
- [ ] No placeholder text or TODO comments remain in the plugin body
- [ ] Plugin name (PascalCase export) is descriptive and unique

### 6. Save and report

Create the directory if it does not exist, then write the file.

After saving, tell the user:
- The full path where the file was written
- The scope (global or project-local) and what that means
- Whether a `package.json` was created or updated
- The event(s) the plugin hooks into and what it does
- That a session restart is required for the plugin to load

---

## Common patterns

### Notifications on session idle (macOS)

```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const NotificationPlugin: Plugin = async ({ $ }) => {
  return {
    "session.idle": async () => {
      await $`osascript -e 'display notification "Session completed!" with title "opencode"'`
    },
  }
}
```

### Block reads of `.env` files

```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const EnvProtection: Plugin = async () => {
  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool === "read" && output.args.filePath?.includes(".env")) {
        throw new Error("Do not read .env files")
      }
    },
  }
}
```

### Inject environment variables into all shells

```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const InjectEnvPlugin: Plugin = async () => {
  return {
    "shell.env": async (input, output) => {
      output.env.MY_API_KEY = "secret"
      output.env.PROJECT_ROOT = input.cwd
    },
  }
}
```

### Add a custom tool

```typescript
import { type Plugin, tool } from "@opencode-ai/plugin"

export const CustomToolsPlugin: Plugin = async () => {
  return {
    tool: {
      greet: tool({
        description: "Greet a person by name",
        args: {
          name: tool.schema.string(),
        },
        async execute(args) {
          return `Hello, ${args.name}!`
        },
      }),
    },
  }
}
```

### Structured logging via SDK client

```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const LoggingPlugin: Plugin = async ({ client }) => {
  await client.app.log({
    body: { service: "my-plugin", level: "info", message: "Plugin initialized" },
  })

  return {
    "session.created": async () => {
      await client.app.log({
        body: { service: "my-plugin", level: "info", message: "Session started" },
      })
    },
  }
}
```

Use `client.app.log()` instead of `console.log` for structured, level-tagged output. Valid levels: `debug`, `info`, `warn`, `error`.

### Inject context into session compaction

```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const CompactionPlugin: Plugin = async () => {
  return {
    "experimental.session.compacting": async (input, output) => {
      output.context.push(`## Persistent State
- Current task: <describe>
- Files actively being modified: <list>
- Key decisions made: <list>`)
    },
  }
}
```

To replace the entire compaction prompt instead of appending context, set `output.prompt` — this overrides `output.context` entirely:

```typescript
output.prompt = `Summarize the session for a new agent to resume work.
Include: current task, modified files, blockers, and next steps.`
```
