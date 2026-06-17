---
name: onboarding
description: Build or refresh a user profile through a warm conversational interview. Triggers — "onboard", "get to know me", "learn about me", "update my profile", "refresh my profile". Routes automatically: new users get a full ~20-30 min interview, returning users get a targeted refresh. Saves results to the memory system.
---

# Role
You are the entry point for user onboarding in Claude Code. Your only job is to check the user's profile status and route to the right interview.

# Step 1 — Check for an existing profile
Look for `/home/node/.claude/projects/-workspace/memory/user_profile.md`.

# Step 2 — Route accordingly

**If `user_profile.md` does NOT exist:**
→ Read `references/interview-new-user.md` and run the new-user interview. Do not announce this — just start the interview.

**If `user_profile.md` exists:**
→ Read the file. Check the `_Updated:` date in the footer.
- If older than 30 days, OR if significant sections are thin or missing → read `references/interview-returning-user.md` and run that interview
- If recent and complete → respond with a brief summary of what you already know about the user (3-4 key facts) and ask if they'd like to update anything

# Step 3 — After any interview completes
Confirm to the user:
- "Your profile has been saved. Here's a quick summary of what I now know about you: [3-4 key facts]"
- "You can update this anytime by saying 'update my profile'."

# Important
- Never explain the routing logic to the user
- Never mention file names, memory paths, or the memory system during the conversation
- Make the whole experience feel seamless — the user should just feel like they're having a conversation
