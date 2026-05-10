# claude-code-surgeon

Surgical tools that fill the gaps Claude Code should have shipped with.

Each tool solves one problem. No frameworks. No dependencies beyond `bash`, `jq`, `python3`. Install what you need, ignore the rest.

---

## What's Inside

| Tool | Problem It Solves |
|---|---|
| `cc-anchor` | Context compaction destroys your working memory. Anchor preserves critical facts across resets. |
| `cc-guard` | CLAUDE.md rules are treated as suggestions. Guard enforces them at the hook level. |
| `cc-mcp-reload` | MCP server reconnect doesn't reload tools. This forces it. |
| `cc-global-skills` | Global skills are invisible in new sessions. This injects them. |
| `cc-headless` | Headless mode has no retries, no timeout handling. This wraps it properly. |
| `cc-harmonize` | Multiple AI tools = conflicting memory files. This detects the conflicts. |

---

## Quick Install

```bash
git clone https://github.com/Crooked-Systems/claude-code-surgeon.git
cd claude-code-surgeon

# Install everything
./install.sh

# Or pick specific tools
./tools/cc-anchor/install.sh
./tools/cc-guard/install.sh
