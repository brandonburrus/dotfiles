---
name: opencode-create-command
description: Create a new OpenCode slash command by gathering requirements and writing a valid markdown command file (or JSON config entry) under ~/.config/opencode/commands/ or .opencode/commands/. This skill is for OpenCode (opencode.ai) only — do NOT use for GitHub Copilot.
compatibility: opencode
---

## What I do

Produce a complete, valid OpenCode command file that registers a `/command-name` shortcut in the TUI. The command file combines YAML frontmatter (description, agent, model, subtask) with a prompt body that can inject arguments, shell output, and file contents. Markdown files are the default format; JSON config entries are covered as an alternative.

## When to use me

Load this skill when:
- The user wants a reusable slash command for a repetitive task or prompt pattern
- The user wants to inject live context (git diff, test output, file contents) into a prompt automatically
- The user wants a per-project workflow shortcut (e.g. `/review`, `/deploy-check`, `/standup`)
- The user wants a parameterized prompt invoked with `/command arg1 arg2`
- The user wants to route a command to a specific agent or model

## Command anatomy

Every command is a markdown file in a `commands/` directory. The filename (without `.md`) becomes the command name, invoked as `/filename` in the TUI.

### File placement

| Scope | Path |
|---|---|
| Global (all projects) | `~/.config/opencode/commands/<name>.md` |
| Project-local | `.opencode/commands/<name>.md` |

Default to **global** placement unless the user explicitly asks for project-local or the command is clearly specific to one repository (e.g. references project-specific scripts or paths).

For project-local commands, resolve the project root as the nearest ancestor directory containing a `.git` file or folder. If it cannot be determined, ask the user for the project path.

### Naming

- Lowercase alphanumeric with hyphens as word separators (e.g. `review-diff`, `standup`, `explain`)
- The filename minus `.md` is the exact string the user types after `/`
- Names must be unique within their scope; project-local commands shadow global ones of the same name

### Frontmatter reference

```yaml
---
# Shown in TUI autocomplete when user types /; required
description: <short description of what the command does>

# Agent to run the command (optional — defaults to current active agent)
# Use any agent name: "build", "plan", or a custom agent filename without .md
agent: build

# Force the command to run as a subagent, isolating it from the main context (optional)
subtask: true

# Model override for this command (optional) — format: provider/model-id
model: anthropic/claude-sonnet-4-20250514
---
```

All fields except `description` are optional.

### Prompt body

The markdown body (everything after the closing `---`) is the prompt sent to the LLM when the command runs. It supports four special features:

#### Arguments

| Placeholder | Meaning |
|---|---|
| `$ARGUMENTS` | The entire string typed after the command name |
| `$1`, `$2`, `$3` ... | Individual positional arguments (space-separated) |

Example invocation: `/create-file config.json src` → `$1` = `config.json`, `$2` = `src`

Always validate `$ARGUMENTS` / `$1` at the top of the prompt if the command requires them — LLMs should stop and prompt the user if required args are missing.

#### Shell output injection

Use `` !`shell command` `` to run a bash command and inject its output inline into the prompt at execution time. Commands run from the project root.

```
Here is the current git diff:
!`git diff HEAD`
```

#### File references

Use `@path/to/file` to inject a file's contents into the prompt.

```
Review the following component: @src/components/Button.tsx
```

#### Combining features

All three features can be combined in a single prompt:

```
Reviewing changes for ticket $ARGUMENTS.

Recent commits:
!`git log --oneline -10`

Entry point: @src/index.ts
```

## Workflow

### 1. Gather requirements

Ask the user or infer from context:
- **Purpose** — what repetitive task or prompt pattern should this command encode?
- **Arguments** — does the command need user-supplied arguments (`$ARGUMENTS` / `$1 $2 ...`)? Are they required or optional?
- **Live context** — should the command inject shell output (test results, git diff, build logs)?
- **File references** — should it include specific file contents automatically?
- **Agent** — should the command run on a specific agent, or the current active one?
- **Subtask** — should the command run in an isolated subagent context (keeps main session clean)?
- **Model** — should the command use a specific model?
- **Scope** — global (all projects) or project-local?

Batch all questions into a single message. Do not ask one at a time.

### 2. Choose format

**Markdown file (default):** Write to `~/.config/opencode/commands/<name>.md` or `.opencode/commands/<name>.md`. Preferred — simpler, version-controllable, no config file editing required.

**JSON config entry (alternative):** Add to the `command` key in `opencode.json`. Use this when the user explicitly prefers centralized config or when there is no commands directory. The `template` field replaces the markdown body; escape newlines as `\n`.

