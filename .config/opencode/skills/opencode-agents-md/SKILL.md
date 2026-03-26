---
name: opencode-agents-md
description: Create a new AGENTS.md file at a project root by exploring the codebase and producing a dense, agent-useful living document. Use only when no AGENTS.md exists yet. This skill is for OpenCode (opencode.ai) only.
compatibility: opencode
---

## What I do

Explore the current project, synthesize what I find into a concise `AGENTS.md` file, and write it to the project root. The file is written as a living document — it contains instructions that tell future agents to update it directly, without reloading this skill.

## When to use me

Load this skill only when:
- The user explicitly asks to create an `AGENTS.md` file
- No `AGENTS.md` exists in the project root yet

**Do not load this skill if an `AGENTS.md` already exists.** Future agents reading that file will find embedded instructions telling them how to maintain it directly.

## Workflow

### 1. Check for an existing AGENTS.md

Look for `AGENTS.md` in the project root (nearest ancestor directory containing `.git`). If the file already exists, stop and tell the user: the file's own "Agent Instructions" section governs updates — no skill reload needed.

If the project root cannot be determined, ask the user for the project path before continuing.

### 2. Explore the codebase

Run targeted, efficient searches to answer these questions. Use parallel tool calls where possible. Do not read every file — read enough to be accurate.

**Stack and runtime:**
- What language(s) and runtime(s) are in use? (`package.json`, `go.mod`, `Cargo.toml`, `pyproject.toml`, `*.csproj`, etc.)
- What frameworks or major libraries are present?
- What build tooling and package manager?

**Structure:**
- What are the top-level directories and what does each contain?
- Where are entry points (main files, index files, CLI entrypoints)?
- Where do tests live and what test runner is used?

**Conventions:**
- What naming conventions are used for files, directories, functions, types?
- Is there a linter or formatter config? (`.eslintrc`, `biome.json`, `.prettierrc`, `rustfmt.toml`, etc.)
- Are there import path aliases or module resolution rules?

**Key patterns:**
- Are there notable architectural patterns (monorepo, layered arch, feature slices, domain modules)?
- Any shared utilities, base classes, or composables that agents should know about before writing new code?
- Any non-obvious gotchas — generated files, code that must not be edited, required pre-commit steps?

Only record what you confirmed by reading actual files. Do not speculate.

### 3. Draft AGENTS.md

Write sections based on what you discovered — do not use a fixed template. Sections should reflect what is actually useful and true for this codebase. Common sections include things like stack, structure, conventions, and key patterns — but only include a section if you have real content for it.

**Always include** an `## Agent Instructions` section as the first section after the project title. This is the self-update contract for all future agents.

Use this exact wording for the Agent Instructions section:

```markdown
## Agent Instructions

This is a living document. If you are an agent working in this project:
- Update this file when you discover new architectural facts, conventions, or patterns
- Remove entries that are no longer accurate
- Keep the file under 200 lines — prefer dense, useful facts over verbose explanations
- Do not reload the `opencode-agents-md` skill to make updates; edit this file directly
```

**Content rules:**
- Write to agents, not to human readers. Use imperative, direct language: "Tests live in `__tests__/`", not "The tests can be found in the tests directory."
- Prefer file paths, command snippets, and concrete examples over prose descriptions
- One fact per line where possible — scannable, not narrative
- No filler, no restating what is obvious from the directory structure alone
- Do not document things that are self-evident from reading any single file

### 4. Validate before writing

Check all of the following before saving:

- [ ] File is under 200 lines
- [ ] `## Agent Instructions` section is present and uses the exact wording above
- [ ] Every factual claim was confirmed by reading actual project files
- [ ] No placeholder text or template remnants remain
- [ ] No section is empty
- [ ] Content is written to agents, not human readers

If the draft exceeds 200 lines, cut the least useful content first: verbose prose, redundant examples, anything a competent agent could infer in one file read.

### 5. Write and report

Write the file to `<project-root>/AGENTS.md`.

Tell the user:
- The full path where the file was written
- A one-line summary of what was captured (e.g., "Captured TypeScript/Node stack, monorepo structure, ESLint+Prettier conventions, and 3 key patterns.")
- That future agents will maintain it automatically based on the embedded Agent Instructions
