#!/usr/bin/env python3
import os
import xml.etree.ElementTree as ET
from datetime import datetime

ROOT_DIR = "/Users/gunnarhostetler/Documents/GitHub/Gunzino"
BASE_URL = "https://gunzino.me"

def get_priority(rel_path):
    if rel_path == "index.html":
        return "1.0"
    elif rel_path.endswith("/index.html"):
        return "0.8"
    elif "support" in rel_path or "privacy" in rel_path or "terms" in rel_path:
        return "0.5"
    else:
        return "0.6"

def generate_sitemap():
    urlset = ET.Element("urlset", xmlns="http://www.sitemaps.org/schemas/sitemap/0.9")
    today = datetime.now().strftime("%Y-%m-%d")

    html_files = []
    for root, dirs, files in os.walk(ROOT_DIR):
        if any(ignored in root for ignored in ['.git', '.github', 'assets', 'scripts']):
            continue
        for file in files:
            if file.endswith(".html"):
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, ROOT_DIR)
                html_files.append(rel_path)

    # Sort files to ensure stable ordering
    html_files.sort()

    for rel_path in html_files:
        # Convert index.html to directory root
        url_path = rel_path
        if url_path == "index.html":
            url_path = ""
        elif url_path.endswith("/index.html"):
            url_path = url_path.replace("index.html", "")

        url_str = f"{BASE_URL}/{url_path}"

        url = ET.SubElement(urlset, "url")
        loc = ET.SubElement(url, "loc")
        loc.text = url_str

        lastmod = ET.SubElement(url, "lastmod")
        lastmod.text = today

        priority = ET.SubElement(url, "priority")
        priority.text = get_priority(rel_path)

    # Convert to string and write
    ET.indent(urlset, space="  ", level=0)
    xml_str = '<?xml version="1.0" encoding="UTF-8"?>\n' + ET.tostring(urlset, encoding="unicode")

    with open(os.path.join(ROOT_DIR, "sitemap.xml"), "w", encoding="utf-8") as f:
        f.write(xml_str)
        f.write("\n")

    print(f"Generated sitemap.xml with {len(html_files)} URLs.")

if __name__ == "__main__":
    generate_sitemap()
