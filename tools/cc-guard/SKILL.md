# cc-guard

Enforces CLAUDE.md rules. Actually.

## The problem

CLAUDE.md says "never use sed". Claude uses sed anyway. The rules survive exactly until the context window compacts, then they're gone.

cc-guard moves enforcement to the hook level — Claude Code can't bypass it because the hook runs *outside* the model's context.

## How it works

- Reads `.claude/rules.d/*.rule` files (dead-simple format: one regex per line, or `!command_pattern` to block)
- Hooks into PreToolUse for Bash, Write, and Edit tools
- If the tool input matches any blocking rule, the hook exits with code 2 (block) and feeds the rule explanation back as stderr

## Rule file format
