---
name: setup-git-guardrails
description: Install a PreToolUse hook that blocks destructive git commands (reset --hard, clean -f, branch -D, checkout/restore ., force push) before Claude executes them — prose guardrails can be forgotten, hooks cannot. Use when the user wants to prevent destructive git operations, add git safety hooks, or block force pushes in Claude Code.
---

# setup-git-guardrails

Tuned port of mattpocock/skills `git-guardrails-claude-code`. Skill
guardrails are prose — a model can drift past them; a PreToolUse hook
is enforced by the harness on every Bash call. This installs the hook.

## Tuning vs upstream (deliberate — don't "fix" back)

- **Plain `git push` allowed.** Upstream blocks all pushes; its naive
  `grep "git push"` also matches `jj git push`, which would break every
  jj flow (commit-atomic-jj, call-charon). Only *force* pushes block.
- **`--force-with-lease` allowed** — the sanctioned force path when a
  force-push is the agreed plan (resolve-conflicts' immutable rule).
- **Short `-f` force and `clean -df`-style flag combos caught** —
  upstream missed both.
- jj mutations are not blocked: jj's op log makes them recoverable
  (`jj undo`, `jj op restore`); git's destructive set is not.

## What gets blocked

`reset --hard` · `clean -f` (any flag combo) · `branch -D` ·
`git checkout .` · `git restore .` · `push --force` / `push -f`
(unless `--force-with-lease`).

## Steps

### 1. Ask scope
Project only (`.claude/settings.json` + `.claude/hooks/`) or all
projects (`~/.claude/settings.json` + `~/.claude/hooks/`)?

### 2. Copy the script
[scripts/block-dangerous-git.sh](scripts/block-dangerous-git.sh) →
`<scope>/hooks/block-dangerous-git.sh`; `chmod +x` it.

### 3. Merge hook into settings
Into the scope's settings file — **merge** into any existing
`hooks.PreToolUse` array, never overwrite (the harness's update-config
skill owns settings.json edits — route through it if available):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

Project scope: use
`"$CLAUDE_PROJECT_DIR"/.claude/hooks/block-dangerous-git.sh` as the
command.

### 4. Offer customization
Add/remove patterns in the copied script per the user's wishes. Keep
the `jj git push` and `--force-with-lease` exemptions unless the user
explicitly overrides — explain why first (see Tuning above).

### 5. Verify — all three cases

```bash
H=<path-to-script>
echo '{"tool_input":{"command":"git reset --hard HEAD~1"}}' | $H; echo "exit $?"   # want: BLOCKED, exit 2
echo '{"tool_input":{"command":"jj git push --bookmark main"}}' | $H; echo "exit $?" # want: silence, exit 0
echo '{"tool_input":{"command":"git push --force-with-lease"}}' | $H; echo "exit $?" # want: silence, exit 0
```

All three must pass before calling it installed. New settings hooks
load on session start — tell the user to restart the session.

## Guardrails
- **Never** overwrite an existing settings file — merge.
- **Never** remove the jj/force-with-lease exemptions silently.
- **Never** claim installed without the three-case verify output.

## See also
- [../../productivity/commit-atomic-git/SKILL.md](../../productivity/commit-atomic-git/SKILL.md)
  — the prose discipline this hook backstops.
- [../../productivity/resolve-conflicts-git/SKILL.md](../../productivity/resolve-conflicts-git/SKILL.md)
  — abort/continue flows; unaffected by these blocks.
