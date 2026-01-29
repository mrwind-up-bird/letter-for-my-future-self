# 🎨 Vibe Coding: Memory to Blog Pipeline

## What Is This?

**Vibe Coding** is an extension to the "Letter to Myself" plugin that automatically transforms your private session memories into public-ready blog posts using Claude API and GitHub Actions.

It solves a common problem: you're building cool stuff and learning valuable lessons, but you never get around to writing about it. This pipeline does it for you.

---

## How It Works

```
.memory/letter_03.md  →  GitHub Actions  →  Claude API  →  drafts/blog_2026-01-29_letter_03.md
```

1. **You work normally** - Claude Code saves session memories to `.memory/`
2. **Git push triggers** - GitHub Actions detects changes to `.memory/**`
3. **Claude transforms** - The blog_gen.py script calls Anthropic API
4. **PR created** - A pull request appears with the generated blog post in `drafts/`
5. **You review & publish** - Edit if needed, then merge

---

## Installation

### Step 1: Initialize the Pipeline

In your Claude Code session:

```
/letter-init
```

This creates:
- `.memory/` - Memory storage (if not exists)
- `drafts/` - Generated blog posts
- `.github/scripts/blog_gen.py` - Python generator script
- `.github/scripts/vibe_requirements.txt` - Dependencies
- `.github/workflows/vibe_publisher.yml` - GitHub Actions workflow

### Step 2: Add Your API Key to GitHub Secrets

1. Get your Anthropic API key from https://console.anthropic.com
2. Go to your repository: **Settings → Secrets and variables → Actions**
3. Click **"New repository secret"**
4. Name: `ANTHROPIC_API_KEY`
5. Value: Your API key (starts with `sk-ant-`)
6. Click **"Add secret"**

### Step 3: Commit and Push

```bash
git add .github/ drafts/ .memory/
git commit -m "feat: add vibe coding pipeline"
git push
```

---

## Usage

### Automatic Mode (Default)

Every time you push changes to `.memory/*.md`:

1. GitHub Actions automatically triggers
2. Blog post is generated
3. Pull request is created
4. Review in `drafts/` folder

### Manual Mode (Local Testing)

Test the generator locally before pushing:

```bash
# Install dependencies
pip install -r .github/scripts/vibe_requirements.txt

# Set your API key
export ANTHROPIC_API_KEY="sk-ant-..."

# Run the generator
python .github/scripts/blog_gen.py
```

Output appears in `drafts/blog_YYYY-MM-DD_letter_XX.md`

---

## Generated Blog Post Format

The script transforms your session memory into a structured blog post with:

### Frontmatter (YAML)
```yaml
---
title: "Descriptive Title Based on Your Work"
date: 2026-01-29
tags: [python, debugging, api-integration]
excerpt: "Brief summary of what you built/learned"
---
```

### Content Structure
- **The Context** - What you were building
- **The Problem** - Challenges encountered
- **The Fix** - Solutions with code snippets
- **The Lesson** - Takeaways and insights

---

## Customization

### Change the AI Model

Edit `.github/scripts/blog_gen.py`:

```python
model="claude-3-5-sonnet-20241022",  # Current default
# OR
model="claude-opus-4-5-20251101",    # For higher quality (costs more)
```

### Modify the Writing Style

Edit the `prompt` in `generate_blog_post()` function:

```python
prompt = f"""You are a [YOUR STYLE HERE]. Convert this development session...
```

Examples:
- `"You are a friendly developer sharing lessons learned"`
- `"You are a senior engineer writing for junior developers"`
- `"You are a technical blogger focusing on practical takeaways"`

### Change Output Location

Edit `save_blog_post()` function:

```python
drafts_dir = Path(os.path.abspath('blog/posts'))  # Instead of 'drafts'
```

---

## Architecture

### Files Created

```
.
├── .github/
│   ├── scripts/
│   │   ├── blog_gen.py              # Main generator (Python)
│   │   └── vibe_requirements.txt    # anthropic, python-dotenv
│   └── workflows/
│       └── vibe_publisher.yml       # GitHub Actions workflow
├── .memory/
│   └── letter_*.md                  # Session memories (input)
└── drafts/
    └── blog_*_letter_*.md           # Generated posts (output)
```

