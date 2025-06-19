# OpenCone

OpenCone is a native iOS application that showcases an end-to-end Retrieval Augmented Generation (RAG) pipeline. This repository hosts a simple landing page and support portal for the app.

## Key Features

- **Document & Image Processing** – import PDF, DOCX, TXT files or images via OCR
- **Vector embeddings via OpenAI** – generate high‑quality embeddings for your documents
- **Pinecone integration** – store and search vectors efficiently
- **Semantic search & RAG answers** – ask questions and get context‑aware responses
- **Code execution** – run advanced tasks through a built‑in interpreter
- **Direct OpenAI API integration** – communicate with OpenAI for fast results
- **Detailed logs & statistics** – track processing progress inside the app
- **Custom themes** – personalize the UI with multiple built‑in themes
- **Guided setup** – onboarding screens help configure required API keys
1. Import documents or images.
2. Text is extracted and chunked before generating vector embeddings with OpenAI.
3. Embeddings are stored in Pinecone for semantic search.
4. Query your data and receive answers via Retrieval Augmented Generation.
## Repository Structure

- `index.html` – landing page with feature overview
- `support.html` – contact form and FAQ
- `style.css` – shared styling for all pages
- `CNAME` – custom domain mapping for GitHub Pages
## Deploying
Open `index.html` directly or deploy the site with GitHub Pages or any static host. Keep the `CNAME` file to use the domain `gunzino.me`.
The form on `support.html` uses a placeholder `action`. Replace `YOUR_FORMSPREE_ENDPOINT_OR_OTHER_SERVICE` with your form service before going live.

### Video Demo Checklist

When recording a walkthrough:
1. Complete the API key setup screens.
2. Upload a document and show processing details.
3. Perform a search and display the generated answer with sources.
4. Switch themes and glance at the logging tab.


## Running Locally

Simply open `index.html` in a browser. Because the site is purely static, you can host it with GitHub Pages or any other static hosting service. If using GitHub Pages, push the repository to your GitHub account and enable Pages in the repository settings. The CNAME file maps the site to `gunzino.me`.

### Custom Domain

If you are using a registrar such as Porkbun, keep the `CNAME` file containing your domain name at the repository root. After enabling GitHub Pages, configure your DNS records at the registrar to point to GitHub's servers.
=======
## Running Locally

Simply open `index.html` in a browser. If you wish to deploy via GitHub Pages, push the repository to a GitHub project and enable Pages in the repository settings. The CNAME file maps the site to `gunzino.me`.
>>>>>>> origin/main

### Contact Form

The form on `support.html` uses a placeholder action attribute. Replace `YOUR_FORMSPREE_ENDPOINT_OR_OTHER_SERVICE` with the endpoint of your preferred form service before deploying.

## License

All site content is released under the MIT License unless otherwise noted.
