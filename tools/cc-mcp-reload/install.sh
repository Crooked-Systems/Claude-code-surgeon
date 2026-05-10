#!/usr/bin/env bash
set -euo pipefail
TOOL_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(pwd)"

mkdir -p "$PROJECT_ROOT/.claude/hooks"
cp "$TOOL_DIR/bin/mcp-reload" "$PROJECT_ROOT/.claude/hooks/mcp-reload"
chmod +x "$PROJECT_ROOT/.claude/hooks/mcp-reload"

SETTINGS="$PROJECT_ROOT/.claude/settings.json"
[[ ! -f "$SETTINGS" ]] && echo '{"hooks":{}}' > "$SETTINGS"

TMP=$(mktemp)
jq '
  .hooks.SessionStart = (.hooks.SessionStart // []) +
    [{
      "matcher": "resume",
      "hooks": [{
        "type": "command",
        "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/mcp-reload"
      }]
    }]
' "$SETTINGS" > "$TMP" && mv "$TMP" "$SETTINGS"

echo "  cc-mcp-reload: installed (SessionStart resume hook)"
