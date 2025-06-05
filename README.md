# OpenCone

OpenCone is a native iOS application that demonstrates Retrieval Augmented Generation (RAG) with a clean SwiftUI interface. The accompanying site (this repository) provides a landing page and a support page for users.

## Features

- **Document Processing** – upload PDF, DOCX or TXT files
- **Vector embeddings via OpenAI** – generate embeddings from your documents
- **Pinecone integration** – store and search across embeddings
- **Semantic search** – ask questions and receive context-aware answers
- **RAG-based responses** – combine search results for accurate answers
- **Custom design and theme** – built entirely in SwiftUI
- **Code execution** – run tasks with a built-in interpreter
- **Direct OpenAI API integration** – communicate directly with OpenAI for fast results

## Repository Structure

- `index.html` – main landing page with project overview
- `support.html` – contact form and FAQ section
- `style.css` – shared styling for both pages
- `CNAME` – domain mapping for GitHub Pages

## How It Works

1. Import documents in PDF, DOCX or TXT format.
2. OpenCone extracts text and generates vector embeddings using OpenAI.
3. Embeddings are stored in Pinecone for fast semantic search.
4. Ask questions and get answers via Retrieval Augmented Generation.


## Running Locally

Simply open `index.html` in a browser. Because the site is purely static, you can host it with GitHub Pages or any other static hosting service. If using GitHub Pages, push the repository to your GitHub account and enable Pages in the repository settings. The CNAME file maps the site to `gunzino.me`.

### Custom Domain

If you are using a registrar such as Porkbun, keep the `CNAME` file containing your domain name at the repository root. After enabling GitHub Pages, configure your DNS records at the registrar to point to GitHub's servers.

### Contact Form

The form on `support.html` uses a placeholder action attribute. Replace `YOUR_FORMSPREE_ENDPOINT_OR_OTHER_SERVICE` with the endpoint of your preferred form service before deploying.

## License

All site content is released under the MIT License unless otherwise noted.
