---
title: Second Brain — Home
type: system
summary: Root orientation file. Start here to understand the vault layout, conventions, and how to navigate.
---

# Second Brain

This vault is a shared context between you and your personal AI agent. It is built on the **PARA + CODE** methodology, optimised for both human recall and LLM retrieval without vector databases.

---

## Folder Structure

| Folder | Purpose |
|---|---|
| `Inbox/` | Rapid capture — unprocessed, unstructured |
| `Projects/` | Active work with a defined outcome and deadline |
| `Areas/` | Ongoing responsibilities with no end date |
| `Resources/` | Reference material, evergreen knowledge |
| `Archives/` | Completed, paused, or inactive items |
| `Journal/` | Time-based entries — daily, weekly, monthly |
| `People/` | Relationship notes and meeting logs |
| `MOC/` | Maps of Content — navigation hubs by topic |
| `_Templates/` | Note templates for each type |
| `_Attachments/` | Media, images, PDFs |
| `_System/` | Meta-documentation about this brain |

---

## Navigation (for humans and LLMs)

1. **Orientation** → start here (you are here)
2. **Broad topics** → `MOC/Home.md`
3. **Active work** → `Projects/README.md`
4. **Ongoing domains** → `Areas/README.md`
5. **Reference lookup** → `Resources/README.md`
6. **Recent context** → `Journal/` (most recent daily note)
7. **Quick capture** → `Inbox/`

---

## Core Conventions

### Frontmatter (every note must have this)
```yaml
---
title: "Descriptive Note Title"
type: project | area | resource | person | journal | moc | inbox
status: active | evergreen | someday | archived
tags: [domain/subtopic]
created: YYYY-MM-DD
modified: YYYY-MM-DD
related: ["[[Note A]]", "[[Note B]]"]
summary: "One sentence — what this note is about, written for quick scanning."
---
```

The `summary` field is the single most important field for LLM retrieval. It must be dense and self-contained.

### Naming Conventions
- Notes: `Title Case With Spaces.md`
- Daily journal: `YYYY-MM-DD.md`
- Weekly journal: `YYYY-Www.md` (e.g. `2026-W24.md`)
- MOCs: `MOC - Topic Name.md`
- Meeting notes: `YYYY-MM-DD Meeting With Person.md`

### Status Lifecycle
```
Inbox → active → evergreen (timeless) or archived (done/stale)
                → someday (parked, not abandoned)
```

---

## LLM Retrieval Guide

See `_System/LLM-Retrieval-Plan.md` for the full strategy. Short version:

1. Read `MOC/Home.md` to find the relevant topic cluster
2. Read the topic MOC to find candidate notes
3. Scan frontmatter `summary` fields before reading full bodies
4. Prefer `status: active` and `status: evergreen` notes
5. Check `Journal/` for recent temporal context
6. Follow `related:` links to adjacent notes
