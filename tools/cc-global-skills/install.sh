#!/usr/bin/env bash
set -euo pipefail
TOOL_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(pwd)"

mkdir -p "$PROJECT_ROOT/.claude/hooks"
cp "$TOOL_DIR/hooks/session-start" "$PROJECT_ROOT/.claude/hooks/session-start"
chmod +x "$PROJECT_ROOT/.claude/hooks/session-start"

SETTINGS="$PROJECT_ROOT/.claude/settings.json"
[[ ! -f "$SETTINGS" ]] && echo '{"hooks":{}}' > "$SETTINGS"

TMP=$(mktemp)
jq '
  .hooks.SessionStart = (.hooks.SessionStart // []) +
    [{
      "matcher": "startup",
      "hooks": [{
        "type": "command",
        "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/session-start"
      }]
    }]
' "$SETTINGS" > "$TMP" && mv "$TMP" "$SETTINGS"

echo "  cc-global-skills: installed (SessionStart hook)"
