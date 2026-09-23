---
name: spawn-cavecrew
description: >
  How to actually invoke the caveman cavecrew subagents (investigator / builder
  / reviewer) without the "agent type not found" error, plus octobot defaults
  (review the current jj diff, commit edits via commit-atomic-jj). The plugin's
  `cavecrew` skill covers WHEN to delegate; this covers HOW to call them in
  octobot. Use when the user says "use cavecrew", "review my diff", "cavecrew
  review", "spawn investigator/builder/reviewer", or an inline call to a
  cavecrew agent failed with an unknown-agent-type error.
---

# spawn-cavecrew

## When to use
- User says "use cavecrew", "cavecrew review", "review my diff/branch".
- You want to spawn `cavecrew-investigator` / `-builder` / `-reviewer`.
- An `Agent` call failed with `Agent type '...' not found`.

For *which* agent fits *which* task (the decision matrix + output contracts),
read the plugin skill `cavecrew` — don't duplicate it here.

## The one gotcha: the `caveman:` namespace

The cavecrew agents are plugin-namespaced. The `Agent` tool's `subagent_type`
**must** be the fully-qualified name, or the call errors:

- ✅ `caveman:cavecrew-reviewer`
- ✅ `caveman:cavecrew-investigator`
- ✅ `caveman:cavecrew-builder`
- ❌ `cavecrew-reviewer` → `Agent type 'cavecrew-reviewer' not found`

The error message lists the valid names — if you see it, re-call with the
`caveman:` prefix. (The plugin `cavecrew` skill writes the bare names in prose;
that prose is not the invocation string.)

## How to call (copy these)

Review the current working diff (octobot default action):

> Agent tool — subagent_type: `caveman:cavecrew-reviewer`
> prompt: "Review the diff from `jj diff` (or `jj diff -r @-` for the last
> commit) for correctness bugs. Files: <paths>. Context: <contracts the code
> must honor>. Report findings only, severity-tagged, with fixes."

Locate code before editing:

> subagent_type: `caveman:cavecrew-investigator`
> prompt: "Where is <symbol> defined and what calls it? Return file:line table."

Surgical ≤2-file edit at a known site:

> subagent_type: `caveman:cavecrew-builder`
> prompt: "<exact change> at <path:line>. Re-read to verify."

Run independent calls in **one message** (multiple Agent tool uses) so they
fan out concurrently.

## The handoff gate (mutating subagents)

A **builder** (or any subagent that edits files) spawns only with a
written brief: goal, blueprint/OKF references by path (`OKF/blueprints/NNN`, the
pages it needs), constraints, and the **verify command** for its slice.
A locked blueprint is the default brief (`/rig`).
Read-only lookups (**investigator**) are exempt. No brief, no builder.

## octobot conventions
- **Default action** when asked to "review": pull the diff with `jj diff`
  (uncommitted) or `jj diff -r @-` (last change), hand the paths + the contracts
  the code must honor to `caveman:cavecrew-reviewer`. Relay the findings — the
  subagent result is not shown to the user.
- **After a `cavecrew-builder` edit**, commit via the `commit-atomic-jj` skill
  (`type(scope): imperative`), one concern per change. The builder edits; it
  does not commit.
- **Don't** ask the reviewer for architecture opinions — it returns findings
  only. Use a vanilla reviewer for prose.

## Verify
- The `Agent` call used a `caveman:`-prefixed `subagent_type`.
- A review pass named the diff source (`jj diff` / `-r @-`) in its prompt.

## See also (review axis/discipline lives here, not in the cavecrew skill)
- `/review-angles` — *correctness*.
- `/nuke-review` — *structural quality* (code-judo).
- `/winnow` — *mechanical debloat*.
- `/review-blueprint` — *blueprint fidelity* (diff vs OKF/blueprints/NNN).
