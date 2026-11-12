import VbmWorkProofs.Outcome
import VbmWorkProofs.Review
import LandLedger
/-! # The obligation ledger

Every claim the library makes, keyed by a slug and checked by `land-lean ledger` (`.land/tool/docs/lean-gates.md`): a claim is `proved` only by naming theorems
(double-backtick names are checked at elaboration, so a renamed or deleted theorem breaks this file), or it is a `limit` no machine decides. -/
open Land.Ledger

def ledger : List Obligation := [
  O "outcome-alphabet-is-closed" (.proved [``VbmWork.Tag.mem_all, ``VbmWork.Kind.mem_all]),
  O "outcome-words-are-one-to-one" (.proved [``VbmWork.Tag.ofName_name, ``VbmWork.Tag.name_ofName, ``VbmWork.Tag.name_injective,
    ``VbmWork.Kind.ofName_name, ``VbmWork.Kind.name_ofName, ``VbmWork.Kind.name_injective]),
  O "a-word-that-names-nothing-is-refused" (.proved [``VbmWork.Tag.ofName_eq_none, ``VbmWork.Kind.ofName_eq_none]),
  O "the-model-may-claim-six-kinds" (.proved [``VbmWork.Kind.byModel_iff, ``VbmWork.Kind.byModel_count]),
  O "an-outcome-must-say-something" (.proved [``VbmWork.Outcome.done_ok_iff, ``VbmWork.Outcome.blocked_ok_iff, ``VbmWork.Outcome.assumptions_ok_iff,
    ``VbmWork.Outcome.clarification_ok_iff, ``VbmWork.Outcome.blocked_without_reason, ``VbmWork.Outcome.assumptions_none]),
  O "a-severity-word-names-one-severity" (.proved [``VbmWork.Severity.ofName?_name, ``VbmWork.Severity.ofName?_eq_none]),
  O "a-review-blocks-exactly-when-it-has-a-fix" (.proved [``VbmWork.hasFix_iff, ``VbmWork.verdict_fix, ``VbmWork.blocked_iff,
    ``VbmWork.notes_not_blocked, ``VbmWork.verdict_notes, ``VbmWork.verdict_nil, ``VbmWork.verdict_cases]),
  O "an-unanswered-reviewer-is-never-an-approval" (.proved [``VbmWork.verdictOf_error, ``VbmWork.verdictOf_ok, ``VbmWork.error_not_clean,
    ``VbmWork.unreviewed_not_clean, ``VbmWork.verdict_of_review_ne_unreviewed]),
  O "the-words-are-the-journals" (.limit "the tag and kind words are the words an existing journal already holds, kept exactly; that they still decode is carried by the consumer's own journal tests, not provable here")]
