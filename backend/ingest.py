import requests
import os

# Configuration settings
TARGET_API_URL = "http://127.0.0.1:8000/memory/add"
# ⚠️ Swap this out with your true active Sarah or Alex user_id string from Swagger
EXECUTIVE_ID = "PASTE_YOUR_ACTIVE_USER_ID_HERE" 

def ingest_document_file(file_path: str):
    if not os.path.exists(file_path):
        print(f"❌ Error: Target file not found at path: {file_path}")
        return

    print(f"📖 Reading historical target asset lines: {file_path}...")
    with open(file_path, "r", encoding="utf-8") as f:
        raw_text = f.read()

    # Split document cleanly into individual paragraphs
    paragraphs = [p.strip() for p in raw_text.split("\n\n") if p.strip()]
    print(f"🧩 Detected {len(paragraphs)} discrete knowledge chunks for processing.")

    for idx, chunk in enumerate(paragraphs, 1):
        payload = {
            "executive_id": EXECUTIVE_ID,
            "title": f"Ingested Block Component #{idx}",
            "content": chunk,
            "category": "Corporate Knowledge Assets"
        }
        
        try:
            response = requests.post(TARGET_API_URL, json=payload)
            if response.status_code == 200:
                print(f" ✅ Successfully ingested chunk {idx}/{len(paragraphs)}")
            else:
                print(f" ❌ Failed ingestion sequence at block {idx}: {response.text}")
        except Exception as e:
            print(f" ❌ Connection dropped during transaction: {e}")
            break

if __name__ == "__main__":
    # Example usage: Create a sample text file to verify execution loop tracking
    sample_file = "company_playbook.txt"
    if not os.path.exists(sample_file):
        with open(sample_file, "w") as f:
            f.write("Our operational scaling methodology emphasizes remote-first hiring parameters across development loops.\n\n")
            f.write("Financial parameters dictate maintaining 6 months of absolute project cash buffers before authorizing external infrastructure expansions.")
            
    ingest_document_file(sample_file)