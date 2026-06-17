---
name: review
description: Weekly reflection session for the second brain vault. Surfaces open tasks, identifies completed projects to archive, checks vault health (missing descriptions, dead MOC links), and writes the weekly journal entry. Run at the end of each week.
---

# Review

Your job is to close the week: surface what's open, archive what's done, fix what's broken, and write a record of it.

## Step 1 — Get the date context

Run `date +%Y-%m-%d` for today's date and `date +%Y-W%V` for the ISO week number (e.g. `2026-W25`).

## Step 2 — Open tasks audit

Search for `- [ ]` across `Projects/` and `Areas/`. Group by note. Produce a list of everything still open.

Flag items that appear overdue (note has a `due:` frontmatter field earlier than today).

## Step 3 — Completed projects

Read `Projects/README.md`. For each project:
- If all tasks are checked (`- [x]`) and there are no open `- [ ]` items → candidate for archiving
- If `status: archived` is already set → confirm it's been moved to `Archives/`

For each completed project, ask the user: "Move [project name] to Archives?" — unless it's clearly done (all tasks checked, no open items, past due date). In that case, proceed to archive it directly and mention it in the report.

**To archive:** move the file to `Archives/Projects/[name].md`, update its frontmatter to `status: archived`, and remove it from `Projects/README.md`.

## Step 4 — Vault health checks

### Missing descriptions
Scan all `.md` files in `Projects/`, `Areas/`, `Resources/`, and `People/` for notes where `description:` is missing or contains a placeholder (e.g. `{{`). List them.

### Dead MOC links
Read `MOC/Home.md` and any topic MOCs linked from it. For each `[[wikilink]]`, check if the target file exists. List any broken links.

### Inbox age
Check if `Inbox/` has files older than 7 days (compare `created:` frontmatter to today). If yes, note how many and suggest running `/process-inbox`.

## Step 5 — Weekly journal entry

Look for `Journal/YYYY-Www.md` (this week's ISO week note). 

**If it exists:** read it and append a `## End-of-Week Review` section.

**If it doesn't exist:** create it from the weekly template at `Journal/_Templates/Weekly.md`, filling in the week identifier.

Add a `## End-of-Week Review` section with:

```markdown
## End-of-Week Review

### Completed
- [list of things finished this week]

### Still Open
- [key open items carrying into next week]

### Vault Health
- [any issues found: missing descriptions, dead links, stale inbox]

### Reflection
_[Leave blank for the user to fill in, or fill if there's context from the conversation]_
```

## Step 6 — Report

Present a structured summary:

---

**Weekly Review — [Week]**

**Open tasks:** N across N notes *(list if ≤10, summarise if more)*
**Overdue:** [list or "none"]*
**Archived this review:** [list or "none"]

**Vault health:**
- Missing descriptions: N notes *(list them)*
- Dead MOC links: N *(list them)*
- Stale inbox items: N *(list or "Inbox is clear")*

**Weekly note:** updated at `Journal/YYYY-Www.md`

---

Keep the tone factual. This is a status report, not a reflection — the reflection goes in the journal.
