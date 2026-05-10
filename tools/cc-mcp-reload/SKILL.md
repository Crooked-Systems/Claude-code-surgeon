# cc-mcp-reload

Fixes the MCP reconnect gap. When you run `/mcp` to reconnect a server, Claude Code restores the transport but never re-queries `tools/list`. The model loses all tools from that server.

This tool adds a hook that detects reconnection and forces a tool list refresh.

## Usage

1. Install: `./install.sh`
2. After a server disconnects, run `/mcp` as usual
3. cc-mcp-reload detects the reconnect event and dumps the tool manifest into a file Claude Code can read

## How

The hook watches SessionStart events and checks for MCP servers that have reconnected. It calls `tools/list` on each server and writes the manifest to `.claude/mcp-tools/<server>.json`. A companion CLAUDE.md include makes the tools visible.
