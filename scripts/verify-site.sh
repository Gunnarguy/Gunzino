#!/usr/bin/env bash
set -euo pipefail

mode="${1:-all}"
domain="${2:-gunzino.me}"
repo_slug="Gunnarguy/Gunzino"
expected_cname="gunzino.me"
expected_branch="main"
expected_path="/"

usage() {
  cat <<'EOF'
Usage: ./scripts/verify-site.sh [all|source|live|ci-live] [domain]

Modes:
  source   Run repository-only checks.
  live     Run DNS, Pages, deployed-content, TLS, and redirect checks.
  ci-live  Wait for the current commit's Pages build, then run live checks.
  all      Run source checks, then live checks.
EOF
}

section() {
  printf '== %s ==\n' "$1"
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$1" >&2
    exit 1
  fi
}

lookup_a_records() {
  if command -v dig >/dev/null 2>&1; then
    dig +short "$domain" A
    return
  fi

  if command -v nslookup >/dev/null 2>&1; then
    nslookup -type=A "$domain" | awk '/^Address: / { print $2 }'
    return
  fi

  printf 'DNS lookup tool unavailable\n'
}

extract_first_match() {
  local file="$1"
  local regex="$2"

  extract_match_from_text "$(cat "$file")" "$regex" "$file"
}

extract_match_from_text() {
  local text="$1"
  local regex="$2"
  local source_label="${3:-input}"
  local match

  match="$(grep -Eo "$regex" <<<"$text" | head -n 1 || true)"
  if [[ -z "$match" ]]; then
    printf 'Failed to extract %s from %s\n' "$regex" "$source_label" >&2
    exit 1
  fi

  printf '%s\n' "$match"
}

assert_contains() {
  local haystack="$1"
  local needle="$2"

  if ! grep -Fq -- "$needle" <<<"$haystack"; then
    printf 'Expected to find "%s" in fetched content\n' "$needle" >&2
    exit 1
  fi
}

git_file_text() {
  git show "$1:$2" 2>/dev/null || true
}

has_verify_diff_base() {
  [[ -n "${VERIFY_DIFF_BASE:-}" ]] || return 1
  git rev-parse -q --verify "${VERIFY_DIFF_BASE}^{commit}" >/dev/null 2>&1
}

diff_includes_file() {
  local file="$1"

  has_verify_diff_base || return 1
  git diff --name-only "$VERIFY_DIFF_BASE" HEAD -- "$file" | grep -q .
}

normalize_tokens() {
  sed -E 's/^.*\?v=//' | sed '/^$/d' | sort -u
}

single_token_from_worktree() {
  local regex="$1"
  shift
  local tokens
  local count

  tokens="$({
    local file
    for file in "$@"; do
      [[ -f "$file" ]] || continue
      grep -Eo "$regex" "$file" || true
    done
  } | normalize_tokens)"
  count="$(printf '%s\n' "$tokens" | sed '/^$/d' | wc -l | tr -d '[:space:]')"

  if [[ "$count" != "1" ]]; then
    printf 'Expected a single token for %s, found:\n%s\n' "$regex" "$tokens" >&2
    exit 1
  fi

  printf '%s\n' "$tokens"
}

single_token_at_ref() {
  local ref="$1"
  local regex="$2"
  shift 2
  local tokens
  local count

  tokens="$({
    local file
    for file in "$@"; do
      git show "$ref:$file" 2>/dev/null | grep -Eo "$regex" || true
    done
  } | normalize_tokens)"
  count="$(printf '%s\n' "$tokens" | sed '/^$/d' | wc -l | tr -d '[:space:]')"

  if [[ "$count" != "1" ]]; then
    printf 'Expected a single base token for %s at %s, found:\n%s\n' "$regex" "$ref" "$tokens" >&2
    exit 1
  fi

  printf '%s\n' "$tokens"
}

assert_group_token_bumped() {
  local asset_file="$1"
  local label="$2"
  local regex="$3"
  shift 3
  local current_token
  local base_token

  if ! diff_includes_file "$asset_file"; then
    printf '%s unchanged; skip\n' "$asset_file"
    return
  fi

  current_token="$(single_token_from_worktree "$regex" "$@")"
  base_token="$(single_token_at_ref "$VERIFY_DIFF_BASE" "$regex" "$@")"

  if [[ "$current_token" == "$base_token" ]]; then
    printf '%s changed but %s was not bumped (%s)\n' "$asset_file" "$label" "$current_token" >&2
    exit 1
  fi

  printf '%s bumped: %s -> %s\n' "$label" "$base_token" "$current_token"
}

