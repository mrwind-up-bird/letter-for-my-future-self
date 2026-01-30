#!/bin/bash
#
# Letter to My Future Self - First Time Setup
# - Installs agent to ~/.claude/agents/
# - Prompts for global Anthropic API key
#

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(dirname "$(dirname "$0")")}"
CONFIG_DIR="$HOME/.config/letter-for-my-future-self"
CONFIG_FILE="$CONFIG_DIR/config.json"
AGENTS_DIR="$HOME/.claude/agents"
AGENT_FILE="letter-for-my-future-self.md"

# Always install/update the agent
if [ -d "$PLUGIN_ROOT/agents" ] && [ -f "$PLUGIN_ROOT/agents/letter-for-myself.md" ]; then
  mkdir -p "$AGENTS_DIR"
  cp "$PLUGIN_ROOT/agents/letter-for-myself.md" "$AGENTS_DIR/$AGENT_FILE"
  echo "Installed agent to $AGENTS_DIR/$AGENT_FILE"
fi

# Only prompt for API key if no global config exists
if [ -f "$CONFIG_FILE" ]; then
  echo "Setup complete! (API key already configured)"
  exit 0
fi

echo ""
echo "=========================================="
echo "  Letter to My Future Self - Setup"
echo "=========================================="
echo ""
echo "This plugin can generate blog posts from your session memories"
echo "using the Anthropic API (optional feature)."
echo ""

# Check if running interactively
if [ -t 0 ]; then
  read -p "Enter your Anthropic API key (or press Enter to skip): " api_key

  if [ -n "$api_key" ]; then
    mkdir -p "$CONFIG_DIR"
    cat > "$CONFIG_FILE" << EOF
{
  "anthropic_api_key": "$api_key"
}
EOF
    chmod 600 "$CONFIG_FILE"
    echo ""
    echo "Global API key saved to: $CONFIG_FILE"
    echo ""
  else
    echo ""
    echo "Skipped. You can set up later with:"
    echo "  python3 <plugin-path>/.github/scripts/blog_gen.py --setup"
    echo ""
  fi
else
  # Non-interactive - just inform
  echo "To enable blog generation, run:"
  echo "  python3 <plugin-path>/.github/scripts/blog_gen.py --setup"
  echo ""
fi

echo "Setup complete!"
