import urllib.request
import re

url = "https://jaysevak.github.io/ccaf-practice-exam/"
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
html = urllib.request.urlopen(req).read().decode('utf-8')

# find script src
scripts = re.findall(r'<script[^>]+src="([^"]+)"', html)
print("Scripts found:", scripts)

for s in scripts:
    s_url = s if s.startswith('http') else url + s.lstrip('./')
    print("Fetching", s_url)
    try:
        js = urllib.request.urlopen(urllib.request.Request(s_url, headers={'User-Agent': 'Mozilla/5.0'})).read().decode('utf-8')
        if 'questions' in js.lower() or 'question' in js.lower():
            print(f"Found questions in {s_url}, saving to js_content.txt")
            with open('js_content.txt', 'a', encoding='utf-8') as f:
                f.write(f"\n--- {s_url} ---\n")
                f.write(js[:5000]) # save first 5000 chars for inspection
    except Exception as e:
        print("Error fetching", s_url, e)
