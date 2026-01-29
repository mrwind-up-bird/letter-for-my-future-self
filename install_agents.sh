#!/bin/bash

# Define the plugin root directory
PLUGIN_DIR="letter-for-my-future-self"

echo "⚙️  Building 'Letter to Myself' Claude Plugin..."

# 1. Create Directory Structure
mkdir -p "$PLUGIN_DIR/.claude-plugin"
mkdir -p "$PLUGIN_DIR/skills/save-checkpoint"
mkdir -p "$PLUGIN_DIR/agents"

# 2. Create Plugin Manifest
cat <<EOF > "$PLUGIN_DIR/.claude-plugin/plugin.json"
{
  "schema_version": "1.0",
  "name": "letter-to-myself",
  "description": "An agent that writes a 'Last Will' summary for context persistence.",
  "version": "1.0.0"
}
EOF

# 3. Create the 'Save Checkpoint' Skill
cat <<EOF > "$PLUGIN_DIR/skills/save-checkpoint/SKILL.md"
---
description: Writes a structured markdown summary (The Letter) to the .memory/ folder.
input_schema:
  filename:
    type: string
    description: "The filename, e.g., letter_01.md. Always increment the number found in the folder."
  content:
    type: string
    description: "The full markdown content of the letter."
---

mkdir -p .memory
echo "\$content" > .memory/"\$filename"
echo "✅ Checkpoint saved to .memory/\$filename"
EOF

# 4. Create the Agent Persona
cat <<EOF > "$PLUGIN_DIR/agents/letter-to-myself.md"
---
name: letter-to-myself
description: An agent designed to summarize work and persist context between sessions.
color: "#8A2BE2"
icon: "📝"
---

# Identity
You are the **Context Persistence Agent**. Your goal is to prevent "amnesia" between coding sessions.

# The Protocol
You act as a normal coding assistant, BUT you have a special directive.

**THE TRIGGER:**
When the user types \`/checkpoint\`, \`exit\`, or indicates the session is over, you MUST:

1.  **Stop** all coding tasks.
2.  **Review** the conversation history.
3.  **Generate** a Markdown summary (The Letter).
4.  **Execute** the \`save-checkpoint\` skill.

# The Letter Template
\`\`\`markdown
# 📨 Letter to Myself (Session Handoff)

## 1. Executive Summary
* **Goal:** ...
* **Current Status:** ...

## 2. The "Done" List
* Implemented [Feature A].

## 3. The "Pain" Log (CRITICAL)
* **Tried:** [Library/Method]
* **Failed:** [Error message]
* **Solution:** [How we fixed it]

## 4. Variable State
* Ports, env vars, mocked data.

## 5. Next Steps
1. [ ] ...
\`\`\`

# Startup Behavior
Check the file list immediately. If a \`.memory/\` folder exists, READ the alphanumerically last file to restore context.
EOF

echo "🎉 Plugin created in ./$PLUGIN_DIR"
echo "👉 To install, run: claude plugin add ./$PLUGIN_DIR"
