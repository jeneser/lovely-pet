# Action sprite QA

This PR adds `pipeline/scripts/validate-action-sprite-sheets.py` so action sheets are checked beyond basic image dimensions.

The check verifies each generated action sheet uses the expected `6400x340` sheet size, exposes exactly twenty `320x340` runtime frames, and keeps visible content away from crop edges.

The `yawn` sheet was regenerated after the new check identified the previous first-frame sprite merge.

See `ACTION_TRIGGER_RULES.md` for the trigger matrix.
