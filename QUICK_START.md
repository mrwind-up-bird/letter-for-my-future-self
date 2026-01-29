# QUICK START — Letter to Myself (Claude Code Plugin)

**Goal:** install the plugin once, add it to any repo in seconds, and automatically persist a compact “handoff letter” between sessions.

---

## 0) Prerequisites

- **Claude Code** installed and working (you can run `claude` inside a project).
- **git**
- macOS / Linux shell *(Windows: use WSL)*

---

## 1) Install the plugin (one-time)

### Option A — Use the repo install script (recommended)

```bash
git clone https://github.com/mrwind-up-bird/letter-for-my-future-self.git
cd letter-for-my-future-self
chmod +x install_agents.sh
./install_agents.sh
```

That script is the canonical installer for this repo. If you’re curious what it does, read it first:

```bash
sed -n '1,200p' install_agents.sh
```

### Option B — Install as a local plugin via Claude CLI (if you prefer)

Depending on your Claude Code version, you can often install plugins from a local directory.

From inside the plugin repo:

```bash
# user scope (available in all projects)
claude plugin install . --scope user
```

If that doesn’t work in your version, fall back to **Option A**.

---

## 2) Add it to your project (per-repo)

In your target project:

```bash
cd /path/to/your-project
```

Copy the template into your project’s Claude instructions file:

```bash
cp /path/to/letter-for-my-future-self/CLAUDE_TEMPLATE.md ./CLAUDE.md
# or: merge the relevant sections into your existing CLAUDE.md
```

> If you already have a `CLAUDE.md`, **merge** rather than overwrite.

---

## 3) First run

Start Claude Code inside the project:

```bash
claude
```

Then verify the plugin is loaded:

- Type `/plugin` and check that the plugin is listed/enabled, **or**
- type `/` and look for **namespaced** commands/agents related to the plugin.

---

## 4) Generate your first “Last Will” letter

Typical workflows:

- End the session normally (exit / close Claude Code), **or**
- trigger whatever “checkpoint / save / last will” action the template sets up.

After that, you should see a local folder appear in your project:

```bash
ls -la .memory
```

You’ll find a Markdown note per session/day with:

- summary (what changed)
- decisions (and why)
- **Pain Log** (failures + workarounds)
- open threads + next steps
- important state/variables

---

## 5) Next session: resume instantly

Later (even days later):

```bash
cd /path/to/your-project
claude
```

Claude reads the `.memory/` note and you’re back in context without re-explaining everything.

---

## Troubleshooting

### Plugin installed but commands don’t show up
- Restart Claude Code.
- Verify plugin structure is valid (`.claude-plugin/plugin.json` exists at plugin root).
- Check plugin enablement via `/plugin` or `claude plugin list`.

### Hooks don’t fire / no `.memory/` output
- Ensure any scripts referenced by hooks are executable: `chmod +x scripts/*.sh`
- Confirm your `CLAUDE.md` includes the template instructions.

### You want memory to be private
Add `.memory/` to `.gitignore` (recommended for personal notes):

```gitignore
.memory/
```

Or commit it if you want team-level continuity.

---

## Quick sanity check (30 seconds)

```bash
cd /path/to/your-project
claude
# do a tiny change (edit a file, run a command)
# exit
ls -la .memory
```

If you see a new Markdown file in `.memory/`, you’re done ✅
