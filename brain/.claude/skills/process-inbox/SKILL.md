---
name: process-inbox
description: Triage everything in the Inbox folder — file reference material, surface tasks into the right project or area, create people notes, and clear what doesn't belong. Use weekly or after a batch of captures.
---

# Process Inbox

Your job is to empty the Inbox by giving every item a proper home. Work through items one at a time, making a filing decision for each.

## Step 1 — List Inbox contents

List all `.md` files in `Inbox/` (excluding `README.md` and `_Template.md`). If Inbox is empty, say so and stop.

## Step 2 — For each item, read and decide

Read the note. Then apply this decision tree:

### Is it actionable?

**Yes → Where does it belong?**
- Relates to an active project → add as `- [ ] [task]` to the relevant `Projects/` note. Delete the inbox file.
- Relates to an area → add as `- [ ] [task]` to the relevant `Areas/` note. Delete the inbox file.
- Standalone task with no clear home → create a `Projects/` note for it if it's substantial, or keep as a task in `Inbox/` until the project is clearer.

**No → What is it?**
- **Reference material** (article, concept, tool, framework) → move to `Resources/` with full frontmatter. Choose the right subfolder: `Resources/Articles/`, `Resources/Books/`, `Resources/Mental Models/`, or `Resources/` root.
- **Person** (a name, contact, relationship note) → create or update `People/[Name].md`.
- **Reflection / thought** → move to `Areas/` if it belongs to an ongoing responsibility, or to `Journal/` if it's time-bound.
- **Empty or placeholder** (no real content) → delete it.
- **Unclear** → keep in Inbox, update the `description:` to be more specific so it's processable next time. Move on.

## Step 3 — Update frontmatter when filing

When moving a file to its new home:
- Set the correct `type:` for its destination
- Set `status: active` (or `evergreen` for timeless reference material)
- Ensure `description:` is filled and specific
- Update `modified:` to today's date

## Step 4 — Update folder READMEs

After filing, check if the destination folder has a `README.md` with a contents table. If so, add the new note as a row. Stale READMEs break LLM retrieval — keep them current.

## Step 5 — Report

After processing all items, give a short summary:

```
Inbox processed: N items
  → Tasked into projects: N
  → Filed to Resources: N
  → Filed to People: N
  → Filed to Areas/Journal: N
  → Deleted (empty/placeholder): N
  → Left in Inbox (unclear): N
```

If anything was left in Inbox, briefly explain why.
