# Scorecard

Status: draft by a worker, 2026-11-18; goals and targets are the owner's to set.

Every value below was measured on 2026-11-18 at commit `a165e68` (tag `v0.3.0` + 3 commits), from the repository root, with the pinned Lean 4.35.0 toolchain on `PATH` (`mise exec --` in front of each command does the same where mise can fetch the toolchain). A command that needs the toolchain is written as the repository writes it, without the prefix.

## Goals as the repository states them

1. **One vocabulary of work, written once and machine-checked**: a task in, a typed outcome out, a review returning typed findings. Source: `README.md:3`; `AGENTS.md:31`; `docs/decisions/0001-vbm-work.md:7-10`.
2. **Every claim is a proved theorem, or a marked limit**: the alphabets are closed, each word names at most one tag or kind, a word that names none is refused, an outcome must say something, a review blocks exactly when it has a `fix`, an unanswered reviewer is never an approval. Source: `README.md:3`, `README.md:13` (the claims are in `docs/proof-ledger.md`); `docs/decisions/0001-vbm-work.md:25-31`.
3. **Each conditional theorem carries a witness that its hypothesis can hold.** Source: `AGENTS.md:40`; `docs/decisions/0001-vbm-work.md:33`.
4. **Nothing is unproved unseen**: what cannot be proved is a `limit` in the ledger, and what is trusted is marked in the trust ledger. Source: `docs/decisions/0001-vbm-work.md:35-38`; `docs/trust-ledger.md:3`; `AGENTS.md:53`.
5. **The words are kept exactly**: the tag and kind words are the words an existing journal already holds; a change to one needs the consumer's word. Source: `AGENTS.md:50`; `docs/decisions/0001-vbm-work.md:37`.
6. **The library stays pure and small**: only data and total functions over `Init`, no input or output, no wire format, no dependency; `VbmWork` imports `Init` and itself only; at most 150 production lines under `VbmWork/` per change. Source: `README.md:9`; `AGENTS.md:33`, `AGENTS.md:49`; `CONTRIBUTING.md:8`, `CONTRIBUTING.md:10`.
7. **No forbidden construct, zero build warnings, no non-standard axiom.** Source: `AGENTS.md:39`, `AGENTS.md:53`; `CONTRIBUTING.md:8`; `docs/decisions/0001-vbm-work.md:47-48`.
8. **Every gate can fail and shows it ran**: a negative self-test for each gate, `ran: NAME: N cases` with N > 0. Source: `AGENTS.md:41`; `CONTRIBUTING.md:9`.
9. **Public-ready, always**: no private name, no path of ours, no number of ours, no e-mail. Source: `AGENTS.md:43`; `CONTRIBUTING.md:11`.
10. **The vendored lander is the pinned copy**, and everything runs once before the push (Tier 1 on the rebased tree). Source: `AGENTS.md:6`, `AGENTS.md:42`; `CONTRIBUTING.md:7`, `CONTRIBUTING.md:12`.
11. **Grow by slices, each with a consumer**: the task, and one list of the kinds of block. Source: `docs/decisions/0001-vbm-work.md:40-43`; `AGENTS.md:36`.
12. **Released**: `README.md:5` says pre-release, nothing published to a registry; versions are tagged (`VERSION`, tags `v0.1.0` to `v0.3.0`, `docs/decisions/0001-vbm-work.md:3`).

## Metrics

Units: counts are integers; `permille` is a ratio times 1000; `seconds` is wall time. The commands below were run with the toolchain on `PATH`.

