#!/bin/bash
#
# Letter to My Future Self — Plugin Installer
#
# Installs the agent and skills to ~/.claude/ for global availability.
# Run this from the plugin repository root.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DIR="$HOME/.claude/agents"
SKILLS_DIR="$HOME/.claude/skills"

echo "Installing 'Letter to My Future Self' Claude Plugin..."
echo ""

# 1. Install agent
if [ -f "$SCRIPT_DIR/agents/letter-for-myself.md" ]; then
  mkdir -p "$AGENTS_DIR"
  cp "$SCRIPT_DIR/agents/letter-for-myself.md" "$AGENTS_DIR/letter-for-my-future-self.md"
  echo "  Agent installed: $AGENTS_DIR/letter-for-my-future-self.md"
else
  echo "  WARNING: agents/letter-for-myself.md not found — skipping agent"
fi

# 2. Install skills
if [ -f "$SCRIPT_DIR/skills/letter-init/SKILL.md" ]; then
  mkdir -p "$SKILLS_DIR/letter-init"
  cp "$SCRIPT_DIR/skills/letter-init/SKILL.md" "$SKILLS_DIR/letter-init/SKILL.md"
  echo "  Skill installed: /letter-init"
fi

if [ -f "$SCRIPT_DIR/skills/letter-checkpoint/SKILL.md" ]; then
  mkdir -p "$SKILLS_DIR/checkpoint"
  cp "$SCRIPT_DIR/skills/letter-checkpoint/SKILL.md" "$SKILLS_DIR/checkpoint/SKILL.md"
  echo "  Skill installed: /checkpoint"
fi

echo ""
echo "Installation complete!"
echo ""
echo "Usage:"
echo "  /checkpoint    — Save a session memory to .memory/"
echo "  /letter-init   — Set up the Letter to Blog CI/CD pipeline"
echo ""
echo "To enable blog generation, run:"
echo "  python3 $SCRIPT_DIR/.github/scripts/blog_gen.py --setup"