gh_pages_field() {
  require_cmd gh
  gh api -H 'X-GitHub-Api-Version: 2022-11-28' "repos/$repo_slug/pages" --jq "$1"
}

gh_latest_build_field() {
  require_cmd gh
  gh api -H 'X-GitHub-Api-Version: 2022-11-28' "repos/$repo_slug/pages/builds/latest" --jq "$1"
}

fetch_body() {
  curl -fsSL --retry 3 --retry-all-errors -H 'Cache-Control: no-cache' "$1"
}

https_headers() {
  curl -fsSI --retry 3 --retry-all-errors "$1"
}

http_headers() {
  curl -sSI --retry 3 --retry-all-errors "$1"
}

run_source_checks() {
  local missing
  local root_style_ref
  local openassistant_style_ref
  local openassistant_script_ref

  section "Source sanity"
  git diff --check

  missing=0
  while IFS= read -r -d '' file; do
    css="$(grep -Ec '<link[^>]+rel="stylesheet"|<style>' "$file" || true)"
    ga="$(grep -c 'googletagmanager.com/gtag/js?id=G-8CQD5KZ06Y' "$file" || true)"
    if [[ "$css" -lt 1 || "$ga" -ne 1 ]]; then
      printf 'bad %s css=%s ga=%s\n' "$file" "$css" "$ga" >&2
      missing=1
    fi
  done < <(find . -name '*.html' -not -path './.git/*' -print0)

  if [[ "$missing" -ne 0 ]]; then
    exit 1
  fi

  root_style_ref="$(extract_first_match index.html 'style\.css\?v=[^"]+')"
  openassistant_style_ref="$(extract_first_match openassistant/index.html 'styles\.css\?v=[^"]+')"
  openassistant_script_ref="$(extract_first_match openassistant/index.html 'scripts\.js\?v=[^"]+')"

  printf 'html stylesheet/GA sweep: clean\n'
  printf 'root style ref: %s\n' "$root_style_ref"
  printf 'openassistant style ref: %s\n' "$openassistant_style_ref"
  printf 'openassistant script ref: %s\n\n' "$openassistant_script_ref"

  run_asset_bump_checks
}

run_asset_bump_checks() {
  local root_style_files=(
    index.html
    support.html
    openclinic/index.html
    openclinic/privacy/index.html
    openclinic/support/index.html
    openintelligence/index.html
    openintelligence/privacy/index.html
    openintelligence/support/index.html
    openresponses/index.html
    openresponses/privacy/index.html
    openresponses/support/index.html
    opencone/index.html
    opencone/privacy/index.html
    opencone/support/index.html
  )
  local openassistant_files=(
    openassistant/index.html
    openassistant/privacy/index.html
    openassistant/terms/index.html
    openassistant/interactions.html
    openassistant/architecture.html
    openassistant/support/index.html
  )
  local root_style_token
  local openassistant_style_token
  local openassistant_script_token

  section "Asset version bumps"
  root_style_token="$(single_token_from_worktree '/?style\.css\?v=[^"]+' "${root_style_files[@]}")"
  openassistant_style_token="$(single_token_from_worktree '(\.\./)?styles\.css\?v=[^"]+' "${openassistant_files[@]}")"
  openassistant_script_token="$(single_token_from_worktree '(\.\./)?scripts\.js\?v=[^"]+' "${openassistant_files[@]}")"

  printf 'root style.css token: %s\n' "$root_style_token"
  printf 'openassistant styles.css token: %s\n' "$openassistant_style_token"
  printf 'openassistant scripts.js token: %s\n' "$openassistant_script_token"

  if ! has_verify_diff_base; then
    printf '\n'
    return
  fi

  assert_group_token_bumped "style.css" 'root style.css token' '/?style\.css\?v=[^"]+' "${root_style_files[@]}"
  assert_group_token_bumped "openassistant/styles.css" 'openassistant styles.css token' '(\.\./)?styles\.css\?v=[^"]+' "${openassistant_files[@]}"
  assert_group_token_bumped "openassistant/scripts.js" 'openassistant scripts.js token' '(\.\./)?scripts\.js\?v=[^"]+' "${openassistant_files[@]}"
  printf '\n'
}

