# Baseline / log manifest — 2026-11-08

## Source archive (complete historical build, not 1.5.9)

- `FanqieAdBlock-1.5.8-repair-kit.zip` (ChatGPT Library, libfile_b99f675930608191aaee8faa7293fef1)
- SHA-256: `cf9cad8ea1529b6eb8ce8483525e1efb6839159af31111187c4666382300b2b6`
- 485525 bytes. Contains full `repair158/`, `audit158/`, `baseline/`, `output158/`, `REPRODUCE.txt`, `SHA256SUMS.txt`, reports.
- Open via https://chatgpt.com/library?file_id=libfile_b99f675930608191aaee8faa7293fef1&account_id=personal
- `FanqieAdBlock-1.5.7-repair-kit.zip` SHA-256: `773abaae723d377902755fdca53bfa8ca4147a93addaa30aa47b977e8bb3f284`
- User-uploaded 1.5.8 dylib SHA-256: `55a2c02e5962ad740816aaf2f8f2f6d9269eb9ecce37c69402897ff3776a4354`, 123280 bytes, exact match to archive's output158 plugin.

## Mixed-version diagnostic log — do not misinterpret

Filename: `DD1B6E45-73BA-4CC2-913F-29CFF3901D0D.json` (approximately 14 MB). The top-level `pluginVersion` is `1.5.7`, but this is **not** a single-version log:
- 952 total event entries;
- **899** entries record `pluginVersion=1.5.7`;
- **53** entries record `pluginVersion=1.5.8`;
- the last `export_snapshot` is 1.5.8;
- among the 1.5.8 records: 50 `bottom_bar_state_changed`, 1 `plugin_start`, 1 `reader_layout`, and 1 `export_snapshot`.

Compare **only 1.5.8 events** for new-version runtime state; 1.5.7 records are useful for historical comparison, not evidence of active 1.5.8 behavior. Keep the raw log out of public GitHub, as it may disclose device and UI context.

## Offline rebuild of original 1.5.8

After extracting the full archive and entering its top folder:

```sh
python3 repair158/build_plugin.py baseline/FanqieAdBlock-1.5.7.dylib output158/FanqieAdBlock-1.5.8.dylib
python3 repair158/audit_extend.py output158/FanqieAdBlock-1.5.8.preextend output158/FanqieAdBlock-1.5.8.dylib --extension output158/FanqieAdBlock-1.5.8.extension.bin
python3 audit158/test_feed_viewport.py output158/FanqieAdBlock-1.5.8.dylib --report output158/feed-audit.json
python3 audit158/test_reader_fastpath.py --candidate output158/FanqieAdBlock-1.5.8.dylib --validation output158/FanqieAdBlock-1.5.8.validation.json --baseline157 baseline/FanqieAdBlock-1.5.7.dylib --baseline-validation baseline/FanqieAdBlock-1.5.7.validation.json --report output158/reader-audit.json
```

Also execute remaining commands in archive `REPRODUCE.txt`. Tests previously passed on the baseline, **yet the reported UI defects persist**. No device injection / UIKit render verification has been performed.

## Important limitation of this GitHub checkpoint

This commit saves handoff and archive pointers, **not the complete archive's bytes**, because the GitHub write interface currently cannot directly consume the archived source file from ChatGPT Library. On a writable development environment, download/materialize the archive, restore all folders, commit source/build/tests onto this branch, and verify the result. Do not claim source code has been fully uploaded or a 1.5.9 binary exists.
