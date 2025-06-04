# OpenCone

OpenCone is a native iOS application that demonstrates Retrieval Augmented Generation (RAG) with a clean SwiftUI interface. The accompanying site (this repository) provides a landing page and a support page for users.

## Features

- **Document Processing** – upload PDF, DOCX or TXT files
- **Vector embeddings via OpenAI** – generate embeddings from your documents
- **Pinecone integration** – store and search across embeddings
- **Semantic search** – ask questions and receive context-aware answers
- **RAG-based responses** – combine search results for accurate answers
- **Custom design and theme** – built entirely in SwiftUI

## Repository Structure

- `index.html` – main landing page with project overview
- `support.html` – contact form and FAQ section
- `style.css` – shared styling for both pages
- `CNAME` – domain mapping for GitHub Pages

## Running Locally

Simply open `index.html` in a browser. If you wish to deploy via GitHub Pages, push the repository to a GitHub project and enable Pages in the repository settings. The CNAME file maps the site to `gunzino.me`.

### Contact Form

The form on `support.html` uses a placeholder action attribute. Replace `YOUR_FORMSPREE_ENDPOINT_OR_OTHER_SERVICE` with the endpoint of your preferred form service before deploying.

## License

All site content is released under the MIT License unless otherwise noted.
