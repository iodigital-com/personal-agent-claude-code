---
title: LLM Retrieval Plan
type: system
status: evergreen
tags: [system/retrieval]
created: 2026-06-17
modified: 2026-06-17
description: The complete strategy for how an LLM navigates this vault without vector databases. Layers of retrieval, conventions, and reasoning patterns.
---

# LLM Retrieval Plan

## The Problem

Large language models receive context as a flat sequence of tokens. A vault with hundreds of notes cannot fit in one context window. The challenge is: **how does an LLM find the right notes without semantic vector search?**

The answer is layered navigation: from broad to specific, using structure and metadata rather than embedding similarity.

---

## The Core Principle: Structured Scarcity

Every note costs context. The goal is to spend the fewest tokens to reach the most relevant content. This vault is designed to support that in five layers.

---

## Layer 1 — Always Load (Orientation Layer)

These files are small and always loaded at the start of any session:

| File | Purpose | Size Target |
|---|---|---|
| `README.md` | Vault overview, conventions, folder map | < 100 lines |
| `MOC/Home.md` | Master topic index | < 80 lines |
| `Projects/README.md` | Active project list with summaries | < 60 lines |

**Why:** These three files tell me what exists and where without reading individual notes. I can answer most orientation questions from here alone.

---

## Layer 2 — Directory Scanning (Folder Layer)

Each folder has a `README.md` that lists its contents with one-line summaries. When a query concerns a domain (e.g., "what do I know about X"), I read the folder README before reading any notes.

**Why it works:** A 30-line README can summarise 40 notes. One read covers the whole folder.

**Convention:** Folder READMEs must include a table with note names and summaries. Stale READMEs break this layer — update them when adding notes.

---

## Layer 3 — Frontmatter Scanning (Metadata Layer)

Every note has a `description:` field in its YAML frontmatter. The description is:
- One sentence, self-contained
- Dense — it captures the note's core claim, not just its topic
- Written as if explaining to someone who has never seen the note

**The trick:** I can read 20 frontmatter blocks sequentially at very low token cost, then select the 2-3 notes worth reading in full.

**Query pattern:**
1. Find candidate notes from Layer 2
2. Read only frontmatter of candidates
3. Select notes whose `description` matches the query
4. Read those notes in full

**Field priority for quick scanning:**
1. `description` — relevance signal
2. `status` — prefer `active` and `evergreen` over `archived`
3. `tags` — confirm domain match
4. `modified` — prefer recent notes for current context

---

## Layer 4 — MOC Navigation (Graph Layer)

Maps of Content (MOCs) are hub notes that aggregate links to related content. They serve as semantic indexes built by humans, not algorithms.

**Navigation pattern:**
```
Home MOC
  └── MOC — Topic A
        ├── Core Note 1
        ├── Core Note 2
        └── MOC — Sub-topic A1
              └── Deep Note
```

**Why this beats a flat search:** MOCs encode the editor's judgement about which notes belong together. A note that appears in three MOCs signals high importance.

**Convention:**
- Every topic with 3+ notes should have a MOC
- MOCs live in `MOC/Topics/`
- Home MOC links to all topic MOCs
- MOCs have an "Unsorted" section at the bottom for new links pending placement

---

## Layer 5 — Wikilink Traversal (Expansion Layer)

When a note is identified as relevant, follow its `related:` field and embedded `[[wikilinks]]` to find adjacent notes. This surfaces notes that are connected but might not appear in the folder structure.

**Use this layer when:**
- The query is exploratory ("tell me everything related to X")
- Initial retrieval found one relevant note but the question needs more depth
- Synthesising across a topic rather than answering a point question

**Stop condition:** Stop following links when the notes retrieved no longer add new information, or when context budget is approaching its limit.

---

## Retrieval Decision Tree

```
Query received
│
├── Is it about current work/projects?
│   └── Read Projects/README.md → relevant project note
│
├── Is it about a person?
│   └── Read People/README.md → person note → meeting log
│
├── Is it about a time period?
│   └── Read Journal/YYYY-MM-DD.md or YYYY-Www.md
│
├── Is it about a topic/domain?
│   └── Check MOC/Home.md for topic cluster
│       └── Read topic MOC
│           └── Scan frontmatter of candidate notes
│               └── Read top 2-3 notes in full
│
└── Is the vault the right place to look?
    └── If the user is asking about current events or
        external facts: say so — don't hallucinate from
        stale vault content
```

---

## Conventions That Enable Retrieval

### The `description` field is non-negotiable

A note without a description is invisible to Layer 3 scanning. Every note must have one. The description should answer: "If I could only read one sentence about this note, what would be most useful?"

Good: `"Inversion is a mental model for finding the right answer by reasoning backwards from failure."`
Bad: `"Notes about a mental model."`

### Status flags control priority

| Status | Meaning | LLM Priority |
|---|---|---|
| `active` | Currently relevant, being worked on | High |
| `evergreen` | Stable, timeless knowledge | High |
| `someday` | Parked, not current | Low |
| `archived` | Done or stale | Ignore unless specifically asked |

### Tags enable domain filtering

Before reading descriptions, filter by tag to narrow the candidate set. Tags follow the schema `domain/subtopic` — e.g., `learning/writing`, `health/sleep`, `project/launch`.

### Folder READMEs are always current

The human or AI maintaining the vault must update folder READMEs when notes are added, moved, or archived. A stale README breaks Layer 2 — the most efficient retrieval layer.

### MOC hygiene

A MOC that links to archived or deleted notes is noise. During weekly review, check that all MOC links resolve. Remove dead links immediately.

---

## What This Replaces (and What It Doesn't)

**Replaces:**
- Vector similarity search — the MOC + frontmatter layers provide semantic lookup without embeddings
- Full-text search — structured navigation is faster and more accurate for known domains
- Random note reading — purpose-built traversal beats serendipity

**Does not replace:**
- Full-text search for exact phrases or proper nouns you know exist in notes
- Human judgment about what to capture
- The quality of the notes themselves — structure aids retrieval, it doesn't fix bad notes

---

## Maintenance Protocol

This retrieval system degrades when:
1. Notes lack descriptions
2. Folder READMEs are not updated
3. MOCs have dead links
4. Too many notes sit in `Inbox/` unprocessed

**Weekly task (5 minutes):**
- [ ] Process Inbox
- [ ] Add descriptions to any notes that lack them
- [ ] Update folder READMEs if notes were added
- [ ] Prune dead links in MOCs used this week
