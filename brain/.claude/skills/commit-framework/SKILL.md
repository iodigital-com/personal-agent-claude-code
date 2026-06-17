---
name: commit-framework
description: Analyse git changes, classify each file as framework or personal content, and commit only the framework files. Refuses to commit personal notes, journal entries, or profile files.
---

# Commit Framework

Scan uncommitted changes, validate what belongs to the framework, and commit only those files.

## Step 1 — Get the current changes

Run:
```
git status --short
```

If there are no changes, respond: "Nothing to commit." and stop.

## Step 2 — Classify each file

For every file in the output, apply these rules:

**Framework** — safe to commit:
- Anything under `brain/.claude/` (skills, settings, MCP config)
- Anything under `brain/_Templates/`
- Anything under `brain/_System/`
- Files named `README.md` anywhere in the vault
- Files named `CLAUDE.md`, `.mcp.json`, `.gitignore`, `.gitkeep`
- Files named `_Template.md` or matching `_Templates/`
- `brain/MOC/Home.md`
- Anything under `devcontainer/`, `searxng/`, root `docker-compose.yml`, `.env.example`

**Personal content** — never commit:
- `USER.md` or `SOUL.md` (onboarding profile output)
- Anything under `brain/Inbox/` that is not a README or `_Template.md`
- Anything under `brain/Journal/` that is not a README or under `_Templates/`
- Anything under `brain/Areas/`, `brain/Projects/`, `brain/People/`, `brain/MOC/Topics/` that is not a README
- Anything under `brain/Resources/` subdirectories that is not a README
- Anything under `brain/Archives/` that is not a README
- Anything under `brain/_Attachments/` that is not a README

If a file doesn't match either list, treat it as **personal** and flag it.

## Step 3 — Report the classification

Show two lists:

```
Framework files (will commit):
  M  brain/_Templates/Project.md
  A  brain/.claude/skills/review/SKILL.md
  ...

Personal / unclassified (skipped):
  ??  brain/Inbox/Random thought.md
  ...
```

If there are **no framework files**, respond: "No framework files to commit." and stop.

If there are **personal files**, note them but do not ask for confirmation — just skip them.

## Step 4 — Stage only the framework files

Run `git add` for each framework file individually. Do not use `git add .` or `git add -A`.

## Step 5 — Write a commit message

Infer a concise message from the staged files:
- New skill files → "Add [skill names] skill(s)"
- Updated templates → "Update [folder] templates"
- Mixed → "Update framework: [short summary]"
- Infrastructure changes → "Update [component]"

## Step 6 — Commit

```
git commit -m "[message]

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

Confirm with one line: `Committed [N] files: "[message]"`
