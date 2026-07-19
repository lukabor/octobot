#!/bin/bash
# PreToolUse hook: blocks destructive git commands before they execute.
# Tuned from mattpocock/skills git-guardrails-claude-code:
#  - plain `git push` allowed (routine flow; `jj git push` must keep working)
#  - `--force-with-lease` allowed (the sanctioned force path)
#  - short `-f` force and clean flag-combos caught (upstream missed them)

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
[ -z "$COMMAND" ] && exit 0

DANGEROUS_PATTERNS=(
  "reset --hard"
  "clean -[A-Za-z]*f"
  "branch -D"
  "git checkout \\.( |$)"
  "git restore \\.( |$)"
  "push [^|;&]*--force( |$)"
  "push [^|;&]*-f( |$)"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    if echo "$COMMAND" | grep -qE "push [^|;&]*--force-with-lease"; then
      continue
    fi
    echo "BLOCKED: '$COMMAND' matches dangerous pattern '$pattern'. The user has prevented you from running this. If genuinely needed, ask the user to run it themselves." >&2
    exit 2
  fi
done

exit 0
