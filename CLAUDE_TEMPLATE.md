# Project Rules & Context

## 🧠 Memory Protocol
This project uses the **Letter to Myself** agent.

1.  **Startup:** Always check the `.memory/` directory. Read the file with the highest number (e.g., `letter_05.md`) to understand the current state.
2.  **Shutdown:** Before exiting or when asked to `/letter-checkpoint`, use the `letter-checkpoint` skill to write the next sequential letter.

## 🎨 Letter to Blog (Optional)
To enable automatic blog post generation from session memories:

1.  **One-time setup:** Run `/letter-init` to install the CI/CD pipeline
2.  **Add API key:** Set `ANTHROPIC_API_KEY` in GitHub repository secrets
3.  **Automatic:** Every push to `.memory/` triggers blog post generation

See [LETTER_TO_BLOG.md](./LETTER_TO_BLOG.md) for complete documentation.

## 📝 Coding Standards
(Add your normal coding standards here, e.g., TypeScript strict mode, Python PEP8, etc.)
