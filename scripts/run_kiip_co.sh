#!/usr/bin/env bash
# Runs the kiip.co smoke suite (tests/kiip_co) against the live site.
# Usage: bash scripts/run_kiip_co.sh [--trace] [--video] [extra robot args] [tests/kiip_co/<file>.robot]
#   --trace  Playwright trace per suite -> results/kiip_co/traces/*.zip (view: bash scripts/show_trace.sh)
#   --known-issues  run only tests tagged known-issue (documented bugs, expected to fail)
#   --video  video of each browser session, embedded in results/kiip_co/log.html
#   e.g. bash scripts/run_kiip_co.sh --trace -v HEADLESS:False
set -euo pipefail
cd "$(dirname "$0")/.."     # repo root

# Use the repo's venv/ (create it if missing). Robot needs Python 3.11+ for recent releases.
if [ ! -x venv/bin/python ]; then
  PY=""
  for cand in python3.13 python3.12 python3.11 /opt/homebrew/bin/python3 python3; do
    if command -v "$cand" >/dev/null 2>&1 && "$cand" -c 'import sys; sys.exit(0 if sys.version_info >= (3, 11) else 1)' 2>/dev/null; then
      PY="$(command -v "$cand")"; break
    fi
  done
  [ -n "$PY" ] || { echo "Python 3.11+ is required: brew install python@3.11"; exit 1; }
  echo "==> Creating venv/ with $("$PY" --version)"
  "$PY" -m venv venv
fi
source venv/bin/activate
command -v node >/dev/null || { echo "Node.js 18+ is required by the Browser library (brew install node)"; exit 1; }

# Install deps / Playwright browsers only when missing.
if ! python -c "import Browser" 2>/dev/null; then
  echo "==> Installing requirements"
  pip install -r requirements.txt
fi
if [ ! -d "$(python -c 'import Browser, os; print(os.path.dirname(Browser.__file__))')/wrapper/node_modules/playwright-core" ]; then
  echo "==> Installing Playwright + Chromium (one-time, a few minutes)"
  rfbrowser init chromium
fi

ARGS=(); TARGETS=(); KNOWN=0
for a in "$@"; do
  case "$a" in
    --trace) ARGS+=(-v TRACE:True) ;;
    --video) ARGS+=(-v VIDEO:True) ;;
    --known-issues) KNOWN=1 ;;
    *.robot|tests/kiip_co|tests/kiip_co/*) TARGETS+=("$a") ;;
    *) ARGS+=("$a") ;;
  esac
done
[ ${#TARGETS[@]} -gt 0 ] || TARGETS=(tests/kiip_co)
rm -rf results/kiip_co/traces

echo "==> Running kiip.co smoke suite"
status=0
# Options must come before the test path(s).
if [ "$KNOWN" = 1 ]; then
  # Only the known-bug tests (skips the args file, whose --exclude known-issue would win over --include).
  echo "==> Running known-issue tests only (these are EXPECTED to fail until the bugs are fixed)"
  robot --name "Known Issues" --outputdir results/kiip_co --include known-issue ${ARGS[@]+"${ARGS[@]}"} "${TARGETS[@]}" || status=$?
else
  robot -A tests/kiip_co/kiip_co.args ${ARGS[@]+"${ARGS[@]}"} "${TARGETS[@]}" || status=$?
fi
echo "==> Report: $(pwd)/results/kiip_co/report.html"
[ -d results/kiip_co/traces ] && echo "==> Traces in results/kiip_co/traces  (view: bash scripts/show_trace.sh)"
open results/kiip_co/report.html 2>/dev/null || true
exit $status
