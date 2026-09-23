---
type: Index
---

# octobot — why-register

One file per settled decision. Lines are **question-shaped** — the
question is derived from the file's first `answers:` entry, so read a
line to find the decision that settles your question, then open it.
Numbers are permanent (they are cited from CONTEXT.md and commit
messages); superseding adds a file, never renumbers one.

Format: `NNN — <question it settles> — <verdict> — <status>`.

- [001](R-001-okf-at-project-root.md) — Where does a project's OKF live? — at the target project's `./OKF/` — live
- [002](R-002-architect-replaces-plan-update.md) — Which skill owns project planning? — architect, mode-routed — live
- [003](R-003-blueprints-are-files.md) — Where do blueprints live: files or a tracker? — files with status frontmatter — live
- [004](R-004-one-glossary-per-context.md) — How many glossaries may a bounded context have? — exactly one — live
- [005](R-005-handoff-gate-for-subagents.md) — What must a mutating subagent receive before it is spawned? — a brief — live
- [006](R-006-imperative-verb-first-names.md) — How are new skills named? — imperative-verb-first — live
- [007](R-007-taxonomy-derived-per-repo.md) — Is the OKF page taxonomy fixed or derived per repo? — derived, then locked — live
- [008](R-008-page-warrant.md) — What justifies a page's existence in the OKF? — its warrant — live
- [009](R-009-index-is-the-page-plan.md) — Where is the locked page plan recorded? — `index.md` itself — live
- [010](R-010-two-zone-pages.md) — How does a refresh regenerate a page without destroying judgement? — `okf:derived` fences — live
- [011](R-011-code-reference-inside-write-okf.md) — Does the code-reference layer get its own skill? — no, write-OKF siblings — live
- [012](R-012-one-why-register.md) — Where do settled decisions live? — this register — live
- [013](R-013-roadmap-is-a-plan.md) — What may ROADMAP.md hold? — only what is still ahead — live
- [014](R-014-ferry-decisions-graduate-at-moor.md) — What happens to a resolved ferry decision at moor? — it graduates here — live
- [015](R-015-moor-collapses-ferry-directory.md) — What shape does a ferry take once it is moored? — one page, pinned with `sealed:` — live
- [016](R-016-one-okf-check-validator.md) — How is OKF conformance enforced? — `okf-check`, output pasted — live
- [017](R-017-pin-drift-splits-by-visibility.md) — Why doesn't `okf-check` verify that a `sealed:` pin resolves? — it cannot see the repo; refresh owns resolution — live
- [018](R-018-rescan-deletes-only-derived-pages.md) — What happens to a page a rescan no longer proposes? — deleted if wholly derived, else superseded — live
- [019](R-019-recon-may-self-fire.md) — Which skills may fire without the user asking? — orchestrators never, read-only recon may — live
- [020](R-020-every-page-has-a-growth-path.md) — What happens to a page at cap+1? — one named move per page kind, enforced as an error — live
- [021](R-021-session-checks-discharge-on-the-blueprint.md) — Where is a discharged-session check recorded? — stamped on its own blueprint's Verify check — live
- [022](R-022-prose-cites-carry-a-register-prefix.md) — How is a register entry cited in prose? — `B-NNN` blueprint, `R-NNN` why-register, `D-n` ferry — superseded-by-024
- [023](R-023-cross-skill-references-are-unchecked-skill-names.md) — How does one skill's prose reference another skill? — a backtick-wrapped `/skill-name`, never a path — live
- [024](R-024-register-filenames-carry-their-prefix.md) — Does a register entry's filename carry its prefix, or only its prose citation? — yes, `R-NNN-`/`B-NNN-` on disk too — live
