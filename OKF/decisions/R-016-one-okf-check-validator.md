---
type: Decision
purpose: Make the OKF done-gate a run with pasted output, not a claim.
answers:
  - "How is OKF conformance enforced?"
cites:
  - skills/loop/write-OKF/scripts/okf-check
  - skills/engineering/add-copilot-project-skill/project-validator.md
status: live
reversible: by inlining the checks as prose
---

# 016 — one okf-check validator

**One `okf-check` validator** at `write-OKF/scripts/`, built to the
existing doctrine in
[add-copilot-project-skill/project-validator.md](../../skills/engineering/add-copilot-project-skill/project-validator.md);
write-OKF and moor both gate on its pasted output, so the done-gate
is a run, not a claim. Per that doctrine it must pass clean on
octobot today — over-cap pages are a **warning** until phase 7, never
an error. Reversible by inlining the checks as prose.
