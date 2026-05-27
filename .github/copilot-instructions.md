# GitHub Copilot Style Guidelines

This repository follows a strict developer-first, hype-free documentation and copywriting style. When suggesting code comments, readme files, support documentation, or landing page copy, follow these rules.

## Style Rules

1. **No Marketing Jargon or Buzzwords**
   - Do not use: "revolutionary", "advanced AI", "seamlessly", "empower", "unlock", "bring to your fingertips", "groundbreaking", "cutting-edge", "sophisticated", "AI-powered".
   - Stick to raw technical descriptions of how features work.

2. **Grounding in Technical Specifics**
   - Name the exact framework components used (SwiftUI, SwiftData, Core ML, Vision OCR, PDFKit, ASWebAuthenticationSession).
   - Describe models and boundaries directly (e.g., 384-dim MiniLM embeddings, 4096-token session budgets, Pinecone vector search, SQLite FTS5).

3. **Flat and Honest Structure**
   - Write short, direct sentences.
   - Outline app limitations and constraints transparently (e.g., struggles with legacy/corrupted PDFs, requires Xcode for manual simulation deployment).

4. **Architectural Transparency**
   - Explicitly detail data boundaries (local sandbox storage, keychain encryption, opt-in cloud endpoints).
