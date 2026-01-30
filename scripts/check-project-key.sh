#!/bin/bash
#
# Letter to My Future Self - Project Initialization Check
# Runs on SessionStart to detect new projects and offer project-specific config
#

PROJECT_CONFIG=".letter-config.json"
GLOBAL_CONFIG="$HOME/.config/letter-for-my-future-self/config.json"
MEMORY_DIR=".memory"
INIT_MARKER="$MEMORY_DIR/.initialized"

# Skip if already initialized in this project
if [ -f "$INIT_MARKER" ]; then
  exit 0
fi

# Create .memory directory if it doesn't exist
mkdir -p "$MEMORY_DIR"

# Check for existing configurations
has_global=false
has_project=false
has_env=false

[ -f "$GLOBAL_CONFIG" ] && has_global=true
[ -f "$PROJECT_CONFIG" ] && has_project=true
[ -n "$ANTHROPIC_API_KEY" ] && has_env=true

# First time in this project - show status
echo ""
echo "[Letter to My Future Self] Project initialized"

if [ "$has_env" = true ]; then
  echo "  API Key: Using environment variable"
elif [ "$has_project" = true ]; then
  echo "  API Key: Using project config ($PROJECT_CONFIG)"
elif [ "$has_global" = true ]; then
  echo "  API Key: Using global config"
  echo "  Tip: Run 'python3 blog_gen.py --setup-project' for a project-specific key"
else
  echo "  API Key: Not configured (blog generation disabled)"
  echo "  Tip: Run 'python3 blog_gen.py --setup' to configure"
fi

echo ""

# Mark as initialized
touch "$INIT_MARKER"

# Add init marker to .gitignore if not already there
if [ -f ".gitignore" ]; then
  if ! grep -q "^\.memory/\.initialized$" .gitignore 2>/dev/null; then
    echo ".memory/.initialized" >> .gitignore
  fi
fi
