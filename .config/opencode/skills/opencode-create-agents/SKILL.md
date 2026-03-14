---
name: opencode-create-agents
description: Create a new OpenCode agent (primary or subagent) by gathering requirements, selecting the right mode, configuring tools and permissions, and writing a valid markdown agent file to the correct global or project path.
---

## What I do

Produce a complete, valid OpenCode agent markdown file with correct YAML frontmatter (mode, model, tools, permissions, temperature, color) and a high-quality system prompt body written to the agent's persona. This covers both primary agents (directly selectable by the user) and subagents (invoked programmatically or via `@` mention).

## When to use me

Load this skill when:
- The user wants to create a new custom agent for OpenCode
- The user wants to customize or extend the built-in `build` or `plan` agents
- The user needs a focused subagent for a specific domain (language, infrastructure, review, etc.)
- The user wants a hidden internal subagent invoked only by other agents via the Task tool
- The user wants to create an orchestrator agent that delegates to other subagents

## Agent anatomy

Every agent is a single markdown file. The filename (without `.md`) becomes the agent's name and identifier.

### File placement

| Scope | Path |
|---|---|
| Global (all projects) | `~/.config/opencode/agents/<name>.md` |
| Project-local | `.opencode/agents/<name>.md` |

Default to **global** placement unless the user explicitly asks for project-local or the agent is clearly specific to one codebase.

For project-local agents, resolve the project root as the nearest ancestor directory containing a `.git` file or folder. If it cannot be determined, ask the user for the project path.

### Naming conventions

- **Primary agents** → `_primary-<name>.md` — the leading underscore groups them at the top of the directory listing and signals they are primary-mode agents
- **Subagents** → `<name>.md` — plain lowercase hyphenated name

Both conventions use lowercase alphanumeric characters with hyphens as word separators. The filename (minus `.md`) is how users `@mention` the agent and how the Task tool invokes it.

### Frontmatter reference

All frontmatter fields are optional except `description`.

```yaml
---
# Required
description: <1–1024 character description of what the agent does and when to use it>

# Agent mode — "primary", "subagent", or "all" (default: "all")
mode: subagent

# Override display name (defaults to filename without .md)
name: My Agent

# Model override — format: provider/model-id
model: anthropic/claude-sonnet-4-20250514

# Response randomness — 0.0 (deterministic) to 1.0 (creative)
temperature: 0.3

# Top-p sampling — alternative to temperature
top_p: 0.9

# Max agentic iterations before forcing a text-only response
steps: 20

# Hex color or theme color: primary, secondary, accent, success, warning, error, info
color: "#49c0b6"

# Hide from @ autocomplete (subagents only) — still invokable via Task tool
hidden: false

# Disable this agent entirely
disable: false

# Tool access — true/false per tool name; agent-level overrides global config
tools:
  read: true
  glob: true
  grep: true
  write: true
  edit: true
  bash: true
  webfetch: true
  websearch: true
  question: true

# Permissions — "allow", "ask", or "deny" per tool
# For bash: can be a string or a map of glob patterns to rules
# Last matching rule wins — put catch-all "*" first, specifics after
permission:
  read: allow
  write: allow
  edit: allow
  webfetch: allow
  bash:
    "*": ask
    "git status *": allow
    "git log *": allow
    "git diff *": allow
  task:
    "*": allow     # which subagents this agent can invoke via Task tool

---
```

### Permission quick reference

| Scenario | Pattern |
|---|---|
| Full read-only (no writes, no bash) | `permission: { write: deny, edit: deny, bash: { "*": deny } }` |
| Bash with safe read commands only | `bash: { "*": deny, "cat *": allow, "ls *": allow, "grep *": allow, "rg *": allow }` |
| Bash: ask for everything except git reads | `bash: { "*": ask, "git log *": allow, "git diff *": allow, "git status *": allow }` |
| Orchestrator: restrict which subagents can be invoked | `task: { "*": deny, "my-agent-*": allow }` |

## Workflow

### 1. Gather requirements

Ask the user or infer from context:
- **Mode** — primary (user selects directly, cycles with Tab) or subagent (invoked via `@` or Task tool)?
- **Domain** — what is the agent's specialty or purpose?
- **Tools needed** — does it need to write/edit files? Run bash commands? Fetch the web?
- **Read-only vs read-write** — reviewers and auditors should deny writes; implementers need writes
- **Model override** — should this use a different model than the default?
- **Color** — does the user want a specific color for the agent's UI display? (primary agents especially)
- **Hidden** — should this subagent be hidden from `@` autocomplete (internal-only)?
- **Scope** — global (all projects) or project-local?

Batch all questions into a single message. Do not ask one at a time.

### 2. Choose mode and configure permissions

**Primary agents** (`mode: primary`):
- Selectable by the user via Tab key
- Typically given a `name`, `color`, and explicit `tools` list
- Common patterns:
  - *Full build*: all tools allow, bash ask for dangerous commands
  - *Read-only planner*: write/edit deny, bash deny or heavily restricted
  - *Orchestrator*: write/edit/bash deny, task permissions set to control subagent access

**Subagents** (`mode: subagent`):
- Invoked by primary agents via Task tool, or manually via `@mention`
- Do not need `color` (optional) or `name` override (use filename)
- Read-only subagents: `write: deny`, `edit: deny`, bash restricted to safe read commands
- Implementation subagents: `write: allow`, `edit: allow`, bash restricted to relevant build/test commands
- Hidden internal agents: add `hidden: true`

