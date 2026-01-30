#!/bin/bash
#
# Letter to My Future Self - First Time Setup
# Prompts for global Anthropic API key on plugin installation
#

CONFIG_DIR="$HOME/.config/letter-for-my-future-self"
CONFIG_FILE="$CONFIG_DIR/config.json"

# Only run if no global config exists
if [ -f "$CONFIG_FILE" ]; then
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
