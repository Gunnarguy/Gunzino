# Copilot Instructions for Gunzino

## Non-Negotiable Site Role

Gunzino.me is **The Publisher** in Gunnar Hostetler's web ecosystem.

- **Gunnarguy.me** = The Creator: personal software engineer portfolio, case studies, career story, technical proof.
- **Gunzino.me** = The Publisher: iOS app storefront, support, privacy/legal endpoints, App Store user surfaces.
- **Fascinaiting.me** = The Platform: AI orchestration brand for local AI engines, automated pipelines, native utilities, and product initiatives.

Do not collapse these roles into each other. Gunzino must look and behave like an app publisher/storefront and support hub, not a personal portfolio and not Fascinaiting's AI orchestration platform.

## 10x Web UX Quality Bar

Act like a senior app-store landing page designer and product UX lead when touching the public surface.

- Prioritize fast product comprehension, clean app cards, obvious support/privacy routes, and stable App Store funnels.
- Keep the visual system premium but utilitarian; avoid clutter, novelty panels, and portfolio-style biography sections.
- Make privacy/support/legal paths easy to scan because App Review and users depend on them.
- Use crisp product copy grounded in actual app behavior, platforms, storage boundaries, and constraints.
- Do not ship unstyled HTML. Every HTML page must include a stylesheet or intentional inline style.
- Buttons, cards, nav links, and legal/support layouts must be responsive with no mobile text overflow.

## Style Rules

1. **No Generic Marketing Jargon**
   - Avoid: "revolutionary", "seamlessly", "empower", "unlock", "groundbreaking", "sophisticated", and vague "AI-powered" claims.
   - Use technical, product-specific descriptions of what each app actually does.

2. **Grounding in Technical Specifics**
   - Name exact components when relevant: SwiftUI, SwiftData, Core ML, Vision OCR, PDFKit, ASWebAuthenticationSession, Pinecone, SQLite, local storage, Keychain.
   - Describe data boundaries directly: local-only, opt-in cloud endpoint, keychain storage, account data, App Store support path.

3. **Flat and Honest Structure**
   - Write short, direct sentences.
   - Keep limitations and constraints transparent.
   - App pages should answer: what it is, who it is for, what data it touches, where support/privacy live.

## Content Contract

The site should emphasize:

- App catalog and product landing surfaces.
- OpenIntelligence, OpenResponses, OpenCone, and other public app/support pages.
- Privacy, support, terms, and App Store review compliance.
- Clear outbound download/support funnels.

Avoid:

- Personal portfolio positioning that belongs on Gunnarguy.me.
- AI orchestration platform positioning that belongs on Fascinaiting.me.
- Exposing unfinished experiments as if they are public app products.

## Telemetry Rules

The GA4 property is `G-4Q160W3M61`.

Every meaningful interactive element should use `data-track`, `data-track-group`, and where useful `data-track-value`. Do not duplicate GA tags; each HTML page should have exactly one `googletagmanager.com/gtag/js?id=G-4Q160W3M61` script unless there is a documented reason.

## Cache-Busting Rules

GitHub Pages and browsers can serve stale assets. Local CSS and JS references must use version query strings.

Expected patterns:

```html
<link rel="stylesheet" href="style.css?v=YYYYMMDDx" />
<link rel="stylesheet" href="styles.css?v=YYYYMMDDx" />
<script src="scripts.js?v=YYYYMMDDx"></script>
```

When changing local CSS or JS, bump the query string on every HTML page that references it.

## Deployment Rules

Gunzino.me is hosted by GitHub Pages from `main` at `/`.

Correct DNS state:

```text
A @ 185.199.108.153
A @ 185.199.109.153
A @ 185.199.110.153
A @ 185.199.111.153
CNAME www Gunnarguy.github.io
```

GitHub Pages must report an approved certificate and `https_enforced:true`.

## Validation Checklist

Before finalizing site changes:

```bash
git diff --check
for file in $(find . -name '*.html' -not -path './.git/*' | sort); do css=$(grep -Ec '<link[^>]+rel="stylesheet"|<style>' "$file" || true); ga=$(grep -c 'googletagmanager.com/gtag/js?id=G-4Q160W3M61' "$file" || true); if [[ "$css" -lt 1 || "$ga" -ne 1 ]]; then echo "bad $file css=$css ga=$ga"; fi; done
curl -fsSL -H 'Cache-Control: no-cache' https://gunzino.me/ | grep -E -m 20 '<title>|Gunzino|style\.css|G-4Q160W3M61'
curl -fsSL -H 'Cache-Control: no-cache' https://gunzino.me/openassistant/ | grep -E -m 20 '<title>|OpenAssistant|styles\.css|scripts\.js|G-4Q160W3M61'
curl -vI https://gunzino.me/ 2>&1 | grep -E 'subject:|issuer:|SSL certificate verify ok|HTTP/'
```

Prefer running `./scripts/verify-site.sh` after deployment-oriented changes.

When the user asks whether it is live, answer from actual `curl`, DNS, Pages config, and certificate checks, not from GitHub commit state alone.
