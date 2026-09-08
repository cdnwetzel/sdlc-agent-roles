# Release review receipt: 32c-pxx-unparseable

**Run ID:** 32c-pxx-unparseable
**Actor:** PXX 2.5.4 NativeReviewer with qwen2.5:14b-instruct-q4_k_m
**Lane:** pxx
**Result:** NO_REVIEW
**Subject:** 32c12aa8d53ef56af4a48edd1eb457f6f75abf593830eb1fbc00f93f0867512e — staged public-release candidate
**Invocation:** Model-backed staged review through the restored Ollama-compatible home-lab endpoint

## Findings and disposition

PXX reached the reviewer but returned `review degraded: unparseable (advisory)` and verdict
`NO_REVIEW`. The run is recorded as unavailable review evidence and is not represented as approval.
Three set-but-unused environment warnings were unrelated to the candidate and were not acted on.

## Coverage limits

No parseable findings or verdict were produced. The exact candidate remains approved by the Codex,
Claude, Kimi, nested one-shot, and deterministic lanes; PXX is supplemental advisory evidence only.