| metric | direction | goal it serves | how to measure (from the repository root) | now | floor (= now) | target |
|---|---|---|---|---|---|---|
| `proof-ledger-gaps` (count of claims `partial` or `open`) | lower | 2 | `.land/tool/bin/land-lean ledger \| awk '/^ledger:/{print $4+$6}'` | 0 (2026-11-18) | 0 | |
| `proof-ledger-proved-permille` (proved claims of all claims) | higher | 2 | `.land/tool/bin/land-lean ledger \| awk '/^ledger:/{print int($2*1000/$NF)}'` | 916 (11 of 12; 2026-11-18) | 916 | |
| `proof-ledger-limit-claims` (claims no machine decides) | lower | 2, 4 | `.land/tool/bin/land-lean ledger \| awk '/^ledger:/{print $8}'` | 1 (`the-words-are-the-journals`; 2026-11-18) | 1 | |
| `theorems` (theorems in `VbmWorkProofs/`) | higher | 2 | `cat VbmWorkProofs/*.lean \| grep -cE '^(protected \|private )?theorem\b'` | 42 (2026-11-18) | 42 | |
| `witness-examples` (`example`s in `VbmWorkProofs/`: the non-vacuity witnesses) | higher | 3 | `cat VbmWorkProofs/*.lean \| grep -cE '^example\b'` | 16 (2026-11-18) | 16 | |
| `conditional-theorems-without-witness` | lower | 3 | no command exists: needs a check that pairs each theorem with a hypothesis to a witness | unmeasured (needs such a gate; today the pairing is by review) | | |
| `axiom-offenders` (constants depending on a non-standard axiom) | lower | 7 | `.land/tool/bin/land-lean axiom \| awk '/^axiom gate:/{print $6}'` | 0 of 515 constants (2026-11-18) | 0 | |
| `forbidden-constructs` (`sorry`, `admit`, `axiom`, `unsafe`, `implemented_by`, `csimp` not marked `tier1-allow`) | lower | 7 | `git ls-files 'VbmWork*.lean' \| xargs grep -hE '\b(sorry\|admit\|axiom\|unsafe\|implemented_by\|csimp)\b' \| grep -v tier1-allow \| wc -l` | 0 (2026-11-18) | 0 | |
| `warnings` (Lean warnings over all sources) | lower | 7 | `for f in $(git ls-files 'VbmWork*.lean'); do lake env lean -DwarningAsError=false "$f"; done 2>&1 \| grep -c 'warning:'` (exits 1 at zero: read the printed 0) | 0 (2026-11-18) | 0 | |
| `core-imports-outside-vbmwork` (imports in `VbmWork/` other than `VbmWork.*`) | lower | 6 | `cat VbmWork.lean VbmWork/*.lean \| grep -E '^[[:space:]]*(import\|prelude)' \| grep -vE '^import VbmWork' \| wc -l` | 0 (2026-11-18) | 0 | |
| `verified-core-lines` (non-blank, non-comment lines in `VbmWork.lean` and `VbmWork/`) | lower | 6 | `cat VbmWork.lean VbmWork/*.lean \| grep -cvE '^[[:space:]]*(--.*)?$'` | 154 (2026-11-18) | 154 | |
| `wire-words-removed-since-release` (string literals in `VbmWork/` present at the last tag and gone now) | lower | 5 | `comm -23 <(git grep -ohE '"[A-Za-z]+"' "$(git describe --tags --abbrev=0)" -- VbmWork \| sort -u) <(grep -rohE '"[A-Za-z]+"' VbmWork \| sort -u) \| wc -l` | 0 (tag `v0.3.0`, 2026-11-18) | 0 | |
| `trust-ledger-gaps` (trusted items with no written contract or no test) | lower | 4 | `.land/tool/bin/land-lean trust \| sed -nE 's/.*; ([0-9]+) with no written.*/\1/p'` | 2 (T1, T2: both "no written contract"; 2026-11-18) | 2 | |
| `public-lint-violations` | lower | 9 | `scripts/lint-public \| grep -c .` (exits 1 at zero: read the printed 0) | 0 (2026-11-18) | 0 | |
| `lint-selftest-cases` (cases the public lint's own self-test runs, one of them negative) | higher | 8 | `bash scripts/test_lint_public.sh \| sed -nE 's/^ran: test_lint_public: ([0-9]+) cases/\1/p'` | 8 (2026-11-18) | 8 | |
| `lander-drift-failures` (vendored lander differs from its pin) | lower | 10 | `.land/tool/bin/land-check >/dev/null; echo $?` | 0 (vbm-land v0.21.0; 2026-11-18) | 0 | |
| `commits-since-tag` (unreleased commits; all 3 today are `chore(land)`) | lower | 12 | `git rev-list --count "$(git describe --tags --abbrev=0)"..HEAD` | 3 (2026-11-18) | 3 | |
| `planned-slices-listed` (bullets under "What comes next") | lower | 11 | `sed -n '/^## What comes next/,/^## Rules/p' docs/decisions/0001-vbm-work.md \| grep -c '^- '` | 2 (2026-11-18; one of the two, the task, is already landed: see Health) | 2 | |
| `recheck-seconds` (every proof replayed by Lean's own checker, the slowest gate) | lower | 8 | `time .land/tool/bin/land-lean recheck` | 124 (2026-11-18; over a minute: re-measure only when needed) | 124 | |
| `tier1-seconds` (the whole gate, `scripts/tier1.sh`) | lower | 10 | `time mise exec -- scripts/tier1.sh` | unmeasured (the harness runs Tier 1, not the worker; its largest part is `recheck-seconds`) | | |
| `vectors` (test vectors against a consumer's journal) | higher | 5 | none: the repository has no `vectors/` directory, no test beyond the public lint's, and the consumer's journal tests are outside it (`docs/proof-ledger.md`, the `limit` row) | unmeasured (needs the consumer's journal or a sample of it) | | |

## Health today

- **Proof ledger: nothing regressed.** 0 gaps, 11 of 12 claims proved, and the baseline `scripts/ledger-baseline.txt` (proved 11, open 0, total 12) equals now. The one `limit` (`the-words-are-the-journals`) is by design unprovable here, so `proof-ledger-proved-permille` cannot reach 1000 unless the owner counts a limit as done.
- **Quality gates are all at zero**: `axiom-offenders`, `forbidden-constructs`, `warnings`, `core-imports-outside-vbmwork`, `public-lint-violations`, `lander-drift-failures`, `wire-words-removed-since-release`.
- **The one stated goal that nothing measures is the one the repository calls its limit** (goal 5): `vectors` is `unmeasured`, so whether the kept words still decode in the consumer is checked nowhere in this tree.
- **Goal 3 (a witness for each conditional theorem) is unmeasured**: 16 witnesses stand beside 42 theorems, but no gate pairs them (`conditional-theorems-without-witness`).
- **Trust ledger has 2 gaps**: T1 (the Lean toolchain) and T2 (the tools the scripts run) are accepted with no written contract and no test of their own (`docs/trust-ledger.md:10-11`, `:19-20`).
- **Documents lag the code**: `docs/decisions/0001-vbm-work.md:42` and `AGENTS.md:36` still list the task as planned, though `VbmWork/Task.lean` exists and `docs/decisions/0001-vbm-work.md:3`, `:22` say it landed in v0.2.0; `README.md:5` says "The first slice only". So `planned-slices-listed` is 2 where one slice is open.
- **Slowest gate**: the proof replay takes 124 s; the full Tier 1 time is unmeasured.
- **Release**: 3 commits since `v0.3.0`, all landing-tool bumps (pin v0.21.0 is newer than anything the tag carries); no tag for them.

## What a steward would do first

1. Make the state of the slices true in the three places that state it (`AGENTS.md:36`, `docs/decisions/0001-vbm-work.md:42`, `README.md:5`), which moves `planned-slices-listed` from 2 to 1.
2. Decide how goal 5 is to be measured, a vectors file of the journal's words checked in this tree or a count taken from the consumer, so that `vectors` stops being `unmeasured` and `proof-ledger-limit-claims` has a number behind it.
3. Close goal 3's measurement: a gate that pairs each theorem having a hypothesis with a witness, so that `conditional-theorems-without-witness` is a number and `witness-examples` has a denominator.

## Questions for the owner

- What are the targets? Every `target` is blank; in particular, is `proof-ledger-proved-permille` 916 the ceiling (the limit stays a limit) or is 1000 the aim?
- Is a smaller `verified-core-lines` better (a stated rule only caps one change at 150 lines, `CONTRIBUTING.md:10`), or should it grow with slices? I wrote "lower" from goal 6 only; `theorems` and `witness-examples` are "higher" on the same footing.
- Is the next slice (one list of the kinds of block, `docs/decisions/0001-vbm-work.md:43`) due, and which consumer holds the harness-side kinds today? The repository gives no date.
- Should unreleased landing-tool bumps (`commits-since-tag`) trigger a tag, and is "published to a registry" (`README.md:5`) a goal or only a status?
- Is there a time budget for Tier 1 (goal 10 has none; `AGENTS.md:44` gives only 45 minutes for a task)?
- Where does the consumer's journal live, so that the `vectors` metric (goal 5) can be measured?
