#!/usr/bin/env bash
set -euo pipefail
TOOL_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(pwd)"

mkdir -p "$PROJECT_ROOT/.claude/hooks"
mkdir -p "$PROJECT_ROOT/.claude/rules.d"

cp "$TOOL_DIR/hooks/pretooluse" "$PROJECT_ROOT/.claude/hooks/pretooluse"
cp "$TOOL_DIR/lib/matcher.sh" "$PROJECT_ROOT/.claude/hooks/lib/matcher.sh"
chmod +x "$PROJECT_ROOT/.claude/hooks/pretooluse"

# Install example rule if rules.d is empty
if [[ -z "$(ls -A "$PROJECT_ROOT/.claude/rules.d" 2>/dev/null)" ]]; then
    cp "$TOOL_DIR/rules.d/example-no-sed.rule" "$PROJECT_ROOT/.claude/rules.d/example-no-sed.rule"
fi

SETTINGS="$PROJECT_ROOT/.claude/settings.json"
[[ ! -f "$SETTINGS" ]] && echo '{"hooks":{}}' > "$SETTINGS"

TMP=$(mktemp)
jq '
  .hooks.PreToolUse = (.hooks.PreToolUse // []) +
    [{
      "matcher": "Bash|Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/pretooluse"
      }]
    }]
' "$SETTINGS" > "$TMP" && mv "$TMP" "$SETTINGS"

echo "  cc-guard: installed (PreToolUse hook, ${PROJECT_ROOT}/.claude/rules.d/)"
