---
name: create-work-commit
description: Commit work-in-progress changes in a Republic Services (RSG) repo, prefixing each commit message with the Rally user story (US######) or defect (DE######) number. Use this when staging and committing changes to any RepublicServicesRepository project.
---

## What I do

Guide the user through staging and committing changes in an RSG repo, ensuring
every commit message is correctly prefixed with the relevant Rally artifact ID
(`US######` or `DE######`).

## When to use me

- The user wants to commit changes in an RSG/Republic Services repo
- The `create-work-pull-request` skill needs all changes committed before opening a PR

## Workflow

### 1. Check git status

Run `git status` to inspect the working tree.

If the working tree is **clean** (nothing to commit), report this to the user
and exit — do not continue with the remaining steps.

### 2. Identify the Rally artifact ID

Parse the current branch name using `git branch --show-current` and look for a
`US` or `DE` number using the pattern `(US|DE)\d+`.

Examples of valid branch names:
- `feature/US123456-resolve-eslint-config` → `US123456`
- `bugfix/DE789012-fix-null-pointer` → `DE789012`
- `US654321-add-auth-middleware` → `US654321`

If no `US` or `DE` number is found in the branch name, ask the user to provide
the Rally artifact ID before continuing.

### 3. Show uncommitted changes and plan commits

Display a summary of all uncommitted changes (both staged and unstaged) using
`git diff --stat` and `git status --short`.

Ask the user how they want to group the changes:
- **Single commit** — all changes in one commit (suggest this when the diff is
  small or all changes are logically related)
- **Multiple commits** — split into separate commits by logical area (suggest
  this when changes span multiple unrelated concerns)

### 4. Build each commit

For each planned commit:

1. **Select files to stage** — present the list of changed files and confirm
   which ones belong to this commit. Use `git add <files>` to stage them.
   Never use `git add .` or `git add -A` without explicit confirmation of
   every file being included.

2. **Draft the commit message** — compose a message with this structure:

   ```
   US123456: brief description of the change

   Optional longer body explaining the why, context, or notable details.
   Each line of the body should be wrapped at 72 characters.
   ```

   Rules:
   - First line must start with the Rally artifact ID (`US######:` or
     `DE######:`)
   - First line must be 72 characters or fewer
   - Description after the ID should be lowercase, imperative mood, no
     trailing period
   - Good examples:
     - `US123456: resolve eslint config issue`
     - `DE789012: fix null pointer in auth middleware`
     - `US654321: add pagination to user list endpoint`

3. **Present the draft** — show the full commit message to the user and ask
   for confirmation or changes before running `git commit`.

4. **Run the commit** — once approved, execute `git commit -m "<message>"` (or
   with `-m` for the body if multi-line).

### 5. Repeat for additional commits

If the user planned multiple commits, repeat step 4 for each remaining group
of files.

### 6. Report final status

After all commits are complete, run `git status` and `git log --oneline -5` to
show the user the clean working tree and the new commit(s).
