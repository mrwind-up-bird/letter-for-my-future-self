#!/usr/bin/env python3
"""
Blog Generator for Vibe Coding Pipeline
Converts .memory/*.md files into polished blog posts using Anthropic API
"""

import os
import sys
from pathlib import Path
from datetime import datetime
import anthropic
from dotenv import load_dotenv

# Load environment variables
load_dotenv()


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
    api_key = os.getenv('ANTHROPIC_API_KEY')

    if not api_key:
        print("❌ ANTHROPIC_API_KEY not found in environment")
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
        model="claude-3-5-sonnet-20241022",
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
    print("🎨 Vibe Coding: Generating blog post...")

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
