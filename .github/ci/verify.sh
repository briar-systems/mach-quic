#!/usr/bin/env bash
# host independent, so the primary leg checks it once
set -euo pipefail
[ "${MACH_CI_PRIMARY:-true}" = true ] || exit 0

# every test under src is collected by `mach test . --lib tests` on some target
tools/test-selection "$MACH_COMPILER"

# doc/api is what `mach doc` writes, so a doc-comment edit whose page was not
# regenerated, and a page whose module is gone, both fail here
mkdir -p out
docgen=$(mktemp -d out/docgen.XXXXXX)
trap 'rm -rf -- "$docgen"' EXIT
"$MACH_COMPILER" doc . --out "$docgen" -q
diff -r "$docgen" doc/api
