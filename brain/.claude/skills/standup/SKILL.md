---
name: standup
description: Morning focus session for the second brain vault. Reads active projects, surfaces open tasks, and proposes a short focus list for the day. Use at the start of each working day.
---

# Standup

Your job is to orient the user for the day: what's active, what's open, what to focus on.

## Step 1 — Get today's date

Run `date +%Y-%m-%d` to get today's date. Also compute the ISO week number with `date +%Y-W%V` for the weekly note.

## Step 2 — Read active projects

Read `Projects/README.md`. This is the canonical list of active work. Note each project's title, status, and due date if present.

## Step 3 — Surface open tasks

Search for open tasks across active projects and areas:
- Grep `- [ ]` in `Projects/` — project-level tasks
- Grep `- [ ]` in `Areas/` — ongoing responsibility tasks
- Grep `- [ ]` in `Inbox/` — unprocessed but potentially actionable items

Group the results by note. Ignore tasks in `Archives/`.

## Step 4 — Check today's daily note

Look for `Journal/YYYY-MM-DD.md` (today's date). 

**If it exists:** read it — it may already have context or a focus list from the user.

**If it does not exist:** scaffold it from the daily template at `Journal/_Templates/Daily.md`, filling in today's date. Create the file at `Journal/YYYY-MM-DD.md`.

## Step 5 — Check for overdue items

Scan `Projects/` for notes with `due:` frontmatter earlier than today. Flag any that are overdue or due within 2 days.

## Step 6 — Present the standup

Output a clean, scannable standup in this format:

---

**Standup — [Day, Date]**

**Active Projects**
- [Project name] — [one-line status or next action] *(due: date if set)*

**Open Tasks**
- [Note name]: [task text]
- ...

**Overdue / Due Soon**
- [Project or note]: due [date]  *(only show if relevant)*

**Suggested Focus (pick 3)**
1. [Most important task or next action]
2. [Second priority]
3. [Third priority]

---

Keep it tight. Don't summarise what the user already knows — surface what matters today.

## Step 7 — Add focus list to daily note

After presenting, add the suggested focus list to today's daily note under a `## Today's Focus` heading (create the section if it doesn't exist). Do this silently — no need to announce it.
