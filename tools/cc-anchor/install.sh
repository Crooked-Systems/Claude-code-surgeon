#!/usr/bin/env bash
set -euo pipefail
TOOL_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(pwd)"

mkdir -p "$PROJECT_ROOT/.claude/anchor"
mkdir -p "$PROJECT_ROOT/.claude/hooks"

cp "$TOOL_DIR/hooks/precompact" "$PROJECT_ROOT/.claude/hooks/precompact"
cp "$TOOL_DIR/hooks/prompt-inject" "$PROJECT_ROOT/.claude/hooks/prompt-inject"
cp "$TOOL_DIR/lib/anchor.sh" "$PROJECT_ROOT/.claude/hooks/lib/anchor.sh"
cp "$TOOL_DIR/lib/transcript-walk.sh" "$PROJECT_ROOT/.claude/hooks/lib/transcript-walk.sh"
chmod +x "$PROJECT_ROOT/.claude/hooks/precompact"
chmod +x "$PROJECT_ROOT/.claude/hooks/prompt-inject"

SETTINGS="$PROJECT_ROOT/.claude/settings.json"
if [[ ! -f "$SETTINGS" ]]; then
    echo '{"hooks":{}}' > "$SETTINGS"
fi

TMP=$(mktemp)
jq '
  .hooks.PreCompact = (.hooks.PreCompact // []) +
    [{
      "matcher": "auto",
      "hooks": [{
        "type": "command",
        "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/precompact"
      }]
    }]
  | .hooks.UserPromptSubmit = (.hooks.UserPromptSubmit // []) +
    [{
      "hooks": [{
        "type": "command",
        "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/prompt-inject"
      }]
    }]
' "$SETTINGS" > "$TMP" && mv "$TMP" "$SETTINGS"

echo "  cc-anchor: installed (PreCompact + UserPromptSubmit hooks)"
