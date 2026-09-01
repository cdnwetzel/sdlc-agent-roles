#!/usr/bin/env bash
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "$REPO_DIR/scripts/validate-cards.sh"
bash "$REPO_DIR/scripts/test-platform-adapters.sh"
bash "$REPO_DIR/scripts/test-receipt-validator.sh"
bash "$REPO_DIR/scripts/build-skill-zips.sh"
