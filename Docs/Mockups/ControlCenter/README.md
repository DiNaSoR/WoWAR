### WoWLang ControlCenter – HTML mockup (1:1)

This folder provides a **static HTML mock** of the in-game **ControlCenter** options panel using the **same textures** (bundled into `./assets/` for stable paths).

It’s meant for **design iteration outside WoW** (layout/colors/asset look), not as a replacement UI.

### How to open

- **Open** `Docs/Mockups/ControlCenter/index.html` in a browser (Edge/Chrome/Firefox).

If your browser blocks loading local fonts/images when opened from `file://` (rare), run a tiny local server instead.
Use `-c-1` to disable caching while iterating:

```bash
npx --yes http-server Docs/Mockups/ControlCenter -p 5173 -c-1
```

Then open the printed URL.

### Assets used (bundled)

- **Expansion border**: `assets/ExpansionBorder_TWW.png` (converted from `WoWAR/Images/ExpansionLandingPage/ExpansionBorder_TWW.tga`)
- **ControlCenter sprite atlas**: `assets/SettingsPanel.png` (copied from `WoWAR/Images/ControlCenter/SettingsPanel.png`)
- **ControlCenter background**: `assets/SettingsPanelBackground.jpg`
- **ControlCenter widget atlas** (scrollbar): `assets/SettingsPanelWidget.png`
- **Preview mask**: `assets/PreviewMask.png` (converted from `WoWAR/Images/ControlCenter/PreviewMask.tga`)
- **Arabic font**: `assets/font2.ttf`

### Notes

- The JS (`app.js`) slices the WoW atlas textures into per-piece images via `<canvas>` so we can stretch them like WoW’s NineSlice/ThreeSlice.
- Text content is sample/placeholder (you can edit `index.html` freely).


