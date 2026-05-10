# Permission rule matcher
# Claude Code's permission rules use format: ToolName(pattern)
# e.g., Bash(git *), Edit(*.ts), Bash(rm *)
# This implements a subset sufficient for rule matching.

match_permission_rule() {
    local call="$1"    # e.g., "Bash(rm -rf /)"
    local pattern="$2" # e.g., "Bash(rm *)"

    # Extract tool name from pattern
    local p_tool="${pattern%%(*}"
    local p_args="${pattern#*(}"; p_args="${p_args%)}"

    # Extract tool name from call
    local c_tool="${call%%(*}"
    local c_args="${call#*(}"; c_args="${c_args%)}"

    # Tool must match
    [[ "$c_tool" == "$p_tool" ]] || return 1

    # If no args pattern, match any
    [[ -z "$p_args" ]] && return 0

    # Simple glob matching on args
    # Replace * with regex wildcard
    local regex="${p_args}"
    regex="${regex//\*/.*}"
    regex="${regex//\?/.}"

    [[ "$c_args" =~ ^${regex}$ ]] && return 0
    return 1
}
