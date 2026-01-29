# 📨 Letter to Myself — Claude Code Context Persistence

> **"Don't let your agent die with amnesia."**  [oai_citation:1‡README.md](sediment://file_0000000032b0722fbfb00fdbece16230)

**Letter to Myself** is a plugin fo [oai_citation:2‡README.md](sediment://file_0000000032b0722fbfb00fdbece16230)t keeps your project momentum intact — even when sessions end, chats get compacted, or days pass between work blocks.  [oai_citation:3‡README.md](sediment://file_0000000032b0722fbfb00fdbece16230)

Claude is brilliant in the moment.  [oai_citation:4‡README.md](sediment://file_0000000032b0722fbfb00fdbece16230)a hard limit: **the context window**.  
This plugin adds a missing primitive: **continuity**.

It implements a simple but powerful protocol:

## 🧾 The “Last Will” Protocol (What it does)

Right before a session ends, Claude writes a structured **letter to your future self** into a local folder:

- **What we did** (high-signal summary)
- **Why we did it** (decisions + reasoning)
- **The Pain Log** (critical errors, root causes, workarounds)
- **State that matters** (active variables, constraints, open risks)
- **Next steps** (actionable, ranked)

Everything lands as a Markdown file in **`.memory/`**, so your next session can pick it up instantly — *without re-explaining the project to the model*.  [oai_citation:5‡README.md](sediment://file_0000000032b0722fbfb00fdbece16230)

**Result:** less token burn, fewer  [oai_citation:6‡README.md](sediment://file_0000000032b0722fbfb00fdbece16230)and a smoother “back into flow” experience.  [oai_citation:7‡GitHub](https://github.com/mrwind-up-bird/letter-for-my-future-self)

---

## ✨ Why you’ll miss it once you have it

If you use Claude Code for real projects, you’ve probably felt at least one of these:

- You lose track of **what was decided** and end up re-litigating decisions.
- You forget the **one workaround** that made things finally work.
- You reopen a repo after a few days and waste tokens to rebuild context.
- You’re scared to compact or clear a chat because it’s your “only memory”.

**Letter to Myself** turns that fear into a routine:  
End the session → get a durable “handoff letter” → resume cleanly later.

---

## 🧠 What makes it different

This isn’t a generic summary bot. It’s a **project handoff** tool:

- **Opinionated structure** (so future-you can scan it fast)
- **Failure-aware** (Pain Log > pretty storytelling)
- **State-preserving** (variables, constraints, unresolved knots)
- **Local-first** (Markdown files you own and can version)

---

## 📂 Repository Structure

```text
.
├── .claude-plugin/         # Claude Code plugin metadata
├── agents/                 # Agent definitions
├── skills/                 # Skills used by the agent
├── CLAUDE_TEMPLATE.md      # Drop-in configuration for your projects
├── install_agents.sh       # Setup script to install/build the plugin
└── README.md               # This documentation