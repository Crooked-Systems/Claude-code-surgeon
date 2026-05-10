
---

## FILE: `install.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

BOLD="$(tput bold 2>/dev/null || echo '')"
NC="$(tput sgr0 2>/dev/null || echo '')"
REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

say() { printf "%b\n" "${BOLD}→${NC} %s" "$*"; }
fail() { printf "%b\n" "  ✗ %s" "$*" >&2; exit 1; }

echo ""
say "claude-code-surgeon installer"
echo ""

# Check basics
command -v jq >/dev/null 2>&1 || fail "jq is required. Install it: brew install jq / apt install jq"
command -v python3 >/dev/null 2>&1 || fail "python3 is required"

# Are we in a project with Claude Code set up?
if [[ ! -f ".claude/settings.json" ]]; then
    say "No .claude/settings.json found. Creating one..."
    mkdir -p .claude/hooks
    echo '{"hooks":{}}' > .claude/settings.json
fi

# Install each tool
installed=0
skipped=0
for tool_dir in "$REPO_ROOT"/tools/*/; do
    tool_name="$(basename "$tool_dir")"
    install_script="${tool_dir}install.sh"

    if [[ -x "$install_script" ]]; then
        say "Installing ${tool_name}..."
        if "$install_script"; then
            ((installed++))
        else
            say "  ${tool_name} install returned non-zero (continuing)"
            ((skipped++))
        fi
    else
        say "  Skipping ${tool_name} (no install.sh or not executable)"
        ((skipped++))
    fi
done

echo ""
say "Done. ${installed} installed, ${skipped} skipped."
echo "  Restart Claude Code for hooks to take effect."
