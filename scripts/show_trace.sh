#!/usr/bin/env bash
# Opens a Playwright trace from a kiip.co run in the Trace Viewer.
# Usage: bash scripts/show_trace.sh [path/to/trace.zip]
set -euo pipefail
cd "$(dirname "$0")/.."
source venv/bin/activate
if [ $# -ge 1 ]; then TRACE="$1"; else
  shopt -s nullglob; traces=(results/kiip_co/traces/*.zip)
  [ ${#traces[@]} -gt 0 ] || { echo "No traces yet. Run: bash scripts/run_kiip_co.sh --trace"; exit 1; }
  echo "Pick a trace:"; select TRACE in "${traces[@]}"; do [ -n "$TRACE" ] && break; done
fi
echo "==> Opening $TRACE"
rfbrowser show-trace "$TRACE" 2>/dev/null || rfbrowser show-trace -F "$TRACE" 2>/dev/null || {
  echo "Couldn't launch the local viewer. Open https://trace.playwright.dev and drag in: $(pwd)/$TRACE"
  open "https://trace.playwright.dev" 2>/dev/null || true
}
