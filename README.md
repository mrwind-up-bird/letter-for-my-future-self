# 📨 Letter to Myself — Claude Code Context Persistence

> **"... when sessions end, chats get compacted, or days pass between work blocks."**

**Letter to Myself** is a plugin for **Claude Code** that keeps your project momentum intact — even when sessions end, chats get compacted, or days pass between work blocks.

Claude is brilliant in the moment. But “the moment” has a hard limit: **the context window**.  
This plugin adds a missing primitive: **continuity**.

It implements a simple but powerful protocol:

## 🧾 The “Last Will” Protocol (What it does)

Right before a session ends, Claude writes a structured **letter to your future self** into a local folder:

- **What we did** (high-signal summary)
- **Why we did it** (decisions + reasoning)
- **The Pain Log** (critical errors, root causes, workarounds)
- **State that matters** (active variables, constraints, open risks)
- **Next steps** (actionable, ranked)

Everything lands as a Markdown file in **`.memory/`**, so your next session can pick it up instantly — *without re-explaining the project to the model*.

**Result:** less token burn, fewer "wait what" moments, and a smoother "back into flow" experience.

---

## 🎨 NEW: Letter to Blog Pipeline

Transform your private session memories into **public-ready blog posts** automatically.

The plugin now includes a **CI/CD pipeline** that:
- Watches your `.memory/` folder for changes
- Uses Claude API to convert raw session logs into polished blog posts
- Creates pull requests with generated drafts
- Enables "Building in Public" with zero friction

**Setup:** Run `/letter-init` in your Claude Code session to install the pipeline.

**Learn more:** See [VIBE_CODING.md](./VIBE_CODING.md) for complete documentation.