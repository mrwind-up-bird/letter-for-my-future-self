---
name: letter-init
description: Initialize the Letter to Blog pipeline to transform memory files into public-ready blog posts via CI/CD.
---

# Letter Init Skill

This skill sets up the complete "Letter to Blog" pipeline that automatically converts your `.memory/` session letters into polished blog posts using GitHub Actions and the Anthropic API.

## When to Use

Invoke this skill when:
- User types `/letter-init`
- User wants to set up blog post generation from memory files
- User is setting up the repository for the first time

## What It Does

Creates the complete CI/CD infrastructure:
1. `.memory/` folder (if not exists)
2. `drafts/` folder for generated blog posts
3. `.github/scripts/blog_gen.py` - Python script using Anthropic API
4. `.github/scripts/vibe_requirements.txt` - Dependencies
5. `.github/workflows/vibe_publisher.yml` - GitHub Action workflow

## Execution Steps

### 1. Create Required Directories

```bash
mkdir -p .memory
mkdir -p drafts
mkdir -p .github/scripts
mkdir -p .github/workflows
```

### 2. Create the Blog Generator Script

Write the file `.github/scripts/blog_gen.py` with the following content:

```python
#!/usr/bin/env python3
"""
Blog Generator for Letter to Blog Pipeline
Converts .memory/*.md files into polished blog posts using Anthropic API
"""

import os
import sys
import json
from pathlib import Path
from datetime import datetime
import anthropic
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Config paths
GLOBAL_CONFIG = Path.home() / ".config" / "letter-for-my-future-self" / "config.json"
PROJECT_CONFIG = Path(".letter-config.json")

def get_api_key():
    """Get API key from environment, project config, or global config (in that order)"""
    # 1. Environment variable (highest priority)
    api_key = os.getenv('ANTHROPIC_API_KEY')
    if api_key:
        print("  Using API key from environment variable")
        return api_key

    # 2. Project-level config
    if PROJECT_CONFIG.exists():
        try:
            config = json.loads(PROJECT_CONFIG.read_text())
            api_key = config.get('anthropic_api_key')
            if api_key:
                print("  Using API key from project config")
                return api_key
        except (json.JSONDecodeError, IOError):
            pass

    # 3. Global config (fallback)
    if GLOBAL_CONFIG.exists():
        try:
            config = json.loads(GLOBAL_CONFIG.read_text())
            api_key = config.get('anthropic_api_key')
            if api_key:
                print("  Using API key from global config")
                return api_key
        except (json.JSONDecodeError, IOError):
            pass

    return None

def get_latest_memory_file():
    """Find the most recent letter file in .memory/"""
    memory_dir = Path(os.path.abspath('.memory'))

    if not memory_dir.exists():
        print("❌ .memory/ directory not found")
        sys.exit(1)

    # Find all letter_*.md files
    letter_files = sorted(memory_dir.glob('letter_*.md'), reverse=True)

    if not letter_files:
        print("❌ No letter files found in .memory/")
        sys.exit(1)

    return letter_files[0]

def generate_blog_post(memory_content: str) -> str:
    """Use Anthropic API to convert memory file to blog post"""
    api_key = get_api_key()

    if not api_key:
        print("❌ No API key found. Set ANTHROPIC_API_KEY or run --setup")
        sys.exit(1)

    client = anthropic.Anthropic(api_key=api_key)

    prompt = f"""You are a technical blog writer. Convert this development session memory into an engaging, public-ready blog post.

INPUT (Session Memory):
{memory_content}

REQUIREMENTS:
1. Transform technical decisions into narrative insights
2. Keep the "Pain Log" as "Lessons Learned" or "Challenges"
3. Make it readable for a general developer audience
4. Add markdown frontmatter with: title, date, tags, excerpt
5. Use proper markdown formatting with headers, code blocks, lists
6. Maintain technical accuracy but improve readability

OUTPUT FORMAT:
---
title: "[Engaging Title]"
date: {datetime.now().strftime('%Y-%m-%d')}
tags: [relevant, tags, here]
excerpt: "Brief summary of the post"
---

[Blog post content in markdown]

Generate the blog post now:"""

    message = client.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=4096,
        messages=[
            {"role": "user", "content": prompt}
        ]
    )

    return message.content[0].text

def save_blog_post(content: str, source_file: Path):
    """Save generated blog post to drafts/"""
    drafts_dir = Path(os.path.abspath('drafts'))
    drafts_dir.mkdir(exist_ok=True)

    # Generate filename based on source
    timestamp = datetime.now().strftime('%Y-%m-%d')
    output_file = drafts_dir / f"blog_{timestamp}_{source_file.stem}.md"

    output_file.write_text(content, encoding='utf-8')
    print(f"✅ Blog post generated: {output_file}")
    return output_file

def main():
    """Main execution flow"""
    print("🎨 Letter to Blog: Generating blog post...")

    # Get latest memory file
    memory_file = get_latest_memory_file()
    print(f"📖 Reading: {memory_file}")

    # Read content
    memory_content = memory_file.read_text(encoding='utf-8')

    # Generate blog post
    print("🤖 Calling Anthropic API...")
    blog_content = generate_blog_post(memory_content)

    # Save to drafts
    output_file = save_blog_post(blog_content, memory_file)

    print(f"✅ Success! Blog post saved to: {output_file}")
    print("🚀 Ready for review and publishing!")

if __name__ == "__main__":
    main()
```

