---
title: About This Brain
type: system
status: evergreen
tags: [system]
created: 2026-06-17
modified: 2026-06-17
description: The origin, philosophy, and design decisions behind this second brain. Read this to understand why things are the way they are.
---

# About This Brain

## What This Is

This vault is a **shared cognitive workspace** between you (the human) and a personal AI agent. It serves two readers simultaneously:

- **You** — navigating in Obsidian, capturing thoughts, reviewing notes, making sense of your life and work
- **The AI agent** — reading context at the start of each conversation, retrieving relevant notes, and helping you think

Everything in its design — the frontmatter schema, the MOC structure, the description convention, the folder READMEs — exists to serve both readers equally.

---

## Design Philosophy

### 1. Structure over volume

A vault with 50 well-structured notes is more useful than one with 500 half-finished ones. The retrieval system works when every note has a description, a status, and a home. Capturing without processing is the failure mode.

### 2. The description field is the bridge

The single most important element bridging human and AI retrieval is the `description:` field in every note's frontmatter. One dense sentence that stands alone. This is how the AI scans efficiently; this is also how you remember what a note was about six months later.

### 3. Notes are for action, not for archiving

A note that never changes behaviour — never informs a decision, never resurfaces a useful idea, never prevents a repeated mistake — is just storage. The goal is a vault where opening any note triggers something: a thought, a connection, a next action.

### 4. The human decides; the AI retrieves and drafts

The AI agent's role is to surface relevant context, organise captures, draft notes, and remind you what you've already thought. The human's role is to judge what matters, decide what to do, and maintain the vault's integrity. Neither can do the other's job.

---

## Methodology

This vault is built on **PARA** (Projects, Areas, Resources, Archives) combined with **CODE** (Capture, Organise, Distill, Express):

- **Capture** → Inbox
- **Organise** → PARA folders
- **Distill** → summaries, MOCs, highlights
- **Express** → journal entries, finished notes, outputs

Reference: _Building a Second Brain_ by Tiago Forte.

---

## Design Decisions

**Why no Dataview?**
Dataview queries are powerful but brittle — they break when frontmatter is malformed and add cognitive overhead. Folder READMEs updated manually are slower but more resilient and human-readable without plugins.

**Why `description:` as the key retrieval field?**
The `description:` field sets a contract: one sentence, self-contained, useful to someone scanning twenty notes. OKF-aligned naming ensures the vault is readable by any agent or tool that speaks the Open Knowledge Format standard.

**Why MOCs instead of tags for navigation?**
Tags are flat; MOCs are hierarchical and editable. A MOC can express "this note is important to this topic", something a tag cannot. MOCs also degrade gracefully — a dead MOC link is visible; an orphaned tag is invisible.

**Why no auto-generated indexes?**
Auto-generation hides the fact that the vault needs curation. Manual indexes force periodic reviews. The friction is the feature.

---

## Versioning

This vault is designed to work with git. The `.gitignore` should exclude:
```
.obsidian/workspace
.obsidian/workspace.json
.obsidian/plugins/*/data.json
.trash/
```

Commit often — the git history is a free timeline of your thinking.
