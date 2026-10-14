# Masky Stencils

Custom cover-art masks for Spotify via [Spicetify](https://spicetify.app/) + [Masky extension](https://github.com/kaiberriezz/masky).

Drop PNG stencils in the folder, run the watcher, apply — your album art gets masked instantly.

---

## Preview

![Masky preview — player bar with star mask applied](screenshots/preview.png)

*The player bar (bottom) and right now-playing panel both masked with the selected stencil.*

---

## Installation

### 1. Install Masky Extension

Copy `masky.js` and `watch-masky.ps1` to your Spicetify Extensions folder:

```powershell
# Extensions folder (auto-copied on apply)
%APPDATA%\spicetify\Extensions\
```

Add to your `config-xpui.ini` (or run once via CLI):

```ini
extensions = masky-masks.js|masky.js|song-downloader.js|spicy-lyrics.mjs
```

Then apply:

```powershell
spicetify apply
```

> **Restart Spotify** after first install.

---

### 2. Add Stencils

Drop your `.png` stencil files into:

```
%APPDATA%\spicetify\Extensions\masky-stencils\
```

Filenames can include credits in parentheses, e.g.:
- `star (artistname).png`
- `heart (credits nyotsoba on tumblr).png`

---

### 3. Build Manifest

Run the watcher once (or leave it running for auto-rebuild on new files):

```powershell
powershell -File "%APPDATA%\spicetify\Extensions\watch-masky.ps1"
```

You should see:
```
[HH:MM:SS] Built masky-masks.js with 29 mask(s)
Watching ... for PNG changes...
```

Press `Ctrl+C` after the build line if you don't want the watcher running.

---

### 4. Apply

```powershell
spicetify apply
```

---

## Usage

### Open Settings

![Settings location — click your profile → Settings](screenshots/settings-entry.png)

> **Go to your profile (top-right) → Settings**

### Find Masky Section

![Masky section in settings — under "Extensions" category](screenshots/settings-masky.png)

> **In Settings, scroll to the "Extensions" category → Masky**

### Pick a Mask

- **Cover art mask** — choose from 29 stencils, `circle`, or `none`
- **Apply mask to** — `both` (player + panel), `player`, `panel`, or `all`

Changes apply instantly — no restart needed after the first run.

---

## Stencils Included (29)

| Preview | Name | Artist |
|---------|------|--------|
| <img src="stencils/B.E.N%20(thespiritbaresitskills).png" width="40"> | B.E.N | thespiritbaresitskills |
| <img src="stencils/blood%20splatter%20(mydarlingedits).png" width="40"> | blood splatter | mydarlingedits |
| <img src="stencils/bunny%20ascii%20w%20bow%20(artificial5u1c1d3).png" width="40"> | bunny ascii w bow | artificial5u1c1d3 |
| <img src="stencils/cat1%20(src-rat).png" width="40"> | cat1 | src-rat |
| <img src="stencils/cat2%20(dollsciples).png" width="40"> | cat2 | dollsciples |
| <img src="stencils/cupcake%20(dropletknightss).png" width="40"> | cupcake | dropletknightss |
| <img src="stencils/cutegore%20ahh%20(artificial5u1c1d3).png" width="40"> | cutegore ahh | artificial5u1c1d3 |
| <img src="stencils/dog1%20(dollsciples).png" width="40"> | dog1 | dollsciples |
| <img src="stencils/furridot%20(toybox-starsys).png" width="40"> | furridot | toybox-starsys |
| <img src="stencils/gambler1%20(cynthiadrops).png" width="40"> | gambler1 | cynthiadrops |
| <img src="stencils/heart.png" width="40"> | heart | uncredited |
| <img src="stencils/hello%20kitty%201%20(nyotsoba).png" width="40"> | hello kitty 1 | nyotsoba |
| <img src="stencils/hello%20kitty%202%20(nyotsoba).png" width="40"> | hello kitty 2 | nyotsoba |
| <img src="stencils/hello%20kitty%203%20(nyotsoba).png" width="40"> | hello kitty 3 | nyotsoba |
| <img src="stencils/holy%20vaporwave%20weirdcore%20(artificial5u1c1d3)1.png" width="40"> | holy vaporwave weirdcore 1 | artificial5u1c1d3 |
| <img src="stencils/holy%20vaporwave%20weirdcore%20(artificial5u1c1d3)2.png" width="40"> | holy vaporwave weirdcore 2 | artificial5u1c1d3 |
| <img src="stencils/jeff%20(thespiritbaresitskills).png" width="40"> | jeff | thespiritbaresitskills |
| <img src="stencils/laughing%20jack%20(thespiritbaresitskills).png" width="40"> | laughing jack | thespiritbaresitskills |
| <img src="stencils/melty%20luv%20(tuxbit).png" width="40"> | melty luv | tuxbit |
| <img src="stencils/pompom%20(cynthiadrops).png" width="40"> | pompom | cynthiadrops |
| <img src="stencils/Proxy%20(thespiritbaresitskills).png" width="40"> | Proxy | thespiritbaresitskills |
| <img src="stencils/scalloped%20circle%20w%20wings%201%20(creds%20nyotsoba%20on%20tumblr).png" width="40"> | scalloped circle w wings 1 | nyotsoba |
| <img src="stencils/scalloped%20circle%20w%20wings%202%20(creds%20nyotsoba%20on%20tumblr).png" width="40"> | scalloped circle w wings 2 | nyotsoba |
| <img src="stencils/scalloped%20circle%20w%20wings%203%20(creds%20nyotsoba%20on%20tumblr).png" width="40"> | scalloped circle w wings 3 | nyotsoba |
| <img src="stencils/space%20(src-rat).png" width="40"> | space | src-rat |
| <img src="stencils/space%20ufo%20(dropletknightss).png" width="40"> | space ufo | dropletknightss |
| <img src="stencils/square%20pawprints%20(artificial5u1c1d3).png" width="40"> | square pawprints | artificial5u1c1d3 |
| <img src="stencils/ticci%20toby%20(thespiritbaresitskills).png" width="40"> | ticci toby | thespiritbaresitskills |
| <img src="stencils/very%20(straw)berry%20(src-rat).png" width="40"> | very (straw)berry | src-rat |

---

## Adding Your Own Stencils

1. Create a **250×250 px PNG** with transparency (alpha channel = mask)
2. Name it: `your-name (artistname).png`
3. Drop in `%APPDATA%\spicetify\Extensions\masky-stencils\`
4. Rebuild:

```powershell
powershell -File "%APPDATA%\spicetify\Extensions\watch-masky.ps1"
spicetify apply
```

The watcher auto-detects new/removed files if left running.

---

## File Structure

```
masky-stencils/
├── stencils/                 # 29 PNG stencils (credits in filenames)
├── manifest.json             # Metadata (id, name, artist, source)
├── watch-masky.ps1           # Auto-build watcher (FileSystemWatcher)
├── build_masks.py            # Alternative Python builder
├── index.js                  # Custom App entry point (for Spicetify)
├── screenshots/
│   ├── preview.png           # Player bar + panel masked
│   ├── settings-entry.png    # Profile → Settings
│   └── settings-masky.png    # Extensions → Masky section
└── README.md
```

---

## Credits

All stencils credited in filenames and `manifest.json`. Major contributors:

| Artist | Stencils | Tumblr |
|--------|----------|--------|
| artificial5u1c1d3 | 5 | [artificial5u1c1d3.tumblr.com](https://artificial5u1c1d3.tumblr.com) |
| thespiritbaresitskills | 6 | [thespiritbaresitskills.tumblr.com](https://thespiritbaresitskills.tumblr.com) |
| nyotsoba | 6 | [nyotsoba.tumblr.com](https://nyotsoba.tumblr.com) |
| src-rat | 4 | [src-rat.tumblr.com](https://src-rat.tumblr.com) |
| dollsciples | 2 | [dollsciples.tumblr.com](https://dollsciples.tumblr.com) |
| cynthiadrops | 2 | [cynthiadrops.tumblr.com](https://cynthiadrops.tumblr.com) |
| dropletknightss | 2 | [dropletknightss.tumblr.com](https://dropletknightss.tumblr.com) |
| mydarlingedits | 1 | [mydarlingedits.tumblr.com](https://mydarlingedits.tumblr.com) |
| toybox-starsys | 1 | [toybox-starsys.tumblr.com](https://toybox-starsys.tumblr.com) |
| tuxbit | 1 | [tuxbit.tumblr.com](https://tuxbit.tumblr.com) |

> If you're an artist and want your work removed or credited differently, open an issue.

---

## License

Personal use only. Stencils belong to their respective artists.
