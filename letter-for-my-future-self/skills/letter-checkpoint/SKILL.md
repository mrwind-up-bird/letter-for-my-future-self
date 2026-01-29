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
echo "$content" > .memory/"$filename"
echo "✅ Checkpoint saved to .memory/$filename"
