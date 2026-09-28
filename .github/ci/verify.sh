#!/usr/bin/env bash
# host independent, so the primary leg checks it once
set -euo pipefail
[ "${MACH_CI_PRIMARY:-true}" = true ] || exit 0

# every test under src is collected by `mach test . --lib tests` on some target
tools/test-selection "$MACH_COMPILER"
