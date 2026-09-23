---
type: Decision
purpose: Let a rescan drop a page it can rebuild, and only that one.
answers:
  - "What happens to a page a rescan no longer proposes?"
cites:
  - skills/loop/write-OKF/taxonomy-scan.md
  - OKF/decisions/R-010-two-zone-pages.md
status: live
reversible: supersede every unwarranted page, delete none
---

# 018 — a rescan deletes only wholly derived pages

An **unwarranted** page — listed under `modules/`/`analyses/`, no longer
proposed — is **deleted only if it is wholly derived**: nothing outside
its [010](R-010-two-zone-pages.md) `okf:derived` fences but frontmatter and
title. Such a page loses nothing a rescan cannot rebuild. One byte of
judgement and it is **superseded** instead, struck with a pointer per
`write-OKF/SKILL.md` refresh step 3; either way
[015](R-015-moor-collapses-ferry-directory.md) holds — history is the
archive of record, not the OKF. Removal is proposed, never applied
unasked: the user locks it as they lock the plan.