### 3. Create Requirements File

Write the file `.github/scripts/vibe_requirements.txt`:

```
anthropic>=0.18.0
python-dotenv>=1.0.0
```

### 4. Create GitHub Actions Workflow

Write the file `.github/workflows/vibe_publisher.yml`:

```yaml
name: Vibe Publisher - Memory to Blog

on:
  push:
    paths:
      - '.memory/**'
  workflow_dispatch:

jobs:
  generate-blog:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r .github/scripts/vibe_requirements.txt

      - name: Generate blog post
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          python .github/scripts/blog_gen.py

      - name: Create Pull Request
        uses: peter-evans/create-pull-request@v6
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          commit-message: 'feat(blog): generate post from memory session'
          title: '📝 New Blog Post from Session Memory'
          body: |
            ## 🎨 Letter to Blog Pipeline

            Auto-generated blog post from latest session memory.

            **Generated by:** Anthropic Claude API
            **Source:** `.memory/` folder
            **Output:** `drafts/` folder

            ### Next Steps
            - [ ] Review the generated content
            - [ ] Edit for style/branding if needed
            - [ ] Move to your blog publishing location
            - [ ] Merge when ready
          branch: blog-automation-${{ github.run_number }}
          delete-branch: true
```

### 5. Update .gitignore (if needed)

Check if `drafts/` should be tracked. Typically, you WANT to track generated drafts, but verify:

```bash
grep -q "^drafts/" .gitignore || echo "✅ drafts/ will be tracked in git"
```

### 6. Provide User Instructions

Print the following success message:

```
✅ Letter to Blog Pipeline Initialized!

📁 Created:
  - .memory/         (Memory storage)
  - drafts/          (Generated blog posts)
  - .github/scripts/blog_gen.py
  - .github/scripts/vibe_requirements.txt
  - .github/workflows/vibe_publisher.yml

🔐 Setup Required:
  Add your Anthropic API key to GitHub Secrets:

  1. Go to: Settings → Secrets and variables → Actions
  2. Click "New repository secret"
  3. Name: ANTHROPIC_API_KEY
  4. Value: Your API key from https://console.anthropic.com

🚀 How It Works:
  - When you push changes to .memory/*.md
  - GitHub Actions automatically runs blog_gen.py
  - A new blog post appears in drafts/
  - Pull request is created for review

💡 Manual Run:
  python .github/scripts/blog_gen.py
```

## Important Notes

- The workflow requires `ANTHROPIC_API_KEY` in GitHub Secrets
- Generated blog posts go to `drafts/` for review before publishing
- The CI/CD pipeline creates a PR automatically (not direct push)
- Users can manually run the script locally for testing
- **Local testing**: The script now supports fallback API key lookup:
  1. Environment variable `ANTHROPIC_API_KEY`
  2. Project config `.letter-config.json`
  3. Global config `~/.config/letter-for-my-future-self/config.json`
