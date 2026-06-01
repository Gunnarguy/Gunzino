# Gunzino

Gunzino is the publisher site and support surface for Gunnar Hostetler's public app catalog. It is not a personal portfolio and it is not a generic AI brand site. Its job is to present product pages, support routes, privacy routes, and App Store review surfaces with direct, technically grounded copy.

## Product Catalog

| Product          | What it is                                               | Main APIs and frameworks                                                                                     | Boundary that matters                                                                                        |
| ---------------- | -------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------ |
| OpenClinic       | Provider-facing clinical workspace prototype             | SwiftUI, SwiftData, Apple Foundation Models, SMART on FHIR, ASWebAuthenticationSession, Core ML, SQLite FTS5 | Local charting and clinical retrieval on device; prototype only, not for live deployment                     |
| OpenIntelligence | Local-first document intelligence app and engine lineage | SwiftUI, Apple Foundation Models, PDFKit, Vision OCR, SQLite FTS5, local vector indexing                     | Shipping iPhone and iPad app with citations and abstention; broader engine boundary lives behind the product |
| OpenResponses    | Direct OpenAI Responses API developer client             | SwiftUI, OpenAI Responses API, SSE streaming, Keychain, PDFKit, Vision, MCP, browser automation              | Uses user-owned OpenAI credentials and talks directly to OpenAI endpoints                                    |
| OpenCone         | Cloud-hybrid RAG client                                  | SwiftUI, Vision OCR, PDFKit, OpenAI Embeddings API, OpenAI Responses API, Pinecone Serverless                | Prepares documents locally but depends on OpenAI and Pinecone for the core cloud path                        |
| OpenAssistant    | Archived Assistants API client                           | SwiftUI, Combine, OpenAI Assistants API v2, vector stores, local file preprocessing                          | Legacy line kept for reference; superseded by OpenResponses                                                  |

## Why This Repo Exists

- Keep public product pages aligned with the actual app architectures.
- Make support, privacy, and legal routes easy to scan.
- Give App Review and users a clear, factual explanation of what each app touches and how it behaves.

## Publisher Rules

- Do not flatten every product into "offline AI apps." Some are local-first, some are cloud-hybrid, and one is a deprecated archive.
- Prefer exact technical nouns over generic marketing language.
- Keep product relationships explicit. OpenClinic uses OpenIntelligence-derived retrieval internals. OpenResponses supersedes OpenAssistant.
- Preserve the support and privacy routes because they are part of the public contract for the apps.

## Repository Layout

- `index.html` - Gunzino homepage and product grid
- `support.html` - general support surface
- `style.css` - shared publisher styling
- `openclinic/` - OpenClinic landing, privacy, and support routes
- `openintelligence/` - OpenIntelligence landing, privacy, and support routes
- `openresponses/` - OpenResponses landing, privacy, and support routes
- `opencone/` - OpenCone landing, privacy, and support routes
- `openassistant/` - OpenAssistant legacy landing, privacy, and support routes
- `scripts/verify-site.sh` - publisher verification helper

## Local Preview

Open `index.html` in a browser, or serve the repository with any static file server.

## Deployment Notes

- GitHub Pages serves this site from `main` at the repository root.
- Local CSS and JS references use query-string cache busting and should be bumped whenever those assets change.
- Each HTML page must keep exactly one GA tag for `G-4Q160W3M61` and include a stylesheet.

## Current Gaps

- `support.html` still contains a placeholder form action and needs a real submission endpoint before the form is live.

## License

Site content is MIT unless otherwise noted. Individual application repos may use different licenses.
