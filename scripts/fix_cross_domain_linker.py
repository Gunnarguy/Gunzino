import os

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

TARGET_CONTENT = """        linker: {
          'domains': ['gunnarguy.me', 'gunzino.me', 'fascinaiting.me']
        }"""

REPLACEMENT_CONTENT = """        linker: {
          'domains': ['gunnarguy.me', 'gunzino.me', 'fascinaiting.me'],
          'accept_incoming': true
        }"""

def fix_files():
    count = 0
    for root, dirs, files in os.walk(ROOT_DIR):
        # Skip node_modules or .git
        if ".git" in root:
            continue
        for file in files:
            if file.endswith(".html"):
                file_path = os.path.join(root, file)
                with open(file_path, "r", encoding="utf-8") as f:
                    content = f.read()
                
                if TARGET_CONTENT in content:
                    new_content = content.replace(TARGET_CONTENT, REPLACEMENT_CONTENT)
                    with open(file_path, "w", encoding="utf-8") as f:
                        f.write(new_content)
                    print(f"Fixed cross-domain linker in: {os.path.relpath(file_path, ROOT_DIR)}")
                    count += 1
                    
    print(f"\nCompleted! Updated {count} HTML files in Gunzino.")

if __name__ == "__main__":
    fix_files()
