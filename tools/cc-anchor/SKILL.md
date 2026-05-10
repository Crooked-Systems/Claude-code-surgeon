# cc-anchor

Keeps critical context alive across compaction events.

## What it does

When Claude Code auto-compacts (context hits ~95% of 200K tokens), it summarises everything and loses detail — file paths you were working on, error messages you were debugging, constraints you set.

cc-anchor hooks into two points:

- **PreCompact**: before compaction fires, it extracts the last user message, current todo state, and any files you've marked as "anchored" (by mentioning `@anchor` in conversation). Writes a compact summary to `.claude/anchor/<session-id>.md`.

- **UserPromptSubmit**: after any compaction has happened, it injects a one-line pointer telling Claude the anchor file exists and can be read on demand.

## Usage

Just install it. It works automatically.

To mark something as important — say `@anchor the auth flow` or `@anchor` in a message. The precompact hook picks up the last user message + any @anchor mentions.

## Files

- `.claude/anchor/<session-id>.md` — per-session anchor file
- `.claude/anchor/global.md` — (optional) create this manually for project-wide anchors that survive all sessions
