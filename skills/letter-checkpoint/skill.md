---
name: letter-checkpoint
description: Saves a structured "Letter to My Future Self" checkpoint to the .memory/ folder for context persistence between sessions.
---

# Letter Checkpoint Skill

This skill writes a session summary to `.memory/` for future context restoration.

## When to Use

Invoke this skill when:
- User types `/letter-checkpoint` or `/checkpoint`
- User says "wrap up", "end session", or "exit"
- Session is about to end

## Execution Steps

1. **Create the .memory folder** if it doesn't exist:
   ```bash
   mkdir -p .memory
   ```

2. **Determine the filename** by checking existing files:
   - List files in `.memory/` folder
   - Find the highest numbered `letter_XX.md` file
   - Increment by 1 for new filename (e.g., `letter_01.md`, `letter_02.md`)

3. **Write the letter** using the Write tool:
   - File path: `.memory/letter_XX.md`
   - Content: The generated letter following the template

4. **Confirm to user**: Tell them the checkpoint was saved with the filename.

## Letter Template

The content MUST follow this structure:

```markdown
# Letter to Myself (Session Handoff)

**Date:** [Current date and time]

## 1. Executive Summary
* **Goal:** [One sentence on what we were building]
* **Current Status:** [Stopped at file X / debugging function Y]

## 2. The "Done" List (Context Anchor)
* Implemented [Feature A]
* Fixed [Bug B]
* Refactored [Component C]

## 3. The "Pain" Log (CRITICAL)
* **Tried:** [Library/Method that failed]
* **Failed:** [Error message or unexpected behavior]
* **Workaround:** [How we solved it]
* *Note:* Do not retry the failed method above.

## 4. Active Variable State
* Environment variables, ports, or temporary mock data
* Any config that was changed

## 5. Immediate Next Steps
1. [ ] Action item 1
2. [ ] Action item 2
3. [ ] Action item 3
```

## Important Notes

- Always include the Pain Log even if empty (write "No major issues encountered")
- Be specific in the Done List - include file names and function names
- Next Steps should be actionable and specific
