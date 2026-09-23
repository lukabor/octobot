# Splitting a page at the cap

`okf-check` errors when a page passes its cap — 110 lines, 150 for a
blueprint. This is that error's procedure. Which move a page gets is its
contract in [okf-layout.md](okf-layout.md); this page is *how* to make the
move without losing content or breaking the bundle.

## The move is pure

A split relocates; it never authors.

- Entries move **verbatim** — nothing reworded, merged, resequenced or
  dropped. An improvement noticed mid-split is a later commit.
- It lands in **its own change**, alone, so review reads it as a
  relocation instead of a 200-line diff mixing moves with edits.
- Verify by **count**: entries in == entries out. A split that changes the
  count is an edit wearing a split's clothes.

New content lands in the next change, alongside whatever it documents.

## Choosing the axis

Split by **theme, and the theme is the layer that has to change because of
the entry.** That rule decides entries that could sit in two places: a
lesson about a viewer that reads a grammar belongs under the grammar,
because the grammar is what constrains the viewer.

Chronological halves ("2025", "2026") also hold the cap and destroy
findability — a new entry gets no obvious home. Don't.

Theme **names** are the repo's, never this skill's. Name them after that
repo's layers as they actually are.

## Rewiring the index

**The parent moves.** `PAGE.md` becomes `<theme-dir>/index.md`, the
subpages land beside it, and `index.md`'s single line repoints at the new
parent. Subpages are **not** listed in `index.md` — it is capped too, and
would grow with every theme added.

The rename is what keeps the bundle reachable: `okf-check`'s `reachable()`
walks on through pages named `index.md` or `MAP.md` and no others, so a
parent that kept its old name would strand every subpage. Widening the
walk was rejected — the narrow rule is what buys the spine guarantee
(every page hangs off the map), and a split is rare enough to pay a rename.

Links pointing at the old path are repointed in the same change, and a
relative link *inside* the moved page gains the `../` its new depth needs.

Three frontmatter obligations, all enforced by `okf-check`:

- Every subpage carries the parent's `type:` and its own `purpose:`,
  `answers:` and `cites:`.
- **`answers:` may not collide.** Duplicate answers across pages is an
  error — the parent's question narrows to the index's own ("where does
  each theme live?") and each subpage claims the slice it now owns.
- Every subpage must be **reachable**: linked from the parent, which is
  linked from `index.md`. An unreachable page is an error, a page listed
  but not yet written is legal.

## The derived-fence trap

`modules/` and `analyses/` pages are the only ones carrying an
`okf:derived` region, and refresh regenerates the inside of it wholesale.
Prose shed out of `ARCHITECTURE.md` therefore lands **outside** the fence,
in the judgement zone. Inside, it survives until the next refresh and then
silently is not there.

## Lazily, at the cap

The directory appears when the cap forces it — never scaffolded empty at
init, never pre-created for a page that might grow later. An empty
`learnings/` is the same mistake as the empty `adr/` this repo already
deleted once.

## When the page is a blueprint

Over 150 lines, ask what is long before splitting the file. A blueprint
naming three things in its slug is over-*scoped*, not over-written:
compound work that still fits one session becomes two blueprints, and work
past one session goes to `/ferry`, whose own trigger is
exactly this. The `NNN-<slug>/` directory form is for a blueprint's notes,
not for a blueprint that should have been two.

## Done criteria

- `scripts/okf-check <okf-dir>` exits 0, output pasted.
- Entry count equal before and after, stated.
- The split is alone in its change, message `docs(okf): split <page>`.
