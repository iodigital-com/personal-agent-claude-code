---
name: capture
description: Quickly add something to the Inbox without breaking flow. Pass content as args (a thought, link, task, or reference snippet). Creates a properly-formatted Inbox note immediately and confirms.
---

# Capture

Your job is to get something into the vault immediately, with zero friction. The user is in flow — don't slow them down.

## Step 1 — Parse the input

The content to capture is in `args`. It may be:
- A raw thought or idea
- A URL or link (with or without a title)
- A task or action item (often starts with a verb or contains "TODO")
- A reference snippet (a quote, excerpt, or summary)
- A name or person note trigger

If `args` is empty, ask: "What would you like to capture?"

## Step 2 — Get today's date

Run `date +%Y-%m-%d`.

## Step 3 — Determine a title

Derive a short title from the content (3–6 words, Title Case). Do not ask the user — infer it.

Examples:
- "check if we need to renew the domain" → `Check Domain Renewal`
- "https://example.com/article about sleep" → `Article About Sleep`
- "Inversion is reasoning backwards from failure" → `Inversion Mental Model`

## Step 4 — Determine the type hint

Make a best guess at what this will eventually become:
- Action / task → note it in the description as "actionable"
- URL / article → `resource`
- Thought / idea → `inbox`
- Person's name → `person`
- Everything else → `inbox`

This is just a hint for processing later — don't over-engineer it.

## Step 5 — Create the Inbox note

Create `Inbox/[Title].md` with this structure:

```markdown
---
title: "[Title]"
type: inbox
status: active
tags: []
created: YYYY-MM-DD
modified: YYYY-MM-DD
related: []
description: "[One sentence describing the captured content]"
---

[Raw captured content, exactly as provided]
```

Do not restructure, clean up, or expand the content. Preserve it verbatim. The point is speed, not polish.

## Step 6 — Confirm

Respond with one line:
`Captured: "[Title]" → Inbox. Process with /process-inbox when ready.`

Nothing else.
