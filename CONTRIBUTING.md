# Contributing

Contributions are welcome. Keep changes narrow, explain the lifecycle problem being solved, and
preserve the separation-of-duties model.

Before opening a pull request, run:

```bash
bash scripts/check.sh
```

Role behavior belongs in `skills/sdlc-role/dispatcher.md` or the relevant canonical card. Platform
wrappers should remain thin. Do not duplicate canonical content into an adapter.

Public changes need provenance receipts under `receipts/`; release-gate evidence belongs under the
current `review/<release>/` directory and must follow `review/RECEIPTS.md`. Contributors run the
candidate gate above; the maintainer owns the final exact-subject review lanes and `build-all.sh`.

By contributing, you agree that your contribution is licensed under the MIT License.
