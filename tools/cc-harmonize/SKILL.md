# cc-harmonize

Detects conflicts between AI coding tool memory files.

If you use Claude Code + Cursor + Copilot (or any combination), you have rules scattered across:
- `CLAUDE.md` (any depth, path-scoped)
- `.cursorrules`, `.cursor/rules/*.md`
- `.github/copilot-instructions.md`, `.github/instructions/*.md`
- `AGENTS.md` (any depth)

cc-harmonize reads them all and flags contradictions. No LLM calls. ~200 lines of Python.

## Usage

```bash
./harmonize              # Prints conflict report
./harmonize --json       # Machine-readable output
./harmonize --ci         # Exit 1 if conflicts found (for CI)
./harmonize --watch      # Re-scan on file changes
