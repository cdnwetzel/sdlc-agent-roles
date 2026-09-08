#!/usr/bin/env bash
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "$REPO_DIR/scripts/validate-receipts.sh"
bash "$REPO_DIR/scripts/check.sh"
