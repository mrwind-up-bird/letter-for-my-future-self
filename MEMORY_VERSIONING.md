Here is the full, clean content for **`MEMORY_VERSIONING.md`**. You can copy the code block below and save it directly.

```markdown
# 🧠 Versioning .memory with Git (Best Practices)

This guide shows you how to cleanly version your **`.memory/`** folder (e.g., Session Letters / "Last Will") using **Git**. It includes **copy & paste** commands and proven patterns for both solo developers and teams.

---

## The Core Concept

Your agent continuously writes Markdown files to `.memory/`.
By using Git, you transform these files into a **traceable timeline of your project's brain**:

- "What was decided yesterday—and why?"
- "When did this error first appear?"
- "Which specific workaround fixed everything?"
- "What tasks were left open?"

To make this stable and unobtrusive, you need:
1. A clear decision: **To commit or not to commit?**
2. Proper `.gitignore` and `.gitattributes` configuration.
3. A **commit workflow** that doesn't get in your way.

---

## Option A: Full Versioning (Recommended for Solo Projects)

This is the simplest approach: track everything so you never lose context.

### 1. Check if `.memory/` is currently ignored

```bash
git check-ignore -v .memory 2>/dev/null || true

```

*If you see output pointing to a `.gitignore` line, remove that line.*

### 2. Initialize and Track Memory

```bash
mkdir -p .memory
git add .memory
git commit -m "chore(memory): start tracking session memory"

```

### 3. Daily Workflow: Committing Updates

```bash
git add .memory
git commit -m "chore(memory): session letter"

```

> **Tip:** Commit your memory **after** a session ends, rather than in the middle of one.

---

## Option B: Clean Diffs & Line Endings (Recommended Standard)

Most developers want memory in the repo but hate messy diffs or Windows/Linux line-ending issues.

### 1. Configure `.gitattributes` for Markdown

Run this to ensure clean diffs and consistent line endings:

```bash
cat >> .gitattributes <<'EOF'
# Better diffs for Markdown
*.md diff=markdown
*.md text eol=lf
EOF

```

### 2. Commit the Configuration

```bash
git add .gitattributes
git commit -m "chore(git): improve markdown diffs"

```

---

## Option C: Team Workflow (Shared vs. Private Memory)

For teams, `.memory/` is powerful, but you must distinguish between the **Shared Truth** (architecture decisions) and **Private Notes** (scratchpad).

### Pattern: The Split Strategy

* **Shared:** `.memory/shared/` → Versioned (Synced with team)
* **Private:** `.memory/private/` → Local only (Ignored)

#### 1. Create the Directory Structure

```bash
mkdir -p .memory/shared .memory/private

```

#### 2. Ignore Private, Track Shared

```bash
cat >> .gitignore <<'EOF'
# Private agent memory (local only)
.memory/private/
EOF

```

To ensure Git tracks the shared folder even if it starts empty:

```bash
touch .memory/shared/.keep
git add .memory/shared/.keep .gitignore
git commit -m "chore(memory): track shared memory, ignore private"

```

---

## Option D: Security Guardrails (No Secrets in Memory)

Prevent your agent from accidentally writing API keys or passwords into the memory logs.

### 1. Quick Scan for Secrets

Run this before committing to check for common keys (AWS, Private Keys, etc.):

```bash
rg -n --hidden --glob ".memory/**" \
  -e "AKIA[0-9A-Z]{16}" \
  -e "BEGIN( RSA)? PRIVATE KEY" \
  -e "SECRET" \
  -e "TOKEN" \
  -e "password" \
  .memory || echo "✅ No secrets found."

```

*(Requires `ripgrep` installed. If you don't have it, use `grep -r` instead).*

### 2. Create a Git Alias (Optional)

Add a `git memory-scan` command to your config:

```bash
git config alias.memory-scan '!rg -n --hidden --glob ".memory/**" -e "AKIA[0-9A-Z]{16}" -e "BEGIN( RSA)? PRIVATE KEY" -e "SECRET" -e "TOKEN" -e "password" .memory || echo "✅ Clean"'

```

Now you can just run:

```bash
git memory-scan

```

### 3. Redaction Workflow

If you find a secret:

1. **Edit the file:** Replace the secret with `[REDACTED]`.
2. **Commit:** `git commit -m "chore(memory): redact sensitive content"`

---

## Option E: Keeping History Clean

If you don't want memory updates cluttering your main feature history, use these strategies.

### Strategy 1: Filtered Logs (Same Branch)

Use a standard prefix like `chore(memory):` for all memory commits.

**To commit:**

```bash
git add .memory
git commit -m "chore(memory): 2026-01-29 session handoff"

```

**To view logs WITHOUT memory spam:**

```bash
git log --oneline --invert-grep --grep="^chore\(memory\):"

```

### Strategy 2: Orphan Branch (Best for Teams)

Keep code on `main` and memory on `memory/main`.

**Setup:**

```bash
git checkout -b memory/main
git push -u origin memory/main

```

**Workflow:**

```bash
git add .memory
git commit -m "chore(memory): session letter"
git push
git checkout main # Switch back to code

```

> **Benefit:** Memory is versioned and shareable, but pull requests remain purely about code.

---

## Option F: Archiving (For Long-Running Projects)

If you have too many files, move old ones to an archive folder.

### 1. Archive by Month

```bash
mkdir -p .memory/archive/2026-01
git mv .memory/2026-01-*.md .memory/archive/2026-01/ 2>/dev/null || true
git add .memory/archive/2026-01
git commit -m "chore(memory): archive 2026-01"

```

### 2. (Optional) Create a Monthly Index

```bash
cat .memory/archive/2026-01/*.md > .memory/archive/2026-01/INDEX.md
git add .memory/archive/2026-01/INDEX.md
git commit -m "chore(memory): add 2026-01 index"

```

---

# 🚀 Copy & Paste: The "Ideal Setup" (60 Seconds)

This script sets up the most robust default: **Shared memory is tracked, private is ignored, and diffs are clean.**

```bash
# 1. Create memory structure
mkdir -p .memory/shared .memory/private

# 2. Ignore private memory in .gitignore
cat >> .gitignore <<'EOF'

# Private agent memory (local only)
.memory/private/
EOF

# 3. Improve markdown diffs in .gitattributes
cat >> .gitattributes <<'EOF'
# Better diffs for Markdown
*.md diff=markdown
*.md text eol=lf
EOF

# 4. Keep shared directory present in git
touch .memory/shared/.keep

# 5. Commit everything
git add .gitignore .gitattributes .memory/shared/.keep
git commit -m "chore(memory): init memory versioning (shared tracked, private ignored)"

echo "✅ Memory versioning setup complete!"

```

---

# 🛠 Daily Workflow: The 3 Essential Commands

### 1. Commit Memory (End of Session)

```bash
git add .memory/shared
git commit -m "chore(memory): session handoff"

```

### 2. Scan for Secrets (Safety First)

```bash
git memory-scan

```

### 3. Review Recent Context Changes

```bash
git log -p -- .memory/shared

```
