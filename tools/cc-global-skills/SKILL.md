# cc-global-skills

Claude Code ignores global skills (`~/.claude/skills/`) in new sessions. It only sees project-local skills. This is a known architectural limitation that makes the global skills feature useless without manual intervention.

This hook injects global skill references at session start.

## Usage

1. Install: `./install.sh`
2. Put skills in `~/.claude/skills/<skill-name>/SKILL.md`
3. Start a new session — Claude now knows about them

## How

The SessionStart hook scans `~/.claude/skills/`, builds a skill index, and feeds it into the session context. Minimal overhead: just skill names + descriptions, not the full skill bodies.
