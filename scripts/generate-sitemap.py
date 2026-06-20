#!/usr/bin/env python3
import os
import subprocess
import xml.etree.ElementTree as ET
from datetime import datetime

# Dynamically resolve root directory relative to this script
ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
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

def get_lastmod(filepath):
    try:
        # Get the date of the last commit that modified the file
        result = subprocess.run(['git', 'log', '-1', '--format=%cd', '--date=short', filepath], 
                                capture_output=True, text=True, check=True, cwd=ROOT_DIR)
        date_str = result.stdout.strip()
        if date_str:
            return date_str
    except Exception:
        pass
    # Fallback to file modification time
    return datetime.fromtimestamp(os.path.getmtime(filepath)).strftime("%Y-%m-%d")

def generate_sitemap():
    urlset = ET.Element("urlset", xmlns="http://www.sitemaps.org/schemas/sitemap/0.9")

    html_files = []
    for root, dirs, files in os.walk(ROOT_DIR):
        if any(ignored in root for ignored in ['.git', '.github', 'assets', 'scripts']):
            continue
        for file in files:
            if file.endswith(".html"):
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, ROOT_DIR)
                html_files.append((rel_path, full_path))

    # Sort files to ensure stable ordering
    html_files.sort(key=lambda x: x[0])

    for rel_path, full_path in html_files:
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
        lastmod.text = get_lastmod(full_path)

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