run_pages_checks() {
  local status
  local cname
  local https_enforced
  local https_state
  local source_branch
  local source_path

  section "GitHub Pages config"
  gh api -H 'X-GitHub-Api-Version: 2022-11-28' "repos/$repo_slug/pages" \
    --jq '{status, cname, html_url, https_enforced, https_certificate, source}'

  status="$(gh_pages_field '.status')"
  cname="$(gh_pages_field '.cname')"
  https_enforced="$(gh_pages_field '.https_enforced')"
  https_state="$(gh_pages_field '.https_certificate.state')"
  source_branch="$(gh_pages_field '.source.branch')"
  source_path="$(gh_pages_field '.source.path')"

  if [[ "$mode" != "ci-live" ]]; then
    [[ "$status" == "built" ]] || {
      printf 'Expected Pages status built, found %s\n' "$status" >&2
      exit 1
    }
  fi
  [[ "$cname" == "$expected_cname" ]] || {
    printf 'Expected Pages cname %s, found %s\n' "$expected_cname" "$cname" >&2
    exit 1
  }
  [[ "$https_enforced" == "true" ]] || {
    printf 'Expected https_enforced=true, found %s\n' "$https_enforced" >&2
    exit 1
  }
  [[ "$https_state" == "approved" ]] || {
    printf 'Expected https_certificate.state=approved, found %s\n' "$https_state" >&2
    exit 1
  }
  [[ "$source_branch" == "$expected_branch" ]] || {
    printf 'Expected Pages branch %s, found %s\n' "$expected_branch" "$source_branch" >&2
    exit 1
  }
  [[ "$source_path" == "$expected_path" ]] || {
    printf 'Expected Pages path %s, found %s\n' "$expected_path" "$source_path" >&2
    exit 1
  }

  printf '\n'
}

latest_build_contains_expected() {
  local expected_commit="$1"
  local latest_commit="$2"

  [[ -n "$latest_commit" ]] || return 1
  [[ "$latest_commit" == "$expected_commit" ]] && return 0

  if git merge-base --is-ancestor "$expected_commit" "$latest_commit" >/dev/null 2>&1; then
    return 0
  fi

  git fetch --quiet --depth=50 origin "$expected_branch" >/dev/null 2>&1 || true
  git merge-base --is-ancestor "$expected_commit" "$latest_commit" >/dev/null 2>&1
}

