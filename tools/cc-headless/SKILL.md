# cc-headless

Production-grade wrapper around Claude Code's headless mode.

## What's wrong with plain `claude -p`

- No retry logic for API failures
- No timeout handling
- Output is raw streaming JSON
- Exit codes are unreliable
- Stderr/stdout interleaving makes parsing fragile

## What `cc-run` adds

- Automatic retry with exponential backoff (3 attempts)
- Configurable timeout (default: 10 minutes)
- Structured output: JSON or plain markdown
- Proper exit code propagation
- Rate limit detection and backoff

## Usage

```bash
# Simple
cc-run "Fix the lint errors in src/"

# With options
cc-run --timeout 600 --retries 5 --model sonnet "Refactor the auth module"

# Pipe input
cat build.log | cc-run --stdin "Explain these build errors"

# CI mode (strict exit codes)
cc-run --ci "Run tests and fix failures"
