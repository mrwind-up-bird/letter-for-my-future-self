# 📨 Letter to Myself: Claude Code Context Persistence

> **"Don't let your agent die with amnesia."**

This is a **Plugin for Claude Code** that solves the context window problem. It creates a "Last Will" protocol where the agent summarizes its state, solved problems, and active variables into a local `.memory/` folder before the session ends.

## 🚀 Features

* **Persistence:** Writes structured markdown summaries to your local filesystem.
* **The "Pain Log":** Specifically records failed attempts and errors to prevent future loops.
* **Rolling Context:** Automatically reads the previous session's letter upon startup.
* **Zero-Config Handover:** Resume work days later with zero context loss.

---

## 🛠️ Installation

### 1. Generate the Plugin
We provide a setup script to create the necessary directory structure and plugin files.

1.  Download the `install_agent.sh` file from this repo.
2.  Run it in your terminal:
    ```bash
    chmod +x install_agent.sh
    ./install_agent.sh
    ```

### 2. Register with Claude
Once the folder `letter-to-myself` is created, register it with Claude Code:

```bash
# Assuming you are in the same folder where you ran the script
claude plugin add ./letter-to-myself
