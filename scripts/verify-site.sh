#!/usr/bin/env bash
set -euo pipefail

domain="${1:-gunzino.me}"

echo "== DNS =="
dig +short "$domain" A
echo

echo "== GitHub Pages config =="
gh api repos/Gunnarguy/Gunzino/pages --jq '{status, cname, html_url, https_enforced, https_certificate}'
echo

echo "== Source sanity =="
git diff --check
missing=0
while IFS= read -r -d '' file; do
  css=$(grep -Ec '<link[^>]+rel="stylesheet"|<style>' "$file" || true)
  ga=$(grep -c 'googletagmanager.com/gtag/js?id=G-4Q160W3M61' "$file" || true)
  if [[ "$css" -lt 1 || "$ga" -ne 1 ]]; then
    echo "bad $file css=$css ga=$ga"
    missing=1
  fi
done < <(find . -name '*.html' -not -path './.git/*' -print0)
if [[ "$missing" -ne 0 ]]; then
  exit 1
fi
echo "html stylesheet/GA sweep: clean"
echo

echo "== HTTPS root content =="
curl -fsSL -H 'Cache-Control: no-cache' "https://$domain/" \
  | grep -E -m 20 '<title>|Gunzino|style\.css|G-4Q160W3M61'
echo

echo "== HTTPS OpenAssistant content =="
curl -fsSL -H 'Cache-Control: no-cache' "https://$domain/openassistant/" \
  | grep -E -m 20 '<title>|OpenAssistant|styles\.css|scripts\.js|G-4Q160W3M61'
echo

echo "== TLS =="
curl -vI "https://$domain/" 2>&1 \
  | grep -E 'subject:|issuer:|SSL certificate verify ok|HTTP/'
echo

echo "== HTTP redirect =="
curl -sI "http://$domain/" | sed -n '1,12p'