### Workflow Steps

The GitHub Action (`.github/workflows/vibe_publisher.yml`) runs these steps:

1. **Checkout** - Get repository code
2. **Setup Python** - Install Python 3.11
3. **Install Deps** - `pip install -r .github/scripts/vibe_requirements.txt`
4. **Generate** - `python .github/scripts/blog_gen.py` with ANTHROPIC_API_KEY
5. **Create PR** - Uses `peter-evans/create-pull-request@v6`

### Security Notes

- API key is stored in **GitHub Secrets** (encrypted)
- Never commit the API key to the repository
- The script loads the key from environment variables only
- Pull requests are created (not direct pushes) for review

---

## Troubleshooting

### "❌ ANTHROPIC_API_KEY not found in environment"

**Cause:** The GitHub secret is not set or has the wrong name.

**Fix:**
1. Go to Settings → Secrets and variables → Actions
2. Verify secret is named exactly `ANTHROPIC_API_KEY`
3. Re-run the workflow

### "❌ No letter files found in .memory/"

**Cause:** The `.memory/` directory is empty or doesn't contain `letter_*.md` files.

**Fix:**
1. Run a Claude Code session with the plugin
2. Use `/checkpoint` to create a memory file
3. Verify files exist: `ls -la .memory/`

### Workflow Doesn't Trigger

**Cause:** The workflow is triggered only on changes to `.memory/**` on the `main` branch.

**Fix:**
1. Check you're pushing to `main` (or edit the workflow file)
2. Verify changes include files in `.memory/` folder
3. Check Actions tab for error messages

### Generated Post Quality Issues

**Solutions:**
- Edit the prompt in `blog_gen.py` to be more specific
- Use a higher-quality model (Opus instead of Sonnet)
- Increase `max_tokens` for longer posts
- Add examples of your preferred style to the prompt

---

## Cost Estimation

Using Claude 3.5 Sonnet (default):
- Input: ~$3 per million tokens
- Output: ~$15 per million tokens

Typical session memory: 1,000 tokens input
Typical blog post: 2,000 tokens output

**Cost per blog post:** ~$0.03 USD

For 100 blog posts per month: **~$3/month**

---

## Advanced: Integration with Static Site Generators

### Hugo

```bash
# Modify blog_gen.py output path:
output_file = Path('content/posts') / f"{timestamp}-{source_file.stem}.md"
```

### Jekyll

```bash
# Modify blog_gen.py output path:
output_file = Path('_posts') / f"{timestamp}-{title_slug}.md"
```

### Astro/Next.js

```bash
# Output to your content directory:
output_file = Path('src/content/blog') / f"{timestamp}-post.md"
```

---

## FAQ

**Q: Can I use this without GitHub Actions?**
A: Yes! Run `python .github/scripts/blog_gen.py` locally and commit the results manually.

**Q: Can I edit the generated blog posts?**
A: Absolutely. The `drafts/` folder is for review and editing before publishing.

**Q: Will this work with other AI providers?**
A: Currently it's designed for Anthropic's API, but you can modify `blog_gen.py` to use OpenAI, Google, etc.

**Q: Can I generate posts from multiple memory files?**
A: The default script processes the latest file. You can modify it to process all files in a loop.

**Q: How do I disable the pipeline temporarily?**
A: Rename or delete `.github/workflows/vibe_publisher.yml`, or disable the workflow in the GitHub Actions UI.

---

## Contributing

Ideas for enhancements:
- [ ] Support for multiple output formats (HTML, PDF, Twitter threads)
- [ ] Automatic posting to Dev.to, Medium, Hashnode
- [ ] Image generation for featured images
- [ ] Multi-language support
- [ ] Custom templates per project

---

## Learn More

- [Anthropic API Documentation](https://docs.anthropic.com)
- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Building in Public Resources](https://www.buildinpublic.xyz)

---

**Built with ❤️ by the Letter to Myself community**
