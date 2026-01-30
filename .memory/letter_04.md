# Letter to Myself (Session Handoff)

**Date:** 2026-01-30 13:15

## 1. Executive Summary
* **Goal:** Fix Letter to Blog blog generation pipeline failures in GitHub Actions
* **Current Status:** Complete — two bugs fixed and pushed, awaiting workflow re-run

## 2. The "Done" List (Context Anchor)
* Configured global Anthropic API key at `~/.config/letter-for-my-future-self/config.json`
* Fixed outdated model ID in `.github/scripts/blog_gen.py` (line 216)
  - Changed from `claude-3-5-sonnet-20241022` to `claude-sonnet-4-20250514`
* Fixed file sorting bug in `get_latest_memory_file()` function (lines 157-179)
  - Was: alphabetic sort (`letter_example.md` > `letter_03.md`)
  - Now: numeric sort using regex to match `letter_XX.md` pattern only
* Pushed commits: ea81c8a (model fix), d1b2eb4 (sorting fix)

## 3. The "Pain" Log (CRITICAL)
* **Tried:** Using model `claude-3-5-sonnet-20241022`
* **Failed:** `anthropic.NotFoundError: 404 - model: claude-3-5-sonnet-20241022`
* **Workaround:** Updated to current model `claude-sonnet-4-20250514`
* *Note:* Model IDs change over time — consider using model aliases if Anthropic provides them

* **Tried:** Alphabetic sorting of letter files with `sorted(..., reverse=True)`
* **Failed:** `letter_example.md` selected instead of `letter_03.md` (alphabetic: 'e' > '0')
* **Workaround:** Added regex matching for `letter_(\d+)\.md` pattern with numeric sorting

## 4. Active Variable State
* Global API key: `~/.config/letter-for-my-future-self/config.json` (ends with `...HwAA`)
* GitHub secret: `ANTHROPIC_API_KEY` configured in repo settings
* Current branch: `main` at commit `d1b2eb4`
* Workflow: `vibe_publisher.yml` should auto-trigger on .memory/ changes

## 5. Immediate Next Steps
1. [ ] Monitor GitHub Actions for successful blog generation
2. [ ] Review generated PR in `drafts/` directory
3. [ ] Consider adding model ID as configurable option in blog_gen.py
4. [ ] Fix setup-api-key.sh non-interactive TTY issue (from letter_03)
