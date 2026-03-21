# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Claude Code plugin called "Letter to Myself" that implements context persistence between Claude sessions. The plugin provides an agent and skill that automatically write structured "Last Will" summaries to a `.memory/` folder, enabling seamless continuity when sessions end, get compacted, or when days pass between work sessions.

## Core Components

### Plugin Structure
- `.claude-plugin/plugin.json` - Plugin manifest (v1.0.5) defining name, version, and component paths
- `.claude-plugin/marketplace.json` - Marketplace listing metadata
- `agents/letter-for-myself.md` - Agent persona that handles checkpoint creation
- `skills/letter-checkpoint/SKILL.md` - Skill that writes memory checkpoints to disk
- `skills/letter-init/SKILL.md` - Skill that sets up the Letter to Blog CI/CD pipeline
- `hooks/hooks.json` - Plugin hooks (Setup and SessionStart)
- `scripts/setup-api-key.sh` - First-time setup: installs agent/skills to `~/.claude/`, prompts for API key
- `scripts/check-project-key.sh` - Per-project initialization: creates directories, copies infrastructure, shows status
- `CLAUDE_TEMPLATE.md` - Template users copy to their projects to enable the plugin
- `install_agents.sh` - Legacy installation script that creates a nested plugin structure

### Letter to Blog Pipeline (NEW)
The plugin now includes a "Letter to Blog" feature that automatically transforms memory files into public-ready blog posts:
- `.github/scripts/blog_gen.py` - Python script using Anthropic API for blog generation
- `.github/scripts/vibe_requirements.txt` - Python dependencies (anthropic, python-dotenv)
- `.github/workflows/vibe_publisher.yml` - GitHub Actions workflow triggered on .memory/ changes
- `drafts/` - Output directory for generated blog posts

### The Memory Protocol
- Memory files are stored in `.memory/` as timestamp-named markdown files (`letter_YYYYMMDDHHMMSS.md`)
- Each file follows a strict template with sections: Executive Summary, Done List, Pain Log, Variable State, Next Steps
- On startup, the agent reads the most recent letter file (sorted by timestamp) to restore context
- On checkpoint/exit, the agent generates a new letter with current timestamp
- Legacy formats (`letter_YYYYMMDD_XXXX.md`, `letter_XX.md`) are still supported for backwards compatibility

## Installation & Usage

### Installing the Plugin
```bash
# Option A: Use the installation script (recommended)
chmod +x install_agents.sh
./install_agents.sh

# Option B: Install as local plugin
claude plugin install . --scope user
```

### Adding to a Project
Copy `CLAUDE_TEMPLATE.md` into the target project as `CLAUDE.md` (or merge if one exists).

### Triggering Checkpoints
The agent activates when users type:
- `/checkpoint`
- `exit` or indicates session is ending
- "wrap up"

### Setting Up Letter to Blog
Initialize the blog generation pipeline by running:
```bash
/letter-init
```

This creates:
1. Required directories (.memory/, drafts/, .github/scripts/, .github/workflows/)
2. Blog generator script with Anthropic API integration
3. GitHub Actions workflow for automatic blog post generation
4. Python dependencies file

**Required Setup:**
Add `ANTHROPIC_API_KEY` to GitHub repository secrets (Settings → Secrets and variables → Actions)

**How It Works:**
1. Push changes to `.memory/*.md` files
2. GitHub Actions automatically triggers
3. Latest memory file is converted to blog post using Claude
4. Pull request created with generated draft in `drafts/`
5. Review and merge when ready

## Memory Versioning

See `MEMORY_VERSIONING.md` for comprehensive Git workflows:
- **Option A**: Full versioning (recommended for solo projects)
- **Option B**: Clean diffs with `.gitattributes` configuration
- **Option C**: Team workflow with shared/private split
- **Option D**: Security guardrails to prevent secrets in memory
- **Option E**: Keep history clean with filtered logs or orphan branches
- **Option F**: Archiving strategies for long-running projects

Key commands for memory management:
```bash
# Commit memory after session
git add .memory/shared
git commit -m "chore(memory): session handoff"

# Scan for secrets before committing
rg -n --hidden --glob ".memory/**" -e "AKIA[0-9A-Z]{16}" -e "BEGIN( RSA)? PRIVATE KEY" .memory
```

## Architecture Notes

### Plugin Design Philosophy
- **Continuity over context**: Addresses the fundamental limitation of Claude's context window by creating persistent memory
- **Minimal friction**: Automatic checkpoint creation on session end
- **Structured format**: Strict template ensures consistent, actionable handoffs
- **Pain Log emphasis**: Critical section for documenting failures and workarounds to prevent repeated mistakes

### Agent Behavior
The `letter-for-myself` agent operates in two modes:
1. **Normal mode**: Acts as a standard coding assistant
2. **Checkpoint mode**: Triggered by exit signals, stops all work to review conversation history and generate a summary

### Skill Execution
The `letter-checkpoint` skill:
1. Creates `.memory/` directory if needed
2. Lists existing letter files to determine next sequential number
3. Writes the generated letter using the Write tool
4. Confirms to user with filename

## File Organization

<!-- AUTO-GENERATED: file-organization -->
```
.
├── .claude-plugin/
│   ├── plugin.json           # Plugin manifest (v1.0.5)
│   └── marketplace.json      # Marketplace listing metadata
├── agents/
│   └── letter-for-myself.md  # Agent persona definition
├── skills/
│   ├── letter-checkpoint/
│   │   └── SKILL.md          # Checkpoint skill definition
│   └── letter-init/
│       └── SKILL.md          # Letter to Blog init skill
├── hooks/
│   └── hooks.json            # Setup & SessionStart hooks
├── scripts/
│   ├── setup-api-key.sh      # First-time setup (agent + API key)
│   └── check-project-key.sh  # Per-project initialization
├── .github/
│   ├── scripts/
│   │   ├── blog_gen.py       # Blog generator (CLI with --setup/--status/--file)
│   │   └── vibe_requirements.txt
│   └── workflows/
│       └── vibe_publisher.yml
├── CLAUDE_TEMPLATE.md        # Template for user projects
├── install_agents.sh         # Legacy installation script
├── MEMORY_VERSIONING.md      # Git workflow guide
├── QUICK_START.md            # User installation guide
└── README.md                 # Project documentation
```
<!-- /AUTO-GENERATED: file-organization -->
