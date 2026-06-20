import os
import re

GA_SNIPPET = """    <!-- ====================================================================== -->
    <!-- UNIFIED GLOBAL TELEMETRY ENGINE & CUSTOM DATA INTERCEPTOR            -->
    <!-- ====================================================================== -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-4Q160W3M61"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag() { dataLayer.push(arguments); }
      const GA_MEASUREMENT_ID = "G-4Q160W3M61";
      gtag('js', new Date());
      gtag('config', GA_MEASUREMENT_ID, {
        transport_type: "beacon"
      });
    </script>

    <script>
      document.addEventListener("DOMContentLoaded", function () {
        document.body.addEventListener("click", function (event) {
          var interactiveTarget = event.target.closest("[data-track]");
          if (interactiveTarget) {
            var actionLabel = interactiveTarget.getAttribute("data-track");
            var actionGroup = interactiveTarget.getAttribute("data-track-group") || "general_interaction";
            var actionValue = interactiveTarget.getAttribute("data-track-value") || "";

            if (typeof gtag === "function") {
              gtag("event", "ui_interaction_event", {
                interaction_label: actionLabel,
                interaction_group: actionGroup,
                interaction_value: actionValue,
                page_location_path: window.location.pathname,
              });
            }
          }
        }, true);
      });
    </script>
    <!-- ====================================================================== -->"""

SEO_DATA = {
    "index.html": {
        "title": "Gunzino | Discover the Next-Gen Apple AI Apps Transforming Workflows",
        "description": "Explore Gunzino's suite of powerful, privacy-first iOS & macOS apps. From local AI document intelligence to clinical workspaces, discover the tools transforming professional workflows today.",
    },
    "openclinic/index.html": {
        "title": "OpenClinic | The Future of Apple-Native Clinical Workspaces Is Here",
        "description": "Unlock a blazing-fast, provider-first clinical workspace for iPhone, iPad, and Mac. Featuring SMART on FHIR import, local SwiftData charting, and on-device Apple Foundation Models. See why clinicians are paying attention.",
    },
    "openintelligence/index.html": {
        "title": "OpenIntelligence | Unlock Local Apple Intelligence & Agentic RAG",
        "description": "Supercharge your document workflow with OpenIntelligence. Experience Apple Intelligence-fueled agentic RAG, local 3B-parameter on-device models, and private PDF extraction. Build your second brain locally.",
    },
    "openresponses/index.html": {
        "title": "OpenResponses | The Ultimate Direct Responses API Playground",
        "description": "Take full control of the OpenAI /v1/responses API. Our native SwiftUI client offers streaming events, reasoning traces, web search, code interpreter, and local Keychain security. Stop waiting—start building.",
    },
    "opencone/index.html": {
        "title": "OpenCone | Supercharge Search with Cloud-Hybrid OCR & Vectors",
        "description": "Extract and OCR your files locally with PDFKit and Vision, then unlock lightning-fast vector search with OpenAI and Pinecone serverless indexing. The hybrid search solution you've been waiting for.",
    },
    "openassistant/index.html": {
        "title": "OpenAssistant | Master the Legacy OpenAI Assistants API",
        "description": "Explore the original native iOS dashboard for OpenAI Assistants API threads, runs, and vector stores. Reliable, fast, and maintained for your reference.",
    },
    "support.html": {
        "title": "Gunzino Support | Get Help With Our Apple-Native AI Apps",
        "description": "Need help with OpenClinic, OpenIntelligence, or other Gunzino apps? Access our support hub for FAQs, contact information, and technical troubleshooting.",
    }
}

def update_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Update GA snippet
    # Using a regex that captures everything between the two exact comments.
    ga_pattern = re.compile(
        r'([ \t]*)<!-- ====================================================================== -->\s*'
        r'<!-- UNIFIED GLOBAL TELEMETRY ENGINE & CUSTOM DATA INTERCEPTOR            -->\s*'
        r'<!-- ====================================================================== -->\s*'
        r'.*?'
        r'<!-- ====================================================================== -->',
        re.DOTALL
    )

    # We maintain the indentation of the first comment if possible, but GA_SNIPPET is hardcoded so we'll just drop it in.
    content = ga_pattern.sub(GA_SNIPPET, content)

    # 2. Update SEO metadata if we have specific data for this file
    rel_path = os.path.relpath(filepath, start=os.getcwd())

    if rel_path in SEO_DATA:
        data = SEO_DATA[rel_path]
        title = data['title']
        desc = data['description']

        # Update <title>
        content = re.sub(r'<title>.*?</title>', f'<title>{title}</title>', content, flags=re.IGNORECASE)

        # Update meta description
        content = re.sub(r'<meta[^>]*name=["\']description["\'][^>]*content=["\'](.*?)["\'][^>]*>',
                         f'<meta name="description" content="{desc}" />', content, flags=re.IGNORECASE|re.DOTALL)

        # Update og:title
        content = re.sub(r'<meta[^>]*property=["\']og:title["\'][^>]*content=["\'](.*?)["\'][^>]*>',
                         f'<meta property="og:title" content="{title}" />', content, flags=re.IGNORECASE|re.DOTALL)

        # Update og:description
        content = re.sub(r'<meta[^>]*property=["\']og:description["\'][^>]*content=["\'](.*?)["\'][^>]*>',
                         f'<meta property="og:description" content="{desc}" />', content, flags=re.IGNORECASE|re.DOTALL)

        # Update twitter:title
        content = re.sub(r'<meta[^>]*name=["\']twitter:title["\'][^>]*content=["\'](.*?)["\'][^>]*>',
                         f'<meta name="twitter:title" content="{title}" />', content, flags=re.IGNORECASE|re.DOTALL)

        # Update twitter:description
        content = re.sub(r'<meta[^>]*name=["\']twitter:description["\'][^>]*content=["\'](.*?)["\'][^>]*>',
                         f'<meta name="twitter:description" content="{desc}" />', content, flags=re.IGNORECASE|re.DOTALL)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

def main():
    for root, dirs, files in os.walk(os.getcwd()):
        if '.git' in root or '.github' in root:
            continue
        for file in files:
            if file.endswith('.html'):
                filepath = os.path.join(root, file)
                update_file(filepath)
                print(f"Updated {filepath}")

if __name__ == "__main__":
    main()
