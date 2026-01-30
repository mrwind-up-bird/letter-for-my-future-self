#!/bin/bash
#
# Letter to My Future Self - Project Initialization Check
# Runs on SessionStart to detect new projects and set up infrastructure
#

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(dirname "$(dirname "$0")")}"
PROJECT_CONFIG=".letter-config.json"
GLOBAL_CONFIG="$HOME/.config/letter-for-my-future-self/config.json"
MEMORY_DIR=".memory"
INIT_MARKER="$MEMORY_DIR/.initialized"

# Skip if already initialized in this project
if [ -f "$INIT_MARKER" ]; then
  exit 0
fi

# Create required directories
mkdir -p "$MEMORY_DIR"
mkdir -p "drafts"
mkdir -p ".github/scripts"
mkdir -p ".github/workflows"

# Copy blog generator infrastructure from plugin (if source exists and target doesn't)
if [ -d "$PLUGIN_ROOT/.github/scripts" ]; then
  if [ ! -f ".github/scripts/blog_gen.py" ]; then
    cp "$PLUGIN_ROOT/.github/scripts/blog_gen.py" ".github/scripts/blog_gen.py" 2>/dev/null
  fi
  if [ ! -f ".github/scripts/vibe_requirements.txt" ]; then
    cp "$PLUGIN_ROOT/.github/scripts/vibe_requirements.txt" ".github/scripts/vibe_requirements.txt" 2>/dev/null
  fi
fi

if [ -d "$PLUGIN_ROOT/.github/workflows" ]; then
  if [ ! -f ".github/workflows/vibe_publisher.yml" ]; then
    cp "$PLUGIN_ROOT/.github/workflows/vibe_publisher.yml" ".github/workflows/vibe_publisher.yml" 2>/dev/null
  fi
fi

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

# Show what was created
if [ -f ".github/scripts/blog_gen.py" ]; then
  echo "  Blog Pipeline: Installed (.github/scripts/blog_gen.py)"
else
  echo "  Blog Pipeline: Not installed (run /letter-init manually)"
fi

if [ "$has_env" = true ]; then
  echo "  API Key: Using environment variable"
elif [ "$has_project" = true ]; then
  echo "  API Key: Using project config ($PROJECT_CONFIG)"
elif [ "$has_global" = true ]; then
  echo "  API Key: Using global config"
else
  echo "  API Key: Not configured (blog generation disabled)"
  echo "  Tip: Run 'python3 .github/scripts/blog_gen.py --setup' to configure"
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
