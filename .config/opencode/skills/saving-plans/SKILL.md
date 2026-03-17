---
name: saving-plans
description: Save and retrieve implementation plans for the current project. Plans are stored as markdown files in ~/.agents/plans/<project>/ where project is the basename of the current working directory.
---

## What I do

Save and load markdown implementation plans scoped to the current project at
`~/.agents/plans/<basename "$PWD">/`.

## When to use me

- At the start of a task — check if a plan already exists
- After agreeing on a plan — save it to disk

## Conventions

- **Path:** `~/.agents/plans/<project>/<short-description>.md`
- **Project:** `basename "$PWD"`
- **Filename:** 2–5 words, lowercase, hyphen-separated (e.g. `add-auth-middleware.md`)
- **Format:** free-form markdown

## Workflow

### Check for existing plans

1. Run `ls ~/.agents/plans/<project>/` if the directory exists
2. If `.md` files found, list them and ask if the user wants to load one
3. If yes, read and display it

### Save a plan

1. Propose a filename slug and confirm with the user
2. If the file already exists, ask: overwrite or use a different name?
3. `mkdir -p ~/.agents/plans/<project>/`
4. Write the plan file and confirm the saved path
