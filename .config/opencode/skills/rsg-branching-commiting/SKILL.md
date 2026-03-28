---
name: rsg-branching-commiting
description: Create correctly named branches and commit changes in Republic Services (RSG) repos — branches follow US######_snake_case_description or DE######_snake_case_description format, and commits are prefixed with the Rally artifact ID. Use this when starting new work or committing changes in any RepublicServicesRepository project.
---

## What I do

Guide the full local git workflow for RSG work: create a correctly named branch
for the Rally artifact, then stage and commit changes with properly prefixed
commit messages.

All git operations use `rsgdev git` instead of bare `git`. The `rsgdev git`
wrapper works identically to `git` but automatically adds a coauthor trailer
to commits.

## When to use me

- The user is starting new work tied to a Rally user story or defect in an RSG repo
- The user wants to commit changes in an RSG/Republic Services repo
- The `rsg-pull-request` skill needs all changes committed before opening a PR

## Branch naming rules

| Part | Format | Examples |
|---|---|---|
| Artifact prefix | `US######` or `DE######` | `US123456`, `DE789012` |
| Separator | Single underscore `_` | |
| Description | 3–5 words, lowercase, snake_case | `resolve_eslint_config`, `fix_null_pointer` |

Full format: `{ARTIFACT_ID}_{snake_case_description}`

Valid examples:
- `US123456_resolve_eslint_config`
- `DE789012_fix_null_pointer`
- `US654321_add_auth_middleware`

Rules:
- All lowercase
- Words separated by single underscores only — no hyphens, spaces, or special characters
- Description must be 3–5 words; not shorter, not longer
- Must not start or end with an underscore
- Must not contain consecutive underscores

## Commit message rules

```
US123456: brief description of the change

Optional longer body explaining the why, context, or notable details.
Each line of the body should be wrapped at 72 characters.
```

Rules:
- First line must start with the Rally artifact ID (`US######:` or `DE######:`)
- First line must be 72 characters or fewer
- Description after the ID: lowercase, imperative mood, no trailing period
- Good examples:
  - `US123456: resolve eslint config issue`
  - `DE789012: fix null pointer in auth middleware`
  - `US654321: add pagination to user list endpoint`

## Workflow

### 1. Identify the Rally artifact ID

Run `rsgdev git branch --show-current` and look for a `US` or `DE` number using the
pattern `(US|DE)\d+`.

- If found on the current branch, extract it and skip to step 5 (no new branch needed).
- If the current branch does **not** match the pattern, the user needs a new branch — continue to step 2.
- If the artifact ID cannot be determined from the branch, ask the user to provide it before continuing.

### 2. Draft the branch description

Ask the user or infer from context what the branch work contains. Compose a
3–5 word snake_case description of the work. Show it to the user and ask for
confirmation or adjustment before continuing.

Example prompt:
> "I'll name the branch `US123456_add_auth_middleware` — does that description
> work, or would you like a different one?"

### 3. Confirm and create the branch

Show the full branch name to the user:

```
US123456_add_auth_middleware
```

Ask for explicit confirmation before creating. Once confirmed, run:

```bash
rsgdev git checkout -b <branch-name>
```

Report the newly active branch to the user.

### 4. Check git status

Run `rsgdev git status` to inspect the working tree.

If the working tree is **clean** (nothing to commit), report this to the user
and exit — do not continue with the remaining steps.

### 5. Show uncommitted changes and plan commits

Display a summary of all uncommitted changes (both staged and unstaged) using
`rsgdev git diff --stat` and `rsgdev git status --short`.

Ask the user how they want to group the changes:
- **Single commit** — all changes in one commit (suggest this when the diff is
  small or all changes are logically related)
- **Multiple commits** — split into separate commits by logical area (suggest
  this when changes span multiple unrelated concerns)

### 6. Build each commit

For each planned commit:

1. **Select files to stage** — present the list of changed files and confirm
   which ones belong to this commit. Use `rsgdev git add <files>` to stage them.
   Never use `rsgdev git add .` or `rsgdev git add -A` without explicit confirmation of
   every file being included.

2. **Draft the commit message** — compose a message following the commit
   message rules above.

3. **Present the draft** — show the full commit message to the user and ask
   for confirmation or changes before running `rsgdev git commit`.

4. **Run the commit** — once approved, execute `rsgdev git commit -m "<message>"` (or
   with multiple `-m` flags for a multi-line message).

### 7. Repeat for additional commits

If the user planned multiple commits, repeat step 6 for each remaining group
of files.

### 8. Report final status

After all commits are complete, run `rsgdev git status` and `rsgdev git log --oneline -5` to
show the user the clean working tree and the new commit(s).
