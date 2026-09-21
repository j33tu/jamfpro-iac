# PPD files

Drop actual `.ppd` files here, one per printer that needs a manufacturer
driver instead of the generic CUPS driver.

Reference them from `modules/printers/variables.tf` via `ppd_filename`,
and make sure the matching printer entry has `use_generic = false`.

PPD files are typically found on macOS at:
`/Library/Printers/PPDs/Contents/Resources/`

Note: some PPDs are gzip-compressed (`.gz`). Decompress before committing
so `file()` can read it as plain text.
