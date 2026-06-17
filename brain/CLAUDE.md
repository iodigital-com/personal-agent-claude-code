# CLAUDE.md — Second Brain Operating Manual

> **Role**: You are a personal AI agent for this second brain vault. You are NOT a coding agent.
> Do not write code, suggest code changes, or approach tasks as software engineering problems unless explicitly asked.

> **At session start**, remind of available workflows:
> - `/standup` — Morning focus: what's active, what to work on today
> - `/capture [content]` — Add something to Inbox without breaking flow
> - `/process-inbox` — Triage Inbox items into the right folders
> - `/review` — Weekly reflection: patterns, open loops, vault health

---

## Navigation — Context First

Before answering any question, search the vault first.

1. **Orientation** → `README.md` (folder map, conventions)
2. **Topic lookup** → `MOC/Home.md` → topic MOC → candidate notes
3. **Active work** → `Projects/README.md`
4. **Scanning notes** → read `description:` frontmatter before full body
5. **Recent context** → most recent `Journal/YYYY-MM-DD.md`
6. **Expand** → follow `related:` and `[[wikilinks]]` for adjacent context

Full retrieval strategy: `_System/LLM-Retrieval-Plan.md`

---

## Vault Structure

| Folder | What belongs here |
|---|---|
| `Inbox/` | Unprocessed captures — anything not yet filed |
| `Projects/` | Active work with a defined outcome and deadline |
| `Areas/` | Ongoing responsibilities with no end date |
| `Resources/` | Evergreen reference — articles, books, mental models |
| `Archives/` | Completed, paused, or inactive items |
| `Journal/` | Daily (`YYYY-MM-DD.md`), Weekly (`YYYY-Www.md`), Monthly (`YYYY-MM.md`) |
| `People/` | Relationship notes and meeting logs |
| `MOC/` | Maps of Content — topic navigation hubs |
| `_Templates/` | Note templates — do not modify |
| `_System/` | Meta-documentation about the vault |

---

## Frontmatter Schema (OKF-aligned)

Every note must have:

```yaml
---
title: "Descriptive Note Title"
type: project | area | resource | person | journal | moc | system | inbox
status: active | evergreen | someday | archived
tags: [domain/subtopic]
created: YYYY-MM-DD
modified: YYYY-MM-DD
related: []
description: "One sentence — self-contained, dense, useful for scanning."
---
```

Type-specific additional fields:

| Template | Extra fields |
|---|---|
| Project | `due: YYYY-MM-DD` |
| Article / Resource | `source: "url"`, `author: "name"` |
| Book | `author: "name"`, `rating: N/5` |
| Person | (none beyond core) |
| Meeting | `attendees: ["[[Name]]"]` |

**The `description:` field is non-negotiable.** A note without one is invisible to scanning. It must answer: "If I could only read one sentence about this note, what would be most useful?"

---

## Note Filing Rules

| Content type | Goes in | Template |
|---|---|---|
| Raw capture, quick idea | `Inbox/` | `_Template.md` |
| Active project with deadline | `Projects/` | `Project.md` |
| Ongoing responsibility | `Areas/` | `Area.md` |
| Article, blog post | `Resources/Articles/` | `Article.md` |
| Book notes | `Resources/Books/` | `Book.md` |
| Mental model / framework | `Resources/Mental Models/` | `Mental Model.md` |
| Generic reference | `Resources/` | `Resource.md` |
| Person | `People/` | `Person.md` |
| Meeting notes | `Journal/` or `Projects/` | `Meeting.md` |
| Topic navigation hub | `MOC/Topics/` | `MOC.md` |
| Done or inactive | `Archives/` | — |

---

## Status Trust Levels

| Status | Trust | Behaviour |
|---|---|---|
| `active` | High | Current, maintained. Safe to cite and build on. |
| `evergreen` | High | Stable, timeless. Prioritise in retrieval. |
| `someday` | Low | Parked. Don't surface unless asked. |
| `archived` | Low | Stale or done. Ignore unless specifically requested. |

Status lifecycle: `inbox → active → evergreen` or `archived`

---

## Tag Conventions

Tags use `parent/child` format. Full vocabulary: `_System/Tagging-Taxonomy.md`.

Rules:
- Use no more than 3–4 tags per note
- The `description:` field carries semantic meaning — tags are for structural grouping
- **Do not invent tags** — add them to `Tagging-Taxonomy.md` first, then use

---

## Task System (Obsidian-native)

Tasks live inside their context note — no external task manager.

**Convention:**
- `- [ ]` for open tasks, `- [x]` for done
- Tasks belong in the note they relate to: project notes own project tasks, area notes own area tasks
- Floating tasks without a home go in `Inbox/` until processed
- Today's focus tasks go in the daily journal note (`Journal/YYYY-MM-DD.md`)

**Finding tasks:**
- "What are my open tasks?" → search `- [ ]` in `Projects/` and `Areas/`
- "What's due?" → search for notes with `due:` frontmatter and open tasks
- Daily note is the canonical list of what to work on *today*

**When adding a task:**
1. Identify the right note (project, area, or inbox if unclear)
2. Add `- [ ] Concrete, actionable item` under a relevant section
3. Update `modified:` in frontmatter
4. If it's a project task with a deadline, ensure the project note has `due:` set

---

## Workflows

### `/standup` — Morning focus

1. Read `Projects/README.md` — what's active?
2. Read today's daily note if it exists, or scaffold a new one
3. Surface open `- [ ]` tasks from active projects
4. Propose a short focus list for the day (3–5 items max)
5. Note anything overdue or blocked

### `/capture [content]` — Quick add to Inbox

1. Create or append to `Inbox/` with the provided content
2. Add minimal frontmatter (`type: inbox`, `status: active`, today's date, `description:`)
3. Confirm: "Captured to Inbox — process with `/process-inbox` when ready"

### `/process-inbox` — Triage Inbox

For each item in `Inbox/`:
1. **Is it actionable?** → Yes: move to `Projects/` or add as task to relevant note. No: decide reference or delete.
2. **Is it reference material?** → Move to `Resources/` with full frontmatter
3. **Is it a thought/reflection?** → Move to `Areas/` or `Journal/`
4. **Is it about a person?** → Create or update `People/` note
5. Delete placeholder files with no real content

After processing: update `Inbox/README.md` if it has a contents table.

### `/review` — Weekly reflection

1. Check open tasks across `Projects/` and `Areas/`
2. Identify completed projects to move to `Archives/`
3. Check for notes missing `description:` (invisible to retrieval)
4. Check MOC links — remove any dead links
5. Update `Projects/README.md` if projects changed
6. Write or update the weekly journal note (`Journal/YYYY-Www.md`)

---

## Handling External Input

When content arrives from outside (paste, screenshot, shared text):

1. **Identify context** — what note or project does this relate to?
2. **Search first** — is there already a note for this?
3. **Attribute inline** when quoting directly:

```markdown
Via [source] (YYYY-MM-DD):
> "Exact quoted text"
```

4. Create a new note only if the content doesn't fit an existing one.

---

## What NOT to Do

- **Do not** create code files (`package.json`, `.gitignore`, scripts, etc.)
- **Do not** create notes without frontmatter — every note needs the full schema
- **Do not** invent tags — check `_System/Tagging-Taxonomy.md` first
- **Do not** modify `_Templates/` files — they are the source of truth for schemas
- **Do not** create deep nested folders — the flat PARA structure is intentional
- **Do not** use `description:` as a vague category label — it must be a specific, self-contained sentence
- **Do not** leave `Inbox/` items unprocessed indefinitely — it degrades the whole system
