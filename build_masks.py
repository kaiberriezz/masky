import base64
import json
import os
import re

script_dir = os.path.dirname(os.path.abspath(__file__))
repo_stencils_dir = os.path.join(script_dir, "stencils")

if os.path.isdir(repo_stencils_dir):
    stencils_dir = repo_stencils_dir
    output_js = os.path.join(script_dir, "masky-masks.js")
else:
    stencils_dir = os.path.expandvars(r"%APPDATA%\spicetify\Extensions\masky-stencils")
    output_js = os.path.expandvars(r"%APPDATA%\spicetify\Extensions\masky-masks.js")

os.makedirs(stencils_dir, exist_ok=True)
output_parent = os.path.dirname(output_js)
if output_parent:
    os.makedirs(output_parent, exist_ok=True)


def js_string(value):
    return json.dumps(value, ensure_ascii=False)


files = sorted(os.path.join(stencils_dir, f) for f in os.listdir(stencils_dir) if f.lower().endswith(".png"))
entries = []

for path in files:
    name = os.path.splitext(os.path.basename(path))[0]
    artist = "uncredited"
    source = "—"

    match = re.search(r"\(([^)]+)\)$", name)
    if match:
        credit = match.group(1)
        m2 = re.match(r"^(.+?)\s+(?:on\s+)?(tumblr|twitter|instagram|github)$", credit)
        if m2:
            artist = m2.group(1).strip()
            source = m2.group(2)
        elif re.match(r"^creds\s+(.+?)\s+on\s+tumblr$", credit):
            artist = re.match(r"^creds\s+(.+?)\s+on\s+tumblr$", credit).group(1).strip()
            source = "Tumblr"
        else:
            artist = credit
            source = "Tumblr"

    display_name = re.sub(r"\s*\([^)]+\)$", "", name)
    obj_id = re.sub(r"[^a-zA-Z0-9]+", "-", display_name).strip("-").lower()

    with open(path, "rb") as fp:
        b64 = base64.b64encode(fp.read()).decode("ascii")

    entry = (
        "{ id: " + js_string(obj_id)
        + ", name: " + js_string(display_name)
        + ", url: " + js_string(f"data:image/png;base64,{b64}")
        + ", artist: " + js_string(artist)
        + ", source: " + js_string(source)
        + " }"
    )
    entries.append(entry)

js = "window.MASKY_MASKS = [\n" + ",\n".join(entries) + "\n];\n" if entries else "window.MASKY_MASKS = [];\n"

with open(output_js, "w", encoding="utf-8") as fp:
    fp.write(js)

print(f"Built {output_js} with {len(files)} mask(s)")