### 3. Write the frontmatter

Include only the fields relevant to this agent — do not add fields with no-op defaults. Minimum required fields:
- `description` (required)
- `mode` (required for clarity; defaults to `all` if omitted)

Add `name`, `color`, and `temperature` for primary agents. Add `hidden: true` for internal-only subagents.

Write the `description` to answer the question: *"Would the Task tool or a user correctly load this agent for the right task?"* Start with the agent's role, then list the key behaviors or restrictions. Under 150 characters is ideal.

### 4. Write the system prompt body

The markdown body (after the closing `---`) is the agent's system prompt. Write it **to the agent** — use "you", "your role", "you must", not "the agent should".

A high-quality system prompt includes:

- **Role statement** — one sentence declaring who the agent is and its primary job
- **Core principles** — 3–7 bullet points or rules the agent must always follow
- **Process or checklist** — numbered steps if the agent follows a defined workflow
- **Output format** — if the agent produces structured output (reviews, reports, plans), define the format
- **Behavioral rules** — what the agent must never do (e.g., "never modify code directly", "never commit without asking")

Match depth to complexity. A simple domain expert needs 20–40 lines. An orchestrator or multi-phase agent may need 80–120 lines.

### 5. Validate before saving

Before writing the file, verify:
- [ ] Filename (without `.md`) matches the intended agent identifier; primary agents use `_primary-<name>.md`
- [ ] `description` is present and under 150 characters
- [ ] `mode` is explicitly set
- [ ] `permission` rules use the correct format; `bash` wildcards use `"*"` first if mixing with specifics
- [ ] `tools` list does not enable tools whose permissions are `deny` (conflicting config)
- [ ] The body is written **to the agent**, not to the user
- [ ] No empty sections or placeholder text remain
- [ ] The agent does not duplicate an existing agent — check `~/.config/opencode/agents/` first

### 6. Save and report

**Global agent:** Write to `~/.config/opencode/agents/<name>.md`.

**Project-local agent:** Write to `<project-root>/.opencode/agents/<name>.md`. Create the directory if it does not exist.

After saving, tell the user:
- The full path where the file was written
- The mode (primary or subagent) and how to invoke it (Tab to cycle / `@name` to mention)
- The scope (global or project-local) and what that means for discoverability
- That a session restart may be needed for the agent to appear

## Reference: existing agent patterns

Use these as structural models when uncertain about format or depth:

| Agent | Mode | Good reference for |
|---|---|---|
| `_primary-assistant.md` | Primary | Read-only primary with fine-grained bash allow/deny patterns |
| `_primary-vibe.md` | Primary | Permissive primary with full tool access; minimal body |
| `_primary-swarm.md` | Primary | Orchestrator with task permissions; detailed behavioral rules |
| `_primary-debug.md` | Primary | Analytical primary with selective bash; structured output format |
| `react-developer.md` | Subagent | Language developer subagent with build/test tool access |
| `code-reviewer.md` | Subagent | Read-only subagent with severity-labeled output format |
| `architect.md` | Subagent | Advisory read-only subagent with structured design output |

## Examples

### Minimal read-only subagent

```markdown
---
description: Audits dependency files for outdated or vulnerable packages. Read-only.
mode: subagent
temperature: 0.2
permission:
  write: deny
  edit: deny
  bash:
    "*": deny
    "cat *": allow
    "ls *": allow
    "find *": allow
    "npm outdated": allow
    "npm audit": allow
---

You are a dependency auditor. Your job is to identify outdated and vulnerable packages across the project.

## Process

1. Locate all `package.json`, `requirements.txt`, `go.mod`, `Cargo.toml`, or similar dependency files
2. Read each file and note declared dependency versions
3. Run `npm audit` or equivalent if available; otherwise reason from the versions you find
4. Report findings grouped by severity: **critical**, **high**, **medium**, **low**

## Output Format

For each issue:
- **Package**: name and current version
- **Severity**: critical / high / medium / low
- **Issue**: what is outdated or vulnerable
- **Recommendation**: upgrade to version X, or replace with Y

Never modify files. Never install packages. Report only.
```

---

### Minimal primary agent

```markdown
---
name: Review
description: Interactive code review agent — reads diffs and files, provides structured feedback, never modifies code
mode: primary
color: "#7264ce"
temperature: 0.2
permission:
  write: deny
  edit: deny
  bash:
    "*": deny
    "git diff *": allow
    "git log *": allow
    "git show *": allow
    "git blame *": allow
    "git status *": allow
    "cat *": allow
    "ls *": allow
    "rg *": allow
---

You are a code reviewer. Your role is to provide thorough, constructive feedback. You never modify code — you read, analyze, and advise.

## Review Focus

- **Correctness** — Does the code do what it claims? Are edge cases handled?
- **Design** — Does this belong here? Is the abstraction level right?
- **Readability** — Are names clear? Is the intent obvious?
- **Security** — Input validation, injection risks, secret handling
- **Performance** — Obvious O(n²) patterns, N+1 queries, unnecessary re-computation

## Feedback Format

Use severity labels on every comment:
- **[blocking]** — must fix before merge
- **[important]** — should fix; significant quality issue
- **[suggestion]** — nice to have; not critical
- **[praise]** — something done well

End each review with: overall verdict, count of blocking/important issues, and approve / request changes / needs clarification.

## Rules

- Never write or edit files
- Reference exact file names and line numbers in all feedback
- Ask a clarifying question when intent is genuinely unclear — don't assume the code is wrong
```
