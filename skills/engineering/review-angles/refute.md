# Refute before you accept (elenchus)

The Socratic move: a claim earns acceptance only by *surviving an attempt to
break it*, not by sounding right. Applies to a review finding, a bug
hypothesis, a "this is redundant" call, a passing test — anything you are
about to act on.

## Protocol
1. **State the claim sharply.** "X is a bug", "this wrapper is dead", "the
   suite proves the feature works." A vague claim can't be refuted.
2. **Default to refuted.** The burden is on the claim to survive, not on you
   to disprove it. When uncertain, it fails.
3. **Attack from independent angles.** Spawn N skeptics, each trying to
   *break* the claim, not confirm it. Diversity beats repetition — give each
   a distinct lens (correctness, security, does-it-reproduce,
   what-changes-if-it's-wrong) rather than N identical passes.
4. **Survival = a majority fail to refute.** A claim that withstands several
   honest attacks from different directions is accepted. One that any angle
   breaks is dropped or downgraded.

## Why default-to-refuted
The opposite default — accept unless disproven — is how plausible-but-wrong
findings survive a review, and how cosmetic changes pass as improvements.
The burden of proof is the whole game: the same inversion the `/sieve`
uses for keeping vs cutting, pointed at *believing* vs acting.

## Used by
- [`SKILL.md`](SKILL.md) — refute each review-angle candidate before emitting.
- `/winnow` — refute "it's redundant" before
  cutting; the type-checker is one skeptic.
- `/bdd` — a green suite is a claim, not a
  proof; the post-green pass refutes it.
- `/sieve` — Good-with-receipts refutes the
  merely-cosmetic change.
