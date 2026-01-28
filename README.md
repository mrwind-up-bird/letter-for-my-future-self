# 📨 Letter to Myself: Claude Code Context Persistence

> **"Don't let your agent die with amnesia."**

**Letter to Myself** is a specialized Plugin for [Claude Code](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview). It solves the context window limit and session disconnection problem by implementing a **"Last Will" protocol**.

Before a session ends, the agent summarizes its work, critical errors ("The Pain Log"), and active variables into a structured Markdown file within a local `.memory/` folder. When you return days later, the agent reads this file and resumes exactly where it left off.

## 📂 Repository Structure

```text
.
├── README.md           # This documentation
├── install_agent.sh    # Setup script to build the plugin
└── CLAUDE_TEMPLATE.md  # Configuration to drop into your projects