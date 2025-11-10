# Gunzino - Advanced AI Applications

This repository contains the landing page and support site for **Gunzino**, showcasing two sophisticated native iOS applications: **OpenCone** and **OpenResponses**. Both apps—and this site—are designed, built, and maintained by Gunnar Guy. Gunnarguy &ndash; Omnidev.

## Featured Applications

### OpenCone

**On-Device RAG for iOS** - [GitHub Repository](https://github.com/Gunnarguy/OpenCone)

OpenCone is a sophisticated, native iOS application that demonstrates Retrieval Augmented Generation (RAG) with a clean SwiftUI interface.

**Key Features:**

- **Document Processing** – upload PDF, DOCX, TXT files, and images with OCR
- **Vector embeddings via OpenAI** – generate embeddings from your documents
- **Pinecone integration** – store and search across embeddings
- **Semantic search** – ask questions and receive context-aware answers
- **RAG-based responses** – combine search results for accurate answers
- **Custom design and theming** – built entirely in SwiftUI with OCDesignSystem
- **Real-time processing logs** – detailed, filterable logs for all operations
- **Comprehensive statistics** – view processing metrics, timings, and token counts

### OpenResponses

**Advanced OpenAI API Playground** - [GitHub Repository](https://github.com/Gunnarguy/OpenResponses)

OpenResponses is a powerful native SwiftUI playground for iOS and macOS, designed to explore the full range of OpenAI's API capabilities.

**Key Features:**

- **Multi-Model Support** – GPT-5, GPT-4.1, O-series reasoning models, and specialized models
- **Enhanced Streaming** – real-time responses with granular status updates
- **Computer Use** – production-ready browser automation with safety approvals
- **Web Search** – access up-to-date information from the internet
- **Code Interpreter** – execute Python code in secure sandboxed environments
- **Image Generation** – create images with gpt-image-1 and real-time previews
- **File Search** – search across vector stores with 43+ file type support
- **MCP Integration** – connect to Model Context Protocol servers (GitHub, Notion, Slack, etc.)
- **Advanced Controls** – fine-tune temperature, tokens, penalties, and reasoning effort
- **Developer Tools** – API inspector, debug console, analytics dashboard, and comprehensive logging
- **Prompt Library** – save and manage reusable prompt configurations
- **Conversation Management** – local storage with export capabilities and multi-conversation support

## Repository Structure

- `index.html` – main landing page showcasing both OpenCone and OpenResponses
- `support.html` – contact form and comprehensive FAQ section for both applications
- `style.css` – modern, responsive styling with dark theme and gradient accents
- `CNAME` – domain mapping for GitHub Pages (gunzino.me)

## Technology Stack

Both applications are built with:

- **SwiftUI** – Native iOS/macOS UI framework
- **MVVM Architecture** – Clean separation of concerns with dedicated service layers
- **async/await & Combine** – Modern Swift concurrency and reactive programming
- **OpenAI API** – Embeddings, completions, and advanced features
- **Custom Design Systems** – Themable, reusable UI components

## Running Locally

Simply open `index.html` in a browser to view the landing page.

### Deploying via GitHub Pages

1. Push the repository to GitHub
2. Enable GitHub Pages in repository settings
3. The CNAME file maps the site to `gunzino.me`

### Contact Form Configuration

The form on `support.html` uses a placeholder action attribute. Replace `YOUR_FORMSPREE_ENDPOINT_OR_OTHER_SERVICE` with the endpoint of your preferred form service (e.g., Formspree, Netlify Forms) before deploying.

## Getting Started with the Applications

### OpenCone Setup

Visit the [OpenCone repository](https://github.com/Gunnarguy/OpenCone) for detailed installation and setup instructions. You'll need:

- Xcode
- OpenAI API Key
- Pinecone API Key and Project ID

### OpenResponses Setup

Visit the [OpenResponses repository](https://github.com/Gunnarguy/OpenResponses) for detailed installation and setup instructions. You'll need:

- Xcode
- OpenAI API Key
- (Optional) Additional API keys for MCP integrations

## Contributing

Contributions to improve the website are welcome! For contributions to the applications themselves, please visit their respective GitHub repositories.

## License

The website content is released under the MIT License unless otherwise noted. Please see the individual application repositories for their respective licenses.