```json
{
  "command": {
    "test": {
      "description": "Run tests with coverage",
      "template": "Run the full test suite with coverage report and show any failures.",
      "agent": "build"
    }
  }
}
```

### 3. Write the frontmatter

Include only the fields relevant to this command. `description` is always required — it appears in TUI autocomplete when the user types `/`.

Write the description to answer: *"Would a user scanning the autocomplete list immediately understand when to use this command?"* Keep it under 80 characters. Lead with an action verb.

### 4. Write the prompt body

The body is sent verbatim as the LLM prompt. Write it as a direct, task-focused instruction — not a question, not a preamble. The body should:

- **Start with the task.** Lead with what to do, not with setup.
- **Validate arguments early.** If the command requires `$ARGUMENTS`, check for empty/blank at the top and instruct the LLM to stop and ask the user if missing.
- **Use placeholders precisely.** Reference `$ARGUMENTS` or `$1`/`$2` exactly where the value belongs in the instruction.
- **Keep shell injections targeted.** Only inject the output needed; avoid injecting large blobs unnecessarily.
- **Be explicit about output format.** If the command should produce a specific structure (bullet list, table, code block), state it.

### 5. Validate before saving

Before writing the file, verify:
- [ ] `description` is present
- [ ] Filename is lowercase, hyphenated, no spaces — matches the intended `/command-name` exactly
- [ ] `agent` value matches an existing agent name (if specified)
- [ ] `$ARGUMENTS` / `$1` etc. are used in the body if the command requires arguments
- [ ] Shell commands in `` !`...` `` are safe to run automatically (read-only preferred for global commands)
- [ ] No placeholder text or unfilled template variables remain in the body
- [ ] The command does not already exist at the target path — check with `ls` before writing

### 6. Save and report

**Markdown file:** Write to the resolved path. Create the `commands/` directory if it does not exist.

After saving, tell the user:
- The full path where the file was written
- The exact invocation string (`/command-name` or `/command-name arg1 arg2`)
- The scope (global or project-local) and what that means for availability
- Whether a session restart is needed (new commands are typically available immediately, but confirm)

## Reference: existing command patterns

Use these as structural models when uncertain:

| Command | Good reference for |
|---|---|
| `read-docs.md` | `$ARGUMENTS` with explicit validation guard; multi-step procedural prompt |
| `remember.md` | Multi-step interactive prompt that calls tools; no arguments needed |
| `recall.md` | `$ARGUMENTS` passed directly to a tool; results presented then user prompted for next action |

## Examples

### Simple command — no arguments

A `/standup` command that generates a standup summary from recent git activity.

```markdown
---
description: Generate a standup summary from recent git commits
agent: build
subtask: true
---

Generate a concise daily standup summary based on recent activity.

Recent commits:
!`git log --oneline --since="24 hours ago" --author="$(git config user.name)"`

Format the summary as:
- **What I did:** bullet points from the commits above
- **What I'm doing next:** infer from the most recent commit or branch name
- **Blockers:** none unless something in the diff suggests a problem

Keep it brief — this is for a team standup, not a report.
```

---

### Command with `$ARGUMENTS` and validation guard

An `/explain` command that explains any technology, concept, or error message.

```markdown
---
description: Explain a concept, technology, or error message (e.g. /explain react suspense)
---

The user wants an explanation of: **$ARGUMENTS**

**Step 1 — Validate.**
If `$ARGUMENTS` is empty or blank, respond:
> "Please provide something to explain. Examples:
> - `/explain react suspense`
> - `/explain 'TypeError: cannot read property of undefined'`
> - `/explain CAP theorem`"
Then stop.

**Step 2 — Explain.**
Provide a clear, concise explanation of `$ARGUMENTS` targeted at an experienced developer.
- Lead with a one-sentence definition
- Follow with how it works, when to use it, and any gotchas
- Include a short code example if applicable
- Keep the total response under 400 words unless complexity demands more
```

---

### Command with shell output injection

A `/review-diff` command that reviews all uncommitted changes.

```markdown
---
description: Review all uncommitted changes for quality, bugs, and security issues
agent: plan
subtask: true
---

Review the following uncommitted changes for code quality, correctness, and potential issues.

Staged and unstaged diff:
!`git diff HEAD`

Focus on:
- **Correctness** — logic errors, edge cases, off-by-one errors
- **Security** — injection risks, hardcoded secrets, unsafe operations
- **Readability** — unclear names, missing comments on complex logic
- **Test coverage** — changes that lack corresponding test updates

Use severity labels: **[blocking]**, **[important]**, **[suggestion]**, **[praise]**.
End with a one-line verdict: approve / request changes / needs clarification.
```
