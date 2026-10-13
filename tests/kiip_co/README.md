# kiip.co smoke suite

Robot Framework + Browser (Playwright) smoke tests against the **live** https://www.kiip.co
Case Management login app. Separate from the demo app tests (`tests/smoke.robot`,
`tests/regression.robot`), which run against the local FastAPI app.

Default runs are read-only: no login, password reset, sign-up or contact form is submitted.

## Run locally

```bash
bash scripts/run_kiip_co.sh                         # whole suite (installs Browser lib + Chromium on first run)
bash scripts/run_kiip_co.sh -v HEADLESS:False       # watch it
bash scripts/run_kiip_co.sh --trace --video         # record Playwright traces + video
bash scripts/show_trace.sh                          # open a trace in the Trace Viewer
bash scripts/run_kiip_co.sh tests/kiip_co/04_contact_modal.robot   # one file
KIIP_EMAIL=… KIIP_PASSWORD=… bash scripts/run_kiip_co.sh           # include real-login test
```

Results: `results/kiip_co/` (report.html, log.html, traces/).

## Run in CI

Actions tab → **Kiip Demo CI/CD Pipeline** → **Run workflow**:
- **target**: `kiip-co-only` (just this suite) or `full-pipeline` (demo smoke → regression → deploy stubs + this suite)
- **trace**: record traces + video

Results are uploaded as the `kiip-co-results` artifact on the run page.
Optional secrets `KIIP_EMAIL` / `KIIP_PASSWORD` enable the real-login test.

## Files

| File | Checks |
|---|---|
| `01_login_page.robot` | apex→www redirect, form fields, required attrs, client-side validation, show/hide password, nav links, footer links, mobile render |
| `02_forgot_password.robot` | page loads, required email, empty submit blocked, Back → login; known-issue: Back from directly opened page |
| `03_create_account.robot` | page loads, wizard steps, email + Next, Log In → login |
| `04_contact_modal.robot` | Contact Us modal opens with all fields, Cancel closes it |
| `05_auth.robot` | opt-in: valid creds leave login (needs env vars); invalid creds (`auth-negative`, excluded by default) |
| `resources/common.resource` | selectors, settings (`BASE_URL`, `HEADLESS`, `TRACE`, `VIDEO`), shared keywords |
| `kiip_co.args` | default Robot options (tags, output dir) |

## Notes

- Client-rendered Next.js/Chakra app with no `data-testid`s — locators use ids, names, placeholders, text.
- "Page ready" = the page's `<h1>` is visible (not `networkidle`; analytics/RUM beacons never go idle).
- The site logs `cognito-identity` 400s on every load; the suite ignores them.
- **Known bug (low):** the Reset Password page's on-page Back button calls `history.back()` despite its `href="/"`,
  so opening `/forgot-password` directly and clicking Back doesn't reach login. `Back Returns To Login` arrives via
  the login page (the normal path); `Back From Directly Opened Reset Page Returns To Login` documents the bug and is
  tagged `known-issue` (excluded by default). Run it with: `bash scripts/run_kiip_co.sh --known-issues`
