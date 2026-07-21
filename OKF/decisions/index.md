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

- [001](001-okf-at-project-root.md) — Where does a project's OKF live? — at the target project's `./OKF/` — live
- [002](002-architect-replaces-plan-update.md) — Which skill owns project planning? — architect, mode-routed — live
- [003](003-blueprints-are-files.md) — Where do blueprints live: files or a tracker? — files with status frontmatter — live
- [004](004-one-glossary-per-context.md) — How many glossaries may a bounded context have? — exactly one — live
- [005](005-handoff-gate-for-subagents.md) — What must a mutating subagent receive before it is spawned? — a brief — live
- [006](006-imperative-verb-first-names.md) — How are new skills named? — imperative-verb-first — live
- [007](007-taxonomy-derived-per-repo.md) — Is the OKF page taxonomy fixed or derived per repo? — derived, then locked — live
- [008](008-page-warrant.md) — What justifies a page's existence in the OKF? — its warrant — live
- [009](009-index-is-the-page-plan.md) — Where is the locked page plan recorded? — `index.md` itself — live
- [010](010-two-zone-pages.md) — How does a refresh regenerate a page without destroying judgement? — `okf:derived` fences — live
- [011](011-code-reference-inside-write-okf.md) — Does the code-reference layer get its own skill? — no, write-OKF siblings — live
- [012](012-one-why-register.md) — Where do settled decisions live? — this register — live
- [013](013-roadmap-is-a-plan.md) — What may ROADMAP.md hold? — only what is still ahead — live
- [014](014-ferry-decisions-graduate-at-moor.md) — What happens to a resolved ferry decision at moor? — it graduates here — live
- [015](015-moor-collapses-ferry-directory.md) — What shape does a ferry take once it is moored? — one page, pinned with `sealed:` — live
- [016](016-one-okf-check-validator.md) — How is OKF conformance enforced? — `okf-check`, output pasted — live
