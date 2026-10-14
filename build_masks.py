import base64, re, os, glob

stencils_dir = os.path.expandvars(r"%APPDATA%\spicetify\Extensions\masky-stencils")
output_js = os.path.expandvars(r"%APPDATA%\spicetify\Extensions\masky-masks.js")

files = sorted(glob.glob(os.path.join(stencils_dir, "*.png")))
entries = []

for f in files:
    name = os.path.splitext(os.path.basename(f))[0]
    artist = "uncredited"
    source = "—"
    m = re.search(r'\(([^)]+)\)$', name)
    if m:
        credit = m.group(1)
        m2 = re.match(r'^(.+?)\s+(?:on\s+)?(tumblr|twitter|instagram|github)$', credit)
        if m2:
            artist = m2.group(1).strip()
            source = m2.group(2)
        elif re.match(r'^creds\s+(.+?)\s+on\s+tumblr$', credit):
            artist = re.match(r'^creds\s+(.+?)\s+on\s+tumblr$', credit).group(1).strip()
            source = "Tumblr"
        else:
            artist = credit
            source = "Tumblr"
    display_name = re.sub(r'\s*\([^)]+\)$', '', name)
    id_ = re.sub(r'[^a-zA-Z0-9]+', '-', display_name).strip('-').lower()
    with open(f, "rb") as fp:
        b64 = base64.b64encode(fp.read()).decode("ascii")
    entry = f'  {{ id: "{id_}", name: "{display_name}", url: "data:image/png;base64,{b64}", artist: "{artist}", source: "{source}" }}'
    entries.append(entry)

js = "window.MASKY_MASKS = [\n" + ",\n".join(entries) + "\n];\n"
with open(output_js, "w", encoding="utf-8") as fp:
    fp.write(js)
print(f"Built {output_js} with {len(files)} mask(s) - {len(js)} bytes")