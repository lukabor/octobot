---
type: Decision
purpose: Let a scan regenerate part of a page without overwriting human judgement.
answers:
  - "How does a refresh regenerate a page without destroying judgement?"
cites:
  - OKF/CONTEXT.md
status: live
reversible: drop fences, fall back to whole-page supersede
---

# 010 — module and analysis pages are two-zone

Module and analysis pages are **two-zone**: `<!-- okf:derived -->`
fences the scan-regenerated seam, everything outside is judgement —
append/supersede only, never scan-edited. Reversible — drop fences,
fall back to the existing whole-page supersede rule.
