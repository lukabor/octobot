---
type: Blueprint
status: implemented
traces-to: user request 2026-09-23
sounded: 2026-09-23
cites:
  - skills/loop/write-OKF/scripts/okf-check:muster is opt-in
  - skills/loop/write-OKF/scripts/okf-check:tally
  - skills/loop/rig/SKILL.md:never flip on a known miss
  - skills/loop/blueprint/blueprint-format.md:tally
muster: false  # Verify constructs the exact matches:no/implemented/muster:true
                # case and asserts the new error fires — it proves the
                # semantic gap is closed, not just that the tree stays green.
---

# 027 — error when a mustered blueprint reaches implemented on matches: no

## Justification

`okf-check` errors when a `muster: true` blueprint reaches `implemented`
without a `tally:` block at all
([okf-check:muster is opt-in](../../skills/loop/write-OKF/scripts/okf-check)),
but it only checks that the block **exists** — it never reads the verdict
inside it. A blueprint carrying `tally: matches: no` passes the same check
`implemented` requires, silently. [rig](../../skills/loop/rig/SKILL.md)'s
prose already says the loop must
[never flip on a known miss](../../skills/loop/rig/SKILL.md), but nothing
enforces it — the exact shape
[025](025-rule-muster-on-every-blueprint.md) closed one level up, where an
absent ruling was indistinguishable from a considered no. Carried across four
handoffs as an open question; flagged a blueprint candidate since the
2026-07-31 handoff.

## Contract

`okf-check` errors on a page under `blueprints/` whose frontmatter has
`muster: true`, `status: implemented`, and a `tally:` block whose `matches`
field is `no`. The error fires whether or not `tally:` carries other fields.
It does not fire when `matches: yes`, when `muster` is absent or false, or
when `status` is not `implemented`. The existing missing-`tally:` error is
unchanged.

## Seams touched

- `skills/loop/write-OKF/scripts/okf-check` — the muster/tally check
  (currently the block starting `# muster is opt-in`, ~line 289) and the
  `tally()` helper it calls.

## Verify

```bash
d=$(mktemp -d) && mkdir -p "$d/blueprints"
cat > "$d/index.md" <<'EOF'
---
type: Index
---
# Index
- [999](blueprints/999-fixture.md)
EOF
cat > "$d/blueprints/999-fixture.md" <<'EOF'
---
type: Blueprint
status: implemented
traces-to: user request 2026-09-23
muster: true
tally:
  intent: fixture for the matches:no gap
  matches: no
---
# 999 — fixture
## Justification
Fixture.
## Contract
Fixture.
## Seams touched
None.
## Verify
None.
## Out of scope
None.
EOF
skills/loop/write-OKF/scripts/okf-check "$d" | grep "muster: true, implemented" && \
  skills/loop/write-OKF/scripts/okf-check OKF/
```
The fixture run must print an error naming the fixture page; the real-tree
run after it must stay `0 error(s), 0 warning(s)` (no existing blueprint
carries `matches: no` on an `implemented` page — checked by hand this
session).

## Out of scope

- Does not change [rig](../../skills/loop/rig/SKILL.md)'s halt behaviour —
  that prose already exists; this only makes the mechanical gate agree with
  it.
- Does not add or rename any frontmatter field.
- Does not retroactively re-check blueprints already `implemented` outside
  this session's manual audit.
- Does not touch `skill-check`'s unrelated 9-warning baseline.