wait_for_pages_build() {
  local expected_commit
  local latest_commit
  local latest_status
  local latest_error
  local latest_created_at
  local commit_time
  local attempts
  local sleep_seconds
  local saw_expected_commit
  local time_diff

  expected_commit="${GITHUB_SHA:-$(git rev-parse HEAD)}"
  attempts="${PAGES_BUILD_ATTEMPTS:-40}"
  sleep_seconds="${PAGES_BUILD_SLEEP_SECONDS:-15}"
  saw_expected_commit=0

  section "Wait for Pages build"
  printf 'expected commit: %s\n' "$expected_commit"

  while (( attempts > 0 )); do
    latest_commit="$(gh_latest_build_field '.commit')"
    latest_status="$(gh_latest_build_field '.status')"
    latest_error="$(gh_latest_build_field '.error.message // ""')"
    latest_created_at="$(gh_latest_build_field '.created_at')"

    printf 'latest commit=%s status=%s created_at=%s\n' "$latest_commit" "$latest_status" "$latest_created_at"

    if [[ "$latest_status" == "built" ]]; then
      if [[ "$latest_commit" == "$expected_commit" ]] || latest_build_contains_expected "$expected_commit" "$latest_commit"; then
        printf '\n'
        return 0
      fi

      # Bypassing the GitHub webhook race condition: if the build completed successfully,
      # and was created at or after the expected commit's commit time (with 60s buffer),
      # it contains our changes because pages checkout uses the branch head.
      commit_time="$(git show -s --format=%cI "$expected_commit")"
      time_diff=$(python3 -c "
import sys
from datetime import datetime
def parse_date(d_str):
    d_str = d_str.replace('Z', '+00:00')
    try: return datetime.fromisoformat(d_str).timestamp()
    except Exception: return 0
print(int(parse_date(sys.argv[2]) - parse_date(sys.argv[1])))
" "$commit_time" "$latest_created_at" 2>/dev/null || echo -999)

      if (( time_diff >= -60 )); then
        printf '\nPages build (commit %s) built at %s, which is after expected commit %s (diff %ds).\nThe deployed site contains expected changes.\n\n' \
          "$latest_commit" "$latest_created_at" "$commit_time" "$time_diff"
        return 0
      else
        printf 'Latest build (commit %s, built at %s) is older than expected commit %s (diff %ds). Waiting for new build...\n' \
          "$latest_commit" "$latest_created_at" "$commit_time" "$time_diff"
      fi
    elif [[ "$latest_status" == "errored" || "$latest_status" == "error" || "$latest_status" == "failed" || "$latest_status" == "canceled" ]]; then
      if [[ -n "$latest_error" ]]; then
        printf 'Pages build error: %s\n' "$latest_error" >&2
      fi
      exit 1
    fi

    attempts=$((attempts - 1))
    if (( attempts == 0 )); then
      printf 'Timed out waiting for GitHub Pages to build commit %s\n' "$expected_commit" >&2
      exit 1
    fi

    sleep "$sleep_seconds"
  done
}

run_live_checks() {
  local root_html
  local openassistant_html
  local root_title
  local root_style_ref
  local openassistant_title
  local openassistant_style_ref
  local openassistant_script_ref

  root_title="$(extract_first_match index.html '<title>[^<]+')"
  root_title="${root_title#<title>}"
  root_style_ref="$(extract_first_match index.html 'style\.css\?v=[^"]+')"
  openassistant_title="$(extract_first_match openassistant/index.html '<title>[^<]+')"
  openassistant_title="${openassistant_title#<title>}"
  openassistant_style_ref="$(extract_first_match openassistant/index.html 'styles\.css\?v=[^"]+')"
  openassistant_script_ref="$(extract_first_match openassistant/index.html 'scripts\.js\?v=[^"]+')"

  section "DNS"
  lookup_a_records
  printf '\n'

  root_html="$(fetch_body "https://$domain/")"
  openassistant_html="$(fetch_body "https://$domain/openassistant/")"

  section "HTTPS root content"
  assert_contains "$root_html" "$root_title"
  assert_contains "$root_html" "$root_style_ref"
  assert_contains "$root_html" 'G-8CQD5KZ06Y'
  printf '%s\n' "$root_html" | grep -E -m 20 '<title>|Gunzino|style\.css|G-8CQD5KZ06Y'
  printf '\n'

  section "HTTPS OpenAssistant content"
  assert_contains "$openassistant_html" "$openassistant_title"
  assert_contains "$openassistant_html" "$openassistant_style_ref"
  assert_contains "$openassistant_html" "$openassistant_script_ref"
  assert_contains "$openassistant_html" 'G-8CQD5KZ06Y'
  printf '%s\n' "$openassistant_html" | grep -E -m 20 '<title>|OpenAssistant|styles\.css|scripts\.js|G-8CQD5KZ06Y'
  printf '\n'
}

run_tls_checks() {
  section "TLS"
  echo | openssl s_client -connect "$domain:443" -servername "$domain" 2>/dev/null \
    | openssl x509 -noout -subject -issuer -dates
  https_headers "https://$domain/" | sed -n '1,12p'
  printf '\n'
}

run_redirect_checks() {
  local headers

  section "HTTP redirect"
  headers="$(http_headers "http://$domain/")"
  printf '%s\n' "$headers" | sed -n '1,12p'
  printf '%s\n' "$headers" | grep -qi '^location: https://'
  printf '\n'
}

run_live_suite() {
  run_pages_checks
  run_live_checks
  run_tls_checks
  run_redirect_checks
}

case "$mode" in
  source)
    run_source_checks
    ;;
  live)
    run_live_suite
    ;;
  ci-live)
    run_pages_checks
    wait_for_pages_build
    run_live_checks
    run_tls_checks
    run_redirect_checks
    ;;
  all)
    run_source_checks
    run_live_suite
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac
