# Shared anchor utilities
# Source this from hook scripts

walk_back_find_user() {
    local transcript="$1"
    # Walk JSONL lines backwards, find most recent user message with content
    tac "$transcript" 2>/dev/null | while IFS= read -r line; do
        role=$(echo "$line" | jq -r '.role // empty' 2>/dev/null)
        if [[ "$role" == "user" ]]; then
            content=$(echo "$line" | jq -r '.content // .message.content // empty' 2>/dev/null)
            if [[ -n "$content" && "$content" != "null" ]]; then
                # Truncate to 500 chars to keep anchor lean
                echo "$content" | head -c 500
                break
            fi
        fi
    done
}
