---
name: git-worktree
description: Scope coding work to a git worktree — create, navigate, and clean up worktrees under a sibling .worktrees/ directory for feature branches, hotfixes, and PR reviews without disturbing the main working tree.
---

## What I do

Set up isolated working trees under a shared `.worktrees/` directory that sits as a
sibling to the main repo directory, so each branch has its own working directory and
index without any interference. Guide the full lifecycle from creation through cleanup,
and orient all file operations and bash commands to the correct worktree path.

## When to use me

- User wants to start work on a feature, defect, or task in an isolated branch
- User needs a hotfix while mid-feature and doesn't want to stash or commit WIP
- User wants to review or test a PR branch without disturbing the current branch
- User asks to list, move, lock, prune, or remove existing worktrees

## Prerequisites

Before creating a worktree, confirm:

1. The current directory is inside a git repository.
2. The parent directory of the repo root is writable (worktrees go there).

No `.gitignore` changes are needed — `.worktrees/` lives entirely outside the repo.

## Worktree naming convention

Derive the worktree directory name from the branch name by slugifying it:
- Lowercase the full branch name
- Replace `/`, `_`, spaces, and any non-alphanumeric characters with `-`
- Collapse consecutive `-` into one
- Strip leading/trailing `-`

Examples:

| Branch name | Slug |
|---|---|
| `feature/auth-refactor` | `feature-auth-refactor` |
| `fix/JIRA-123` | `fix-jira-123` |
| `hotfix/null-pointer` | `hotfix-null-pointer` |
| PR #42 | `pr-42` |

## Path derivation

Always compute the worktree path at runtime — never assume or hard-code it.

```bash
# 1. Get the absolute repo root
git rev-parse --show-toplevel
# → /project/my-repo

# 2. Step up one level to the parent
# → /project

# 3. Construct the worktree path
# → /project/.worktrees/<slug>
```

All subsequent bash commands and file operations for that worktree must use
`/project/.worktrees/<slug>` as the `workdir`. Never use `cd`.

## Workflow: Create & scope a worktree

### Step 1 — Compute the path

Run `git rev-parse --show-toplevel` to get the repo root.
Construct `<parent>/.worktrees/<slug>` as described above.

### Step 2 — Create the worktree

Choose the command based on the scenario:

**New branch from a base ref (feature, defect):**
```bash
git worktree add /project/.worktrees/<slug> -b <branch-name> <base-ref>
# base-ref is usually origin/main, origin/master, or a tag
```

**Existing local or remote branch:**
```bash
# If remote-only, fetch first:
git fetch origin <branch-name>
git worktree add /project/.worktrees/<slug> <branch-name>
```

**PR review (GitHub/GitLab):**
```bash
git fetch origin pull/<PR-number>/head:<pr-branch-name>
git worktree add /project/.worktrees/pr-<PR-number> <pr-branch-name>
```

### Step 3 — Scope all work to the worktree

After creation, every bash command and file read/write for this task must use the
worktree's absolute path as `workdir`. Do not operate on files in the main repo
directory unless the user explicitly asks to.

Tell the user the worktree is ready and confirm the active path.

## Workflow: Completion & cleanup

When the user signals work is done (e.g., "merged", "PR closed", "done with that
branch"), automatically suggest the following cleanup steps:

```bash
# 1. Remove the worktree
git worktree remove /project/.worktrees/<slug>

# 2. (Optional) Delete the local branch — ask the user first
git branch -d <branch-name>

# 3. Prune any stale worktree references
git worktree prune
```

Run these from the main repo root (`workdir` = repo root), not from the worktree.

## Workflow: Lifecycle management

Use these commands to inspect and manage existing worktrees. Run all of them
from the main repo root.

**List all worktrees with paths, branches, and HEAD:**
```bash
git worktree list
```

**Prune stale references** (after a worktree directory was manually deleted):
```bash
git worktree prune
```

**Lock a worktree** (prevent accidental removal of a long-lived worktree):
```bash
git worktree lock /project/.worktrees/<slug> --reason "long-running experiment"
```

**Unlock:**
```bash
git worktree unlock /project/.worktrees/<slug>
```

**Move (rename) a worktree:**
```bash
git worktree move /project/.worktrees/<old-slug> /project/.worktrees/<new-slug>
```

## Pitfalls

**Branch already checked out elsewhere**
Git refuses to add a worktree for a branch that is already checked out in another
worktree. Run `git worktree list` to detect this, then either remove the existing
worktree first or use `--checkout` with a detached HEAD if inspection is all that's
needed.

**Manually deleted worktree directory**
If the user deleted a `.worktrees/<slug>` directory directly (not via
`git worktree remove`), stale entries linger in `.git/worktrees/`. Always run
`git worktree prune` to clean them up before creating a new worktree with the
same name.

**Never use `cd` in bash commands**
Always pass the worktree path via the `workdir` parameter on each bash call.
Chaining `cd /path && command` is unreliable in this environment.

**Submodules**
Repositories with submodules require separate submodule initialization per worktree:
```bash
git submodule update --init --recursive
```
Run this from `workdir` = the new worktree's path immediately after creation.
