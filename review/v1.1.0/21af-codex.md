# Release review receipt: 21af-codex

**Run ID:** 21af-codex
**Actor:** Codex review agent
**Lane:** codex
**Result:** FAIL
**Subject:** 21afc6d3577adad818a2d6521620127be16003767bd7f6d961be1be1bb22ecad — staged public-release candidate
**Invocation:** YAML and receipt-completeness review

## Findings and disposition

Revision required: anchors, tags, and bare garbage could evade frontmatter checks, and extra staged receipts could be omitted from the manifest.

## Coverage limits

Superseded candidate; both issues were hardened.
