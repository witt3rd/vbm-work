import Lake
open System Lake DSL

package «vbm-work» where
  leanOptions := #[⟨`warningAsError, true⟩, ⟨`autoImplicit, false⟩]

/-- The library: specification and code, one Lean core. Imports `Init` and itself only (checked by Tier 1). No dependency. -/
@[default_target]
lean_lib VbmWork where
  globs := #[.andSubmodules `VbmWork]

/-- The proofs: may import `Std` and `Lean`; NEVER linked (nothing in `VbmWork` may import it). -/
lean_lib VbmWorkProofs where
  globs := #[.andSubmodules `VbmWorkProofs]

/-- The obligation-ledger vocabulary and the reach walk the landing tool ships (`land-lean ledger`); built here so the proofs can import it. -/
lean_lib LandLedger where
  srcDir := ".land/tool/lean"
  roots := #[`LandLedger, `LandWalk]
