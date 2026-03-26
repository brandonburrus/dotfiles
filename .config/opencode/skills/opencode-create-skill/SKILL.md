---
name: opencode-create-skill
description: Create a new OpenCode skill (SKILL.md) by gathering requirements, selecting the right structural pattern, and writing valid frontmatter and placement under ~/.config/opencode/skills/ or .opencode/skills/. This skill is for OpenCode (opencode.ai) only — do NOT use for GitHub Copilot skills; use rsg-create-skill instead.
compatibility: opencode
---

## What I do

Research the user's intent and produce a complete, well-formed `SKILL.md` file that is immediately discoverable and usable by OpenCode. This includes writing valid YAML frontmatter, selecting the right structural pattern for the skill's purpose, writing clear agent-facing instructions, and placing the file at the correct path.

## When to use me

Load this skill when:
- The user wants to create a new reusable skill for OpenCode
- A repeated workflow or output pattern needs to be codified for future sessions
- An existing skill needs to be restructured to follow the correct format

## Skill anatomy

Every skill is a single `SKILL.md` file inside a named directory. The file must begin with YAML frontmatter followed by the skill's instructional content, written to the agent (not to the user).

### File placement

| Scope | Path |
|---|---|
| Global (available in all projects) | `~/.config/opencode/skills/<name>/SKILL.md` |
| Project-local | `.agents/skills/<name>/SKILL.md` |

Default to **global** placement unless the user explicitly asks for a project-local skill or the skill is clearly specific to one project. For project-local skills, resolve the project root as the nearest ancestor directory containing a `.git` file or folder from the current working directory; if that cannot be determined, ask the user for the project path.

### Frontmatter

Every `SKILL.md` must begin with this block:

```yaml
---
name: <skill-name>
description: <1–1024 character description>
---
```

Optional fields: `license`, `compatibility`, `metadata` (string-to-string map).

**Name rules:**
- 1–64 characters
- Lowercase alphanumeric with single hyphens as word separators
- Must not start or end with `-`
- Must not contain `--`
- Must exactly match the directory name that contains the `SKILL.md`
- Valid regex: `^[a-z0-9]+(-[a-z0-9]+)*$`

**Description rules:**
- 1–1024 characters; aim for under 200 in practice
- This is what the agent reads to decide whether to load the skill — write it to be specific and unambiguous
- Start with a verb: "Create", "Write", "Search", "Install", "Generate"
- Specify what the skill produces or does and the key trigger condition

### Structural patterns

Two patterns cover the full range of existing skills. Choose one before writing.

```markdown
## What I do
<1–3 sentences: the skill's scope and output>

## When to use me
<bullet list of trigger conditions>

## Workflow

### 1. Step name
<instructions>

### 2. Step name
<instructions>
```

**Style/output pattern** — use when the skill defines how something should be written, designed, or structured (document style guides, coding standards, UI design systems):

```markdown
## Purpose
<1–2 sentences>

## Structure or Document Arc
<format specification, section descriptions, or output arc>

## Tone and Voice / Design Principles / Standards
<rules and guidelines>

## When to Use This Skill
<bullet list>

## When NOT to Use This Skill
<bullet list, with pointers to alternative skills where relevant>
```

A hybrid is acceptable when the skill has both a defined process and output quality standards. Lead with the workflow sections, follow with the quality standards.

## Workflow

### 1. Gather requirements

Ask the user or infer from context:
- What does this skill do? What artifact or behavior does it produce?
- When should an agent load it? What are the trigger conditions?
- Is it primarily process-oriented (workflow pattern) or output-quality-oriented (style/output pattern)?
- Should it be **global** (available in every project, saved to `~/.config/opencode/skills/`) or **project-local** (this project only, saved to `.agents/skills/` inside the project)? Default to global unless told otherwise.
- Does it reference any external files, tools, MCP servers, or other skills by name?

### 2. Choose a structural pattern

Use the definitions in the Skill anatomy section above. When in doubt:
- If the skill tells the agent *what to do step by step*, use the workflow pattern
- If the skill tells the agent *what good output looks like*, use the style/output pattern
- If both apply, use a hybrid with workflow sections first

### 3. Write the frontmatter

Derive the skill name from the user's stated purpose if they have not provided one:
- Use the action or domain the skill covers, not a generic label (`git-release`, not `release-helper`)
- Confirm the name with the user before writing if it is not obvious from their request

Write the description to pass the "would an agent load this at the right time?" test. Read the description back as if you are an agent choosing between skills. If it is ambiguous, rewrite it.

### 4. Write the body content

Follow the chosen pattern. These rules apply regardless of pattern:

- **Write to the agent, not the user.** The content is instructions for the agent that loads the skill. Use "call", "read", "write", "ask the user", not "you should tell your users".
- **Be specific, not general.** Vague instructions produce vague output. Where the skill's output has a defined shape, include concrete examples and exact formats.
- **Include reference examples** when the skill produces structured output (files, config blocks, documents). Show a minimal correct example alongside a more complete one.
- **Define quality checks.** If the skill produces output that can be validated, include a checklist or enumerated conditions the output must satisfy before delivery.
- **Scope clearly.** Every skill should include a section or note on when it should *not* be used, with pointers to alternative skills where relevant.
- **Depth should match complexity.** A simple workflow skill (3–4 steps, no branching) can be short. A style guide skill or a skill with many configuration variants needs more depth and reference material.

### 5. Validate before saving

Before writing the file, verify:
- `name` in frontmatter matches the intended directory name exactly
- `description` is between 1 and 1024 characters
- No required frontmatter fields are missing or misspelled
- The body follows the chosen structural pattern consistently
- No sections are empty or contain placeholder text
- If the skill references other skills or tools by name, those names are correct
- The skill is written to the agent, not to the user

### 6. Save and report

**Global skill:** Write to `~/.config/opencode/skills/<name>/SKILL.md`. Create the directory if it does not exist.

**Project-local skill:** Resolve the project root (nearest `.git` ancestor from the current working directory). Write to `<project-root>/.agents/skills/<name>/SKILL.md`. Create the directory if it does not exist. If the project root cannot be determined, ask the user for the project path before writing.

After saving, tell the user:
- The full path where the file was written
- The scope (global or project-local) and what that means for discoverability
- The name to use when invoking it via the `skill` tool
- That a session restart may be needed for the skill to appear in the available skills list

## Reference: existing skill patterns

Use these as structural models when uncertain about format or depth:

| Skill | Pattern | Good reference for |
|---|---|---|
| `cog-recollect` | Workflow, short | Minimal workflow skill with focused steps |
| `rsg-pull-request` | Workflow, detailed | Workflow with branching logic and config examples |
| `rsg-branching-commiting` | Workflow, detailed | Workflow that produces a structured output with conventions |
| `writing-persuasive` | Style/output | Comprehensive writing style guide with tone rules |
| `writing-educative` | Style/output | Writing style guide with teaching-specific techniques |
| `ui-design` | Style/output, phased | Multi-phase output guide with checklists and anti-pattern tables |
