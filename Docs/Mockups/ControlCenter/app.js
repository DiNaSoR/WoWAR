// Docs/Mockups/ControlCenter/app.js
// Interactive 1:1-ish ControlCenter HTML mock.
//
// Goals:
// - Slice the same WoW textures into CSS variables (already done previously).
// - Render Modules + Release Notes from real WoWLang data shapes (mirrors Registry.lua + Changelog conversion).
// - Wire interactions: search, category click -> scroll, toggle checkboxes, preview updates, version selection.
//
// Note: This is a design mock (no persistence). Toggling updates in-memory state only.

function $(sel) {
  const el = document.querySelector(sel);
  if (!el) throw new Error(`Missing element: ${sel}`);
  return el;
}

function setCssVar(name, dataUrl) {
  document.documentElement.style.setProperty(name, `url("${dataUrl}")`);
}

function waitForImage(img) {
  return new Promise((resolve, reject) => {
    if (img.complete && img.naturalWidth > 0) return resolve(img);
    img.addEventListener("load", () => resolve(img), { once: true });
    img.addEventListener("error", () => reject(new Error(`Failed to load ${img.src}`)), { once: true });
  });
}

function sliceToDataURL(img, x, y, w, h, scale = 0.5) {
  const outW = Math.max(1, Math.round(w * scale));
  const outH = Math.max(1, Math.round(h * scale));
  const canvas = document.createElement("canvas");
  canvas.width = outW;
  canvas.height = outH;
  const ctx = canvas.getContext("2d", { alpha: true });
  ctx.imageSmoothingEnabled = true;
  ctx.imageSmoothingQuality = "high";
  ctx.drawImage(img, x, y, w, h, 0, 0, outW, outH);
  return canvas.toDataURL("image/png");
}

async function buildSlices() {
  const exp = $("#sprite-expansion-border");
  const cc = $("#sprite-controlcenter");
  const widget = $("#sprite-widget");
  const drop = $("#sprite-dropdownmenu");
  await Promise.all([waitForImage(exp), waitForImage(cc), waitForImage(widget), waitForImage(drop)]);

  // ExpansionThemeFrame NineSlice (Util.lua / CreateExpansionThemeFrame)
  setCssVar("--exp-tl", sliceToDataURL(exp, 0, 0, 128, 128));
  setCssVar("--exp-t", sliceToDataURL(exp, 128, 0, 256, 128));
  setCssVar("--exp-tr", sliceToDataURL(exp, 518, 48, 128, 128));
  setCssVar("--exp-l", sliceToDataURL(exp, 0, 128, 128, 256));
  setCssVar("--exp-c", sliceToDataURL(exp, 128, 128, 256, 256));
  setCssVar("--exp-r", sliceToDataURL(exp, 384, 128, 128, 256));
  setCssVar("--exp-bl", sliceToDataURL(exp, 0, 384, 128, 128));
  setCssVar("--exp-b", sliceToDataURL(exp, 128, 384, 256, 128));
  setCssVar("--exp-br", sliceToDataURL(exp, 384, 384, 128, 128));
  setCssVar("--exp-close", sliceToDataURL(exp, 646, 48, 48, 48));

  // SettingsPanel sprite (1024 atlas)
  setCssVar("--tab-n-left", sliceToDataURL(cc, 392, 176, 48, 96));
  setCssVar("--tab-n-center", sliceToDataURL(cc, 440, 176, 112, 96));
  setCssVar("--tab-n-right", sliceToDataURL(cc, 552, 176, 48, 96));
  setCssVar("--tab-s-left", sliceToDataURL(cc, 600, 176, 48, 96));
  setCssVar("--tab-s-center", sliceToDataURL(cc, 648, 176, 112, 96));
  setCssVar("--tab-s-right", sliceToDataURL(cc, 760, 176, 48, 96));

  // Search box
  setCssVar("--search-l", sliceToDataURL(cc, 0, 0, 32, 80));
  setCssVar("--search-c", sliceToDataURL(cc, 32, 0, 128, 80));
  setCssVar("--search-r", sliceToDataURL(cc, 160, 0, 32, 80));
  setCssVar("--icon-search", sliceToDataURL(cc, 984, 0, 40, 40));
  setCssVar("--icon-reset", sliceToDataURL(cc, 864, 0, 40, 40));
  // Reset/clear icon uses the same region as SearchBox reset (864..904,0..40) but we'll keep it simple for now.

  // Square button bg + icons
  setCssVar("--square-bg", sliceToDataURL(cc, 192, 0, 80, 80));
  setCssVar("--icon-filter", sliceToDataURL(cc, 272, 16, 48, 48));
  setCssVar("--icon-menu", sliceToDataURL(cc, 864, 176, 48, 48));

  // Divider and selection highlight
  setCssVar("--divider", sliceToDataURL(cc, 416, 16, 256, 48));
  setCssVar("--sel-l", sliceToDataURL(cc, 0, 80, 32, 80));
  setCssVar("--sel-c", sliceToDataURL(cc, 32, 80, 128, 80));
  setCssVar("--sel-r", sliceToDataURL(cc, 160, 80, 32, 80));

  // Header decoration
  setCssVar("--header-l", sliceToDataURL(cc, 416, 80, 40, 40));
  setCssVar("--header-r", sliceToDataURL(cc, 456, 80, 280, 40));

  // Checkbox states + option toggle icon
  setCssVar("--cb-off", sliceToDataURL(cc, 688, 16, 48, 48));
  setCssVar("--cb-on", sliceToDataURL(cc, 736, 16, 48, 48));
  setCssVar("--opt-normal", sliceToDataURL(cc, 864, 40, 40, 40));

  // Changelog bullet + horizontal line
  setCssVar("--bullet", sliceToDataURL(cc, 904, 80, 40, 40));
  setCssVar("--hline", sliceToDataURL(cc, 424, 132, 440, 16));

  // SideTab 6-piece background
  setCssVar("--side-l1", sliceToDataURL(cc, 0, 176, 280, 64));
  setCssVar("--side-l2", sliceToDataURL(cc, 0, 240, 280, 592));
  setCssVar("--side-l3", sliceToDataURL(cc, 0, 832, 280, 64));
  setCssVar("--side-r1", sliceToDataURL(cc, 280, 176, 80, 64));
  setCssVar("--side-r2", sliceToDataURL(cc, 280, 240, 80, 592));
  setCssVar("--side-r3", sliceToDataURL(cc, 280, 832, 80, 64));

  // Scrollbar widget (512 atlas)
  const s = 0.5;
  setCssVar("--sb-rail-top", sliceToDataURL(widget, 0, 0, 32, 32, s));
  setCssVar("--sb-rail-mid", sliceToDataURL(widget, 0, 32, 32, 64, s));
  setCssVar("--sb-rail-bot", sliceToDataURL(widget, 0, 96, 32, 32, s));
  setCssVar("--sb-thumb-top", sliceToDataURL(widget, 0, 132, 32, 32, s));
  setCssVar("--sb-thumb-mid", sliceToDataURL(widget, 0, 164, 32, 64, s));
  setCssVar("--sb-thumb-bot", sliceToDataURL(widget, 0, 228, 32, 32, s));
  setCssVar("--sb-up", sliceToDataURL(widget, 0, 396, 32, 32, s));
  setCssVar("--sb-down", sliceToDataURL(widget, 0, 428, 32, 32, s));

  // Dropdown menu frame (ExpansionBorder_TWW region used by Plumber menu)
  // Plumber (Basic.lua): pieces texcoords 512..768 and 320..576 in a 1024 atlas, rendered at 16px corners.
  setCssVar("--menu-tl", sliceToDataURL(exp, 512, 320, 32, 32, 0.5));
  setCssVar("--menu-t", sliceToDataURL(exp, 544, 320, 192, 32, 0.5));
  setCssVar("--menu-tr", sliceToDataURL(exp, 736, 320, 32, 32, 0.5));
  setCssVar("--menu-l", sliceToDataURL(exp, 512, 352, 32, 192, 0.5));
  setCssVar("--menu-c", sliceToDataURL(exp, 544, 352, 192, 192, 0.5));
  setCssVar("--menu-r", sliceToDataURL(exp, 736, 352, 32, 192, 0.5));
  setCssVar("--menu-bl", sliceToDataURL(exp, 512, 544, 32, 32, 0.5));
  setCssVar("--menu-b", sliceToDataURL(exp, 544, 544, 192, 32, 0.5));
  setCssVar("--menu-br", sliceToDataURL(exp, 736, 544, 32, 32, 0.5));

  // Dropdown menu icons / highlight (DropdownMenu.png, 512 atlas)
  setCssVar("--menu-radio-off", sliceToDataURL(drop, 0, 0, 32, 32, 0.5));
  setCssVar("--menu-radio-on", sliceToDataURL(drop, 32, 0, 32, 32, 0.5));
  setCssVar("--menu-highlight", sliceToDataURL(drop, 368, 0, 144, 48, 0.5));
}

async function loadJSON(url) {
  const res = await fetch(url, { cache: "no-store" });
  if (!res.ok) throw new Error(`Failed to load ${url}: ${res.status}`);
  return await res.json();
}

// ---------------------------------------------------------------------------
// Data model (mirrors Registry.lua)
// ---------------------------------------------------------------------------

function makeBoolModule(dbKey, name, description, categoryKey, path, parentDBKey) {
  return {
    dbKey,
    name,
    description,
    categoryKey,
    path,
    parentDBKey,
    optionToggle: false,
    virtual: false,
  };
}

function buildDefaultModules(i18n) {
  const L = (k, fallback) => (typeof i18n[k] === "string" ? i18n[k] : fallback);

  // Categories follow ControlCenter.PrimaryCategory order (Registry.lua)
  const categories = [
    { key: "General", name: L("ControlCenter_Category_General", "General") },
    { key: "Tooltips", name: L("ControlCenter_Category_Tooltips", "Tooltips") },
    { key: "Bubbles", name: L("ControlCenter_Category_Bubbles", "Bubbles") },
    { key: "Movies", name: L("ControlCenter_Category_Movies", "Movies") },
    { key: "Books", name: L("ControlCenter_Category_Books", "Books") },
    { key: "Chat", name: L("ControlCenter_Category_Chat", "Chat") },
    { key: "About", name: L("ControlCenter_Category_About", "About") },
  ];

  // A minimal subset of modules, keyed to real dbKeys and labels from WoW_Localization_AR.lua.
  // (You can expand this later; the renderer supports arbitrary lists.)
  const modules = [];

  // General: Quests (with sub options) + Minimap
  const questsRoot = {
    dbKey: "WOWTR_Quests",
    name: L("activateQuestsTranslations", "Enable translations"),
    description: L("generalMainHeaderQS", "Quest translations and related features."),
    categoryKey: "General",
    path: "quests.active",
    subOptions: [
      makeBoolModule("WOWTR_Quests_Transtitle", L("translateQuestTitles", "Translate quest titles"), null, "General", "quests.transtitle", "WOWTR_Quests"),
      makeBoolModule("WOWTR_Quests_Gossip", L("translateGossipTexts", "Translate gossip"), null, "General", "quests.gossip", "WOWTR_Quests"),
      makeBoolModule("WOWTR_Quests_Tracker", L("translateTrackObjectives", "Translate tracker"), null, "General", "quests.tracker", "WOWTR_Quests"),
      makeBoolModule("WOWTR_Quests_OwnNames", L("translateOwnNames", "Translate own names"), null, "General", "quests.ownnames", "WOWTR_Quests"),
      makeBoolModule("WOWTR_Quests_ENFirst", L("displayENfirst", "Show English first"), null, "General", "quests.en_first", "WOWTR_Quests"),
      makeBoolModule("WOWTR_Quests_SaveQS", L("saveUntranslatedQuests", "Save untranslated quests"), null, "General", "quests.saveQS", "WOWTR_Quests"),
      makeBoolModule("WOWTR_Quests_SaveGS", L("saveUntranslatedGossip", "Save untranslated gossip"), null, "General", "quests.saveGS", "WOWTR_Quests"),
      makeBoolModule("WOWTR_Quests_Immersion", "Immersion", null, "General", "quests.immersion", "WOWTR_Quests"),
      makeBoolModule("WOWTR_Quests_Storyline", "Storyline", null, "General", "quests.storyline", "WOWTR_Quests"),
      makeBoolModule("WOWTR_Quests_QuestLog", "ClassicQuestLog", null, "General", "quests.questlog", "WOWTR_Quests"),
      makeBoolModule("WOWTR_Quests_DialogueUI", "DialogueUI", null, "General", "quests.dialogueui", "WOWTR_Quests"),
    ],
  };
  modules.push(questsRoot);

  modules.push({
    dbKey: "WOWTR_Minimap_ShowIcon",
    name: L("showMinimapIcon", "Show minimap icon"),
    description: L("showMinimapIconDESC", null),
    categoryKey: "General",
    path: "minimap.hide", // special semantics (in-game this is inverted); we keep it simple in mock
    invert: true,
  });

  // Tooltips root (subset)
  const tooltipsRoot = {
    dbKey: "WOWTR_Tooltips",
    name: L("activateTooltipTranslations", "Enable tooltips/UI translations"),
    description: L("generalMainHeaderTT", "Tooltips and UI translation."),
    categoryKey: "Tooltips",
    path: "tooltips.active",
    subOptions: [
      makeBoolModule("WOWTR_Tooltips_Always", L("displayTranslationConstantly", "Always show"), null, "Tooltips", "tooltips.constantly", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_SaveUI", L("saveTranslationUI", "Save UI"), null, "Tooltips", "tooltips.saveui", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_UI1", L("ControlCenter_UI_GameMenu", "Game Menu"), null, "Tooltips", "tooltips.ui1", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_UI2", L("ControlCenter_UI_CharacterInfo", "Character Info"), null, "Tooltips", "tooltips.ui2", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_UI3", L("ControlCenter_UI_GroupFinder", "Group Finder"), null, "Tooltips", "tooltips.ui3", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_UI4", L("ControlCenter_UI_Collections", "Collections"), null, "Tooltips", "tooltips.ui4", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_UI5", L("ControlCenter_UI_AdventureGuide", "Adventure Guide"), null, "Tooltips", "tooltips.ui5", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_UI6", L("ControlCenter_UI_Friends", "Friends"), null, "Tooltips", "tooltips.ui6", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_UI7", L("ControlCenter_UI_Professions", "Professions"), null, "Tooltips", "tooltips.ui7", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_UI8", L("ControlCenter_UI_MiscUI", "Misc UI"), null, "Tooltips", "tooltips.ui8", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_UITalents", L("ControlCenter_UI_TalentsUI", "Talents UI"), null, "Tooltips", "tooltips.ui_talents", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_Item", L("translateItems", "Items"), null, "Tooltips", "tooltips.item", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_Spell", L("translateSpells", "Spells"), null, "Tooltips", "tooltips.spell", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_Talent", L("translateTalents", "Talents"), null, "Tooltips", "tooltips.talent", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_Title", L("translateTooltipTitle", "Translate titles"), null, "Tooltips", "tooltips.transtitle", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_SaveTutorials", L("saveUntranslatedTutorials", "Save untranslated tutorials"), null, "Tooltips", "tooltips.save", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_ShowID", L("ControlCenter_ShowID", "Show ID"), null, "Tooltips", "tooltips.showID", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_ShowHash", L("ControlCenter_ShowHash", "Show Hash"), null, "Tooltips", "tooltips.showHS", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_HideSellPrice", L("ControlCenter_HideSellPrice", "Hide sell price"), null, "Tooltips", "tooltips.sellprice", "WOWTR_Tooltips"),
      makeBoolModule("WOWTR_Tooltips_SaveNW", L("saveUntranslatedTooltips", "Save untranslated"), null, "Tooltips", "tooltips.saveNW", "WOWTR_Tooltips"),
    ],
  };
  modules.push(tooltipsRoot);

  // Bubbles (subset)
  modules.push({
    dbKey: "WOWTR_Bubbles",
    name: L("activateBubblesTranslations", "Enable bubbles"),
    description: L("generalMainHeaderBB", "Chat bubbles and bubble-related features."),
    categoryKey: "Bubbles",
    path: "bubbles.active",
    subOptions: [
      makeBoolModule("WOWTR_Bubbles_ChatTR", "Chat TR", null, "Bubbles", "bubbles.chat_tr", "WOWTR_Bubbles"),
      makeBoolModule("WOWTR_Bubbles_ChatEN", "Chat EN", null, "Bubbles", "bubbles.chat_en", "WOWTR_Bubbles"),
      makeBoolModule("WOWTR_Bubbles_SaveNB", L("saveUntranslatedBubbles", "Save untranslated bubbles"), null, "Bubbles", "bubbles.saveNB", "WOWTR_Bubbles"),
      makeBoolModule("WOWTR_Bubbles_SetSize", L("setBubbleFontSize", "Set font size"), null, "Bubbles", "bubbles.setsize", "WOWTR_Bubbles"),
      makeBoolModule("WOWTR_Bubbles_Dungeon", L("enableDungeonFont", "Dungeon font"), null, "Bubbles", "bubbles.dungeon", "WOWTR_Bubbles"),
    ],
  });

  // Movies (subtitle system in localization)
  modules.push({
    dbKey: "WOWTR_Movies",
    name: L("activateMoviesTranslations", "Enable movies/cinematics"),
    description: null,
    categoryKey: "Movies",
    path: "movies.active",
    subOptions: [
      makeBoolModule("WOWTR_Movies_Intro", L("translateIntroVideos", "Intro"), null, "Movies", "movies.intro", "WOWTR_Movies"),
      makeBoolModule("WOWTR_Movies_Movie", L("translateMovies", "Movies"), null, "Movies", "movies.movie", "WOWTR_Movies"),
      makeBoolModule("WOWTR_Movies_Cinematic", L("translateCinematics", "Cinematics"), null, "Movies", "movies.cinematic", "WOWTR_Movies"),
      makeBoolModule("WOWTR_Movies_Save", L("saveUntranslatedMovies", "Save untranslated"), null, "Movies", "movies.save", "WOWTR_Movies"),
    ],
  });

  // Books
  modules.push({
    dbKey: "WOWTR_Books",
    name: L("activateBooksTranslations", "Enable books"),
    description: null,
    categoryKey: "Books",
    path: "books.active",
    subOptions: [
      makeBoolModule("WOWTR_Books_Title", L("translateBookTitles", "Translate titles"), null, "Books", "books.title", "WOWTR_Books"),
      makeBoolModule("WOWTR_Books_ShowID", L("ControlCenter_ShowID", "Show ID"), null, "Books", "books.showID", "WOWTR_Books"),
      makeBoolModule("WOWTR_Books_SetSize", L("setBookFontSize", "Set font size"), null, "Books", "books.setsize", "WOWTR_Books"),
      makeBoolModule("WOWTR_Books_SaveNW", L("saveUntranslatedBooks", "Save untranslated"), null, "Books", "books.saveNW", "WOWTR_Books"),
    ],
  });

  // ChatAR
  modules.push({
    dbKey: "WOWTR_ChatAR",
    name: L("activateChatTranslations", "Enable chat (Arabic)"),
    description: null,
    categoryKey: "Chat",
    path: "chatAR.active",
    subOptions: [makeBoolModule("WOWTR_ChatAR_SetSize", L("setChatFontSize", "Set font size"), null, "Chat", "chatAR.setsize", "WOWTR_ChatAR")],
  });

  // About (virtual)
  modules.push({
    dbKey: "WOWTR_About",
    name: L("ControlCenter_About_Title", "About"),
    description: L("ControlCenter_About_Desc", "WoWLang / WoWAR settings and info."),
    categoryKey: "About",
    virtual: true,
    path: null,
  });

  return { categories, modules };
}

function buildDefaultProfileState(modules) {
  // Create a fake profile with booleans for each dbKey.
  const state = {};
  function initModule(m) {
    if (m.virtual) return;
    // Default: ON for roots, ON for most subopts, OFF for integration add-ons.
    let v = true;
    if (typeof m.name === "string" && /Immersion|Storyline|ClassicQuestLog|DialogueUI/i.test(m.name)) v = false;
    if (m.dbKey === "WOWTR_Minimap_ShowIcon") v = true;
    state[m.dbKey] = v;
    if (Array.isArray(m.subOptions)) m.subOptions.forEach(initModule);
  }
  modules.forEach(initModule);
  return state;
}

// ---------------------------------------------------------------------------
// Rendering
// ---------------------------------------------------------------------------

function clearChildren(el) {
  while (el.firstChild) el.removeChild(el.firstChild);
}

function el(tag, cls, text) {
  const n = document.createElement(tag);
  if (cls) n.className = cls;
  if (text !== undefined && text !== null) n.textContent = String(text);
  return n;
}

function normalize(s) {
  return String(s || "")
    .toLowerCase()
    .replace(/\s+/g, " ")
    .trim();
}

function buildSearchText(module) {
  const parts = [module.name, module.description].filter(Boolean).map(normalize);
  if (Array.isArray(module.subOptions)) {
    for (const s of module.subOptions) {
      parts.push(normalize(s.name));
      if (s.description) parts.push(normalize(s.description));
    }
  }
  return parts.join(" ");
}

function renderModulesList({ categories, modules }, state, i18n, opts) {
  const container = $("#cc-modules-content");
  clearChildren(container);

  const query = normalize(opts.searchText);

  const sortIndex = window.__ccState?.sortIndex || 1;
  const sortAlpha = (a, b) => {
    if (!!a.virtual !== !!b.virtual) return !a.virtual;
    return String(a.name || "").localeCompare(String(b.name || ""), "und");
  };
  const sortDate = (a, b) => {
    if (!!a.virtual !== !!b.virtual) return !a.virtual;
    const at = a.moduleAddedTime;
    const bt = b.moduleAddedTime;
    if (at != null && bt != null) return bt - at;
    if (at == null && bt == null) return String(a.name || "").localeCompare(String(b.name || ""), "und");
    return at != null;
  };
  const sortFn = sortIndex === 2 ? sortDate : sortAlpha;

  // Build per-category module grouping in primary order.
  const grouped = [];
  for (const cat of categories) {
    const list = [];
    for (const m of modules) {
      if (m.categoryKey !== cat.key) continue;
      if (query) {
        const t = m._searchText || (m._searchText = buildSearchText(m));
        if (!t.includes(query)) continue;
      }
      list.push(m);
    }
    if (list.length) grouped.push({ cat, list: list.slice().sort(sortFn) });
  }

  // Utility: create header row
  function addHeader(text) {
    const row = el("div", "cc-row cc-row--header");
    row.dataset.categoryHeader = String(text);
    row.appendChild(el("span", "cc-header__left"));
    row.appendChild(el("span", "cc-header__right"));
    row.appendChild(el("span", "cc-header__label", text));
    container.appendChild(row);
  }

  function addGap() {
    container.appendChild(el("div", "cc-row cc-row--gap"));
  }

  function addEntry(m, indentPx = 0) {
    const btn = el("button", "cc-row cc-row--entry");
    btn.type = "button";
    btn.dataset.highlight = "true";
    btn.dataset.dbkey = m.dbKey;
    if (indentPx) btn.style.paddingLeft = `${indentPx}px`;

    const box = el("span", "cc-entry__box");
    const isOn = m.virtual ? true : !!state[m.dbKey];
    box.classList.add(isOn ? "cc-entry__box--on" : "cc-entry__box--off");
    btn.appendChild(box);

    const label = el("span", "cc-entry__label", m.name);
    btn.appendChild(label);

    // Option toggle icon if this entry has subOptions in-game (we show for roots with subOptions)
    if (Array.isArray(m.subOptions) && m.subOptions.length) {
      btn.appendChild(el("span", "cc-entry__opt"));
    }

    btn.addEventListener("mouseenter", () => {
      setPreview(m, i18n);
    });

    btn.addEventListener("click", () => {
      if (m.virtual) {
        setPreview(m, i18n);
        return;
      }
      // Parent gating: if this is a sub option and parent is OFF, ignore (matches disabled behavior).
      if (m.parentDBKey && !state[m.parentDBKey]) return;

      state[m.dbKey] = !state[m.dbKey];
      renderModulesList({ categories, modules }, state, i18n, opts);
    });

    container.appendChild(btn);
  }

  // Render grouped list
  for (let i = 0; i < grouped.length; i++) {
    const { cat, list } = grouped[i];
    const header = el("div", "cc-row cc-row--header");
    header.dataset.categoryHeaderKey = cat.key;
    header.appendChild(el("span", "cc-header__left"));
    header.appendChild(el("span", "cc-header__right"));
    header.appendChild(el("span", "cc-header__label", cat.name));
    container.appendChild(header);

    for (const m of list) {
      addEntry(m, 0);
      if (Array.isArray(m.subOptions) && m.subOptions.length) {
        const parentOn = !!state[m.dbKey];
        for (const sub of m.subOptions) {
          // render even if search hits sub text: we only included parent so far; keep it simple for mock
          // but match visual indentation used by SettingsPanel.lua (0.5*ButtonSize = 14)
          // "disabled" is handled by click guard above; we also dim the label if disabled
          addEntry(sub, 14);
          const last = container.lastElementChild;
          if (!parentOn) last.style.opacity = "0.55";
        }
      }
    }
    if (i !== grouped.length - 1) addGap();
  }

  // Empty state (matches ScrollView.lua no content alert behavior)
  if (!grouped.length) {
    const no = el("div", "cc-noresults", i18n?.ControlCenter_NoSearchResults || "No results");
    container.appendChild(no);
  }
}

function setPreview(module, i18n) {
  const img = $("#cc-preview-img");
  const desc = $("#cc-preview-desc");

  const map = window.__ccState?.moduleByKey;
  const parent = module?.parentDBKey && map ? map[module.parentDBKey] : null;

  // Preview image naming matches SettingsPanel.lua: Preview_<dbKey>.jpg
  // We bundle Preview_WOWTR_*.jpg so use that when available; otherwise fall back to quests.
  const safeKey = String((parent && parent.dbKey) || module.dbKey || "WOWTR_Quests");
  const trySrc = `./assets/Preview_${safeKey}.jpg`;
  img.src = trySrc;
  img.onerror = () => {
    img.onerror = null;
    img.src = "./assets/Preview_WOWTR_Quests.jpg";
  };

  desc.textContent = module.description || parent?.description || "";
}

function versionToID(versionText) {
  const m = String(versionText || "").match(/^(\d+)\.(\d+)\.?(\d*)$/);
  if (!m) return null;
  const major = Number(m[1]);
  const minor = Number(m[2]);
  const patch = Number(m[3] || "0");
  if (!Number.isFinite(major) || !Number.isFinite(minor) || !Number.isFinite(patch)) return null;
  return Number(String(major) + String(minor).padStart(2, "0") + String(patch).padStart(2, "0"));
}

function formatDateDDMonYYYY(d) {
  // Matches Lua: date("%d %b %Y") => "31 Dec 2025"
  const day = String(d.getDate()).padStart(2, "0");
  const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  const mon = months[d.getMonth()] || "Jan";
  const year = String(d.getFullYear());
  return `${day} ${mon} ${year}`;
}

function buildChangelogFromEntries(entries) {
  const out = {};
  for (const e of entries || []) {
    const id = versionToID(e.version) ?? Number(e.version);
    if (!id) continue;

    const list = [];
    list.push({ type: "date", versionText: String(e.version || ""), timestamp: Date.now() / 1000 });

    if (e.title) list.push({ type: "h1", text: String(e.title) });
    else if (e.type) list.push({ type: "h1", text: String(e.type) });

    const desc = String(e.description || "");
    const lines = desc.split(/\r?\n/);
    for (const line of lines) {
      if (!line.trim()) {
        list.push({ type: "br" });
        continue;
      }
      const bullet = line.match(/^\s*[-*]\s+(.+)$/);
      if (bullet) list.push({ type: "p", bullet: true, text: bullet[1] });
      else list.push({ type: "p", text: line });
    }

    out[id] = list;
  }
  return out;
}

function renderVersionList(changelogs, i18n, selectedVersionID) {
  const L = (k, fallback) => (typeof i18n[k] === "string" ? i18n[k] : fallback);

  const listEl = $("#cc-version-list");
  clearChildren(listEl);

  const ids = Object.keys(changelogs)
    .map((k) => Number(k))
    .filter((n) => Number.isFinite(n))
    .sort((a, b) => b - a);

  for (const id of ids) {
    const dateNode = (changelogs[id] || []).find((n) => n.type === "date");
    const v = dateNode?.versionText || String(id);

    const btn = el("button", "cc-version", v);
    btn.type = "button";
    btn.dataset.highlight = "true";
    btn.setAttribute("role", "option");
    btn.setAttribute("aria-selected", id === selectedVersionID ? "true" : "false");
    btn.addEventListener("click", () => {
      window.__ccState.selectedVersionID = id;
      renderVersionList(changelogs, i18n, id);
      renderChangelog(changelogs, i18n, id);
      // Update title
      const title = document.querySelector(".cc-versiontitle");
      if (title) {
        title.innerHTML = `<span dir=\"rtl\">${L("ControlCenter_Version", "Version")}</span> <span dir=\"ltr\">${v}</span>`;
      }
    });
    listEl.appendChild(btn);
  }
}

function renderChangelog(changelogs, i18n, versionID) {
  const L = (k, fallback) => (typeof i18n[k] === "string" ? i18n[k] : fallback);

  const root = $("#cc-changelog-content");
  clearChildren(root);

  const list = changelogs[versionID];
  if (!list) return;

  for (const item of list) {
    if (item.type === "date") {
      const row = el("div", "cc-changelogcontent__meta");
      const dateStr = formatDateDDMonYYYY(new Date((item.timestamp || Date.now() / 1000) * 1000));
      row.innerHTML = `<span dir="rtl">${L("ControlCenter_Version", "Version")}</span> <span dir="ltr">${item.versionText}</span> &nbsp;&nbsp; <span dir="ltr">${dateStr}</span>`;
      root.appendChild(row);

      root.appendChild(el("div", "cc-changelogcontent__line"));
      continue;
    }

    if (item.type === "h1") {
      root.appendChild(el("div", "cc-changelogcontent__h1", item.text));
      continue;
    }

    if (item.type === "br") {
      root.appendChild(el("div", "cc-row", ""));
      continue;
    }

    if (item.type === "p" && item.bullet) {
      let ul = root.lastElementChild && root.lastElementChild.classList?.contains("cc-changelogcontent__ul") ? root.lastElementChild : null;
      if (!ul) {
        ul = el("ul", "cc-changelogcontent__ul");
        root.appendChild(ul);
      }
      ul.appendChild(el("li", null, item.text));
      continue;
    }

    if (item.type === "p") {
      root.appendChild(el("div", "cc-changelogcontent__p", item.text));
      continue;
    }
  }
}

// ---------------------------------------------------------------------------
// UI interactions
// ---------------------------------------------------------------------------

function bindTabs() {
  const root = $("#cc");
  const tabs = Array.from(document.querySelectorAll(".cc-tab"));
  for (const t of tabs) {
    t.addEventListener("click", () => {
      const tabKey = t.dataset.tab;
      root.dataset.tab = tabKey;
      for (const x of tabs) {
        const sel = x === t;
        x.classList.toggle("is-selected", sel);
        x.setAttribute("aria-selected", sel ? "true" : "false");
      }
      // Close any open dropdown when switching tabs (matches WoW behavior)
      window.__ccState?.dropdownMenu?.hide?.();
    });
  }
}

function bindSearch(opts) {
  const input = $("#cc-search");
  const clear = $("#cc-search-clear");
  function update() {
    opts.searchText = input.value || "";
    clear.style.display = opts.searchText ? "block" : "none";
    rerender();
  }
  input.addEventListener("input", update);
  clear.addEventListener("click", () => {
    input.value = "";
    update();
    input.focus();
  });
  update();
}

function bindCategories(opts) {
  document.querySelectorAll(".cc-cat").forEach((b) => {
    b.addEventListener("click", () => {
      const catKey = b.dataset.category;
      if (!catKey) return;
      const header = document.querySelector(`#cc-modules-content [data-category-header-key='${CSS.escape(catKey)}']`);
      const viewport = document.querySelector("[data-scroll-viewport='modules']");
      if (header && viewport) {
        viewport.scrollTo({ top: header.offsetTop, behavior: "auto" });
      }
    });
  });
}

function bindVersionMenu() {
  // Bound via bindDropdownMenus()
}

function applyChangelogFontSize(index) {
  const sizes = [12, 14];
  const size = sizes[index - 1] || sizes[0];
  document.documentElement.style.setProperty("--cc-changelog-font", `${size}px`);
}

function createDropdownMenu() {
  const menu = document.createElement("div");
  menu.className = "cc-menu";
  menu.innerHTML = `
    <div class="cc-menu__border" aria-hidden="true">
      <div class="cc-menu__piece tl"></div>
      <div class="cc-menu__piece t"></div>
      <div class="cc-menu__piece tr"></div>
      <div class="cc-menu__piece l"></div>
      <div class="cc-menu__piece c"></div>
      <div class="cc-menu__piece r"></div>
      <div class="cc-menu__piece bl"></div>
      <div class="cc-menu__piece b"></div>
      <div class="cc-menu__piece br"></div>
    </div>
    <div class="cc-menu__content" role="menu"></div>
  `;
  document.body.appendChild(menu);

  const content = menu.querySelector(".cc-menu__content");
  let owner = null;
  let menuInfoGetter = null;

  function hide() {
    menu.classList.remove("is-open");
    owner = null;
    menuInfoGetter = null;
  }

  function positionToOwner() {
    if (!owner) return;
    const r = owner.getBoundingClientRect();
    const mw = menu.getBoundingClientRect().width;
    const mh = menu.getBoundingClientRect().height;
    const pad = 6;

    let left = r.left;
    let top = r.bottom + 6;

    // clamp to viewport
    left = Math.max(pad, Math.min(left, window.innerWidth - mw - pad));
    top = Math.max(pad, Math.min(top, window.innerHeight - mh - pad));

    menu.style.left = `${Math.round(left)}px`;
    menu.style.top = `${Math.round(top)}px`;
  }

  function build(menuInfo) {
    clearChildren(content);
    const widgets = menuInfo?.widgets || [];
    for (const w of widgets) {
      const btn = document.createElement("button");
      btn.type = "button";
      btn.className = "cc-menu__item";
      btn.setAttribute("role", "menuitem");

      const icon = document.createElement("span");
      icon.className = "cc-menu__icon";
      btn.appendChild(icon);

      const text = document.createElement("span");
      text.className = "cc-menu__text";
      text.textContent = String(w.text ?? "");
      btn.appendChild(text);

      if (w.type === "Header") {
        btn.classList.add("is-header");
        btn.disabled = true;
      } else if (w.type === "Radio") {
        icon.style.backgroundImage = w.selected ? "var(--menu-radio-on)" : "var(--menu-radio-off)";
        btn.addEventListener("click", () => {
          if (typeof w.onClickFunc === "function") w.onClickFunc();
          if (w.closeAfterClick) hide();
          else if (w.refreshAfterClick && menuInfoGetter) show(owner, menuInfoGetter());
        });
      } else {
        btn.addEventListener("click", () => {
          if (typeof w.onClickFunc === "function") w.onClickFunc();
          if (w.closeAfterClick) hide();
        });
      }

      content.appendChild(btn);
    }

    // Focus first actionable item (closest to in-game feel)
    const first = content.querySelector(".cc-menu__item:not(.is-header)");
    if (first && first.focus) first.focus();

    // Ensure min width matches Plumber (96)
    menu.style.width = "";
    // Make visible but hidden to measure
    menu.style.visibility = "hidden";
    menu.classList.add("is-open");
    menu.style.left = "0px";
    menu.style.top = "0px";
    const w = Math.max(96, Math.ceil(menu.getBoundingClientRect().width));
    menu.style.width = `${w}px`;
    menu.style.visibility = "";
  }

  function show(newOwner, menuInfo) {
    owner = newOwner;
    build(menuInfo);
    positionToOwner();
  }

  function toggle(newOwner, infoGetter) {
    if (owner === newOwner && menu.classList.contains("is-open")) {
      hide();
      return;
    }
    owner = newOwner;
    menuInfoGetter = infoGetter;
    const menuInfo = menuInfoGetter ? menuInfoGetter() : null;
    show(newOwner, menuInfo);
  }

  // auto-hide on outside click
  document.addEventListener(
    "mousedown",
    (e) => {
      if (!menu.classList.contains("is-open")) return;
      if (menu.contains(e.target)) return;
      if (owner && owner.contains && owner.contains(e.target)) return;
      hide();
    },
    true,
  );

  window.addEventListener("resize", () => {
    if (menu.classList.contains("is-open")) positionToOwner();
  });

  return {
    toggle,
    hide,
    isOpen: () => menu.classList.contains("is-open"),
  };
}

function bindDropdownMenus(i18n) {
  const L = (k, fallback) => (typeof i18n[k] === "string" ? i18n[k] : fallback);
  const menu = createDropdownMenu();
  if (window.__ccState) window.__ccState.dropdownMenu = menu;

  const filterBtn = document.querySelector("#cc-filter-btn");
  if (filterBtn) {
    filterBtn.addEventListener("click", () => {
      menu.toggle(filterBtn, () => {
        const selectedIndex = window.__ccState?.sortIndex || 1;
        return {
          widgets: [
            { type: "Header", text: L("ControlCenter_Sort_By", "Sort By") },
            {
              type: "Radio",
              text: L("ControlCenter_Sort_Alphabet", "Alphabetical"),
              selected: selectedIndex === 1,
              closeAfterClick: true,
              onClickFunc: () => {
                if (window.__ccState) window.__ccState.sortIndex = 1;
                rerender();
              },
            },
            {
              type: "Radio",
              text: L("ControlCenter_Sort_Date", "Date added"),
              selected: selectedIndex === 2,
              closeAfterClick: true,
              onClickFunc: () => {
                if (window.__ccState) window.__ccState.sortIndex = 2;
                rerender();
              },
            },
          ],
        };
      });
    });
  }

  const changelogMenuBtn = document.querySelector("#cc-changelog-menu-btn");
  if (changelogMenuBtn) {
    changelogMenuBtn.addEventListener("click", () => {
      menu.toggle(changelogMenuBtn, () => {
        const selectedIndex = window.__ccState?.changelogFontSizeIndex || 1;
        const sizes = [12, 14];
        return {
          widgets: [
            { type: "Header", text: "Font Size" },
            ...sizes.map((s, idx) => ({
              type: "Radio",
              text: String(s),
              selected: idx + 1 === selectedIndex,
              closeAfterClick: true,
              onClickFunc: () => {
                if (window.__ccState) window.__ccState.changelogFontSizeIndex = idx + 1;
                applyChangelogFontSize(idx + 1);
              },
            })),
          ],
        };
      });
    });
  }
}

// Highlight follower (kept lightweight)
function bindHighlight() {
  const container = document.querySelector(".cc-framecontainer");
  const hl = document.querySelector(".cc-highlight");
  if (!container || !hl) return;

  let hideTimer;
  function showFor(el) {
    if (!el) return;
    if (hideTimer) clearTimeout(hideTimer);
    const rEl = el.getBoundingClientRect();
    const rC = container.getBoundingClientRect();
    hl.style.left = `${Math.round(rEl.left - rC.left)}px`;
    hl.style.top = `${Math.round(rEl.top - rC.top)}px`;
    hl.style.width = `${Math.round(rEl.width)}px`;
    hl.style.height = `${Math.round(rEl.height)}px`;
    hl.classList.add("is-visible");
  }
  function hideSoon() {
    if (hideTimer) clearTimeout(hideTimer);
    hideTimer = setTimeout(() => hl.classList.remove("is-visible"), 40);
  }

  document.addEventListener(
    "pointerenter",
    (e) => {
      const el = e.target?.closest?.("[data-highlight='true']");
      if (!el) return;
      showFor(el);
    },
    true,
  );
  document.addEventListener(
    "pointerleave",
    (e) => {
      const el = e.target?.closest?.("[data-highlight='true']");
      if (!el) return;
      hideSoon();
    },
    true,
  );
}

// Basic scrollbar sync (kept from previous implementation; now works with dynamic content)
function clamp(n, min, max) {
  return Math.max(min, Math.min(max, n));
}

function bindScrollbars() {
  const step = 56; // ButtonSize * 2
  const pairs = [];
  for (const viewport of document.querySelectorAll("[data-scroll-viewport]")) {
    const key = viewport.getAttribute("data-scroll-viewport");
    const bar = document.querySelector(`.cc-scrollbar[data-scrollbar='${CSS.escape(key)}']`);
    if (key && bar) pairs.push({ key, viewport, bar });
  }

  for (const { key, viewport, bar } of pairs) {
    const up = bar.querySelector(".cc-scrollbar__up");
    const down = bar.querySelector(".cc-scrollbar__down");
    const thumb = bar.querySelector(".cc-scrollbar__thumb");

    function getRailRect() {
      const railTop = 16;
      const railBottom = 16;
      const railHeight = bar.clientHeight - railTop - railBottom;
      return { railTop, railBottom, railHeight, rBar: bar.getBoundingClientRect() };
    }

    function update() {
      const { railTop, railHeight } = getRailRect();
      const total = viewport.scrollHeight;
      const view = viewport.clientHeight;
      const range = Math.max(0, total - view);

      let ratio = total > 0 ? view / total : 1;
      ratio = Math.min(0.95, ratio);
      const thumbH = Math.max(32, Math.round(ratio * railHeight));
      thumb.style.height = `${thumbH}px`;

      const t = range > 0 ? viewport.scrollTop / range : 0;
      const top = railTop + t * (railHeight - thumbH);
      thumb.style.top = `${clamp(Math.round(top), railTop, railTop + railHeight - thumbH)}px`;

      const alwaysShow = key === "modules";
      bar.style.opacity = alwaysShow || range > 0 ? "1" : "0";
    }

    // Bind once per scrollbar
    if (!bar.__ccBound) {
      bar.__ccBound = true;
      bar.__ccUpdate = update;

      viewport.addEventListener("scroll", update, { passive: true });
      window.addEventListener("resize", update);

      up?.addEventListener("click", () => viewport.scrollBy({ top: -step, behavior: "auto" }));
      down?.addEventListener("click", () => viewport.scrollBy({ top: step, behavior: "auto" }));

      // Drag thumb
      let dragging = false;
      let dragStartY = 0;
      let dragStartScrollTop = 0;
      thumb.addEventListener("mousedown", (e) => {
        if (e.button !== 0) return;
        dragging = true;
        dragStartY = e.clientY;
        dragStartScrollTop = viewport.scrollTop;
        thumb.style.cursor = "grabbing";
        e.preventDefault();
      });
      window.addEventListener("mousemove", (e) => {
        if (!dragging) return;
        const { railHeight } = getRailRect();
        const total = viewport.scrollHeight;
        const view = viewport.clientHeight;
        const range = Math.max(0, total - view);
        if (range <= 0) return;
        const dy = e.clientY - dragStartY;
        viewport.scrollTop = dragStartScrollTop + (railHeight > 0 ? (dy / railHeight) * range : 0);
      });
      window.addEventListener("mouseup", () => {
        if (!dragging) return;
        dragging = false;
        thumb.style.cursor = "grab";
      });
    }

    // Always run an update pass (content size may have changed)
    if (typeof bar.__ccUpdate === "function") bar.__ccUpdate();
  }
}

function closePanel() {
  const cc = document.querySelector(".cc-frame");
  if (!cc) return;
  if (cc.style.display === "none") return;
  cc.style.transition = "opacity 180ms ease";
  cc.style.opacity = "0";
  setTimeout(() => {
    cc.style.display = "none";
  }, 220);
}

function bindClose() {
  const btn = document.querySelector(".cc-close");
  if (!btn) return;
  btn.addEventListener("click", () => {
    window.__ccState?.dropdownMenu?.hide?.();
    closePanel();
  });
}

// Global-ish state for the mock
const opts = {
  selectedCategory: null,
  searchText: "",
};

function rerender() {
  const s = window.__ccState;
  if (!s) return;

  renderModulesList(s.registry, s.db, s.i18n, opts);
  // keep scrollbars updated
  requestAnimationFrame(() => bindScrollbars());
}

async function main() {
  await buildSlices();

  const i18n = await loadJSON("./assets/i18n_config_ar.json");
  const registry = buildDefaultModules(i18n);
  const db = buildDefaultProfileState(registry.modules);

  // Build lookup for preview/parent fallbacks
  const moduleByKey = {};
  for (const m of registry.modules) {
    moduleByKey[m.dbKey] = m;
    if (Array.isArray(m.subOptions)) {
      for (const s of m.subOptions) moduleByKey[s.dbKey] = s;
    }
  }

  // Changelog: use the same entries file you maintain for AR.
  // For the mock we load the raw Lua-derived entries via a tiny JSON shim:
  // - If present, use assets/changelog_entries.json (optional future)
  // - Otherwise, render a simple placeholder based on i18n + current version.
  let changelogEntries = null;
  try {
    changelogEntries = await loadJSON("./assets/changelog_entries.json");
  } catch {
    changelogEntries = [
      {
        version: "12.00",
        title: "ﻟﻮﺣﺔ ﺇﻋﺪﺍﺩﺍﺕ ﺟﺪﻳﺪة",
        description:
          "ﻟﻮﺣﺔ ﺇﻋﺪﺍﺩﺍﺕ ﺟﺪﻳﺪة ﻣﺴﺘﻮﺣﺎة ﻣﻦ ﻭاﺟﻬﺔ ﺑﻠَﻤﺒَﺮ، ﻣﻊ ﺑﺤﺚ ﻭﺗﺼﻨﻴﻒ ﻭﻣﻌﺎﻳﻨﺔ ﻟﻠﻤﻴﺰات.\n\n- ﺍﺳﺘﺒﺪال ﻭﺍﺟﻬﺔ اﻟﺨﻴﺎرات اﻟﻘﺪﻳﻤﺔ ﺑﻮاﺟﻬﺔ ﺟﺪﻳﺪة ﻛﺎﻣﻠﺔ\n- ﺗﺤﺴﻴﻦ ﻋﺮﺽ اﻟﺨﻂ اﻟﻌﺮﺑﻲ ﻭاﻟﺘﺸﻜﻴﻞ\n- ﺇﺻﻼﺣﺎت ﻓﻲ ﺗﺒﻮﻳﺒﺎت اﻷﺳﻔﻞ",
      },
      { version: "11.20", title: "ﺛﻢ ﺗﻌﺎل أﻳﻬﺎ اﻟﻨﺎﺳﻚ! - 2", description: "- ﻧﺎﻓﺬة (ﻣﺎ اﻟﺠﺪﻳﺪ؟)\n- ﻗﺎﺋﻤﺔ ﻣﻌﺎﻳﻨﺔ\n- ﺗﻤﺮﻳﺮ ﻣﺤﺘﻮﻯ" },
      { version: "11.19", title: "ﺗﺤﺴﻴﻨﺎت ﻟﻠﻨﺺ اﻟﻌﺮﺑﻲ", description: "- ﺗﺤﺴﻴﻦ اﻟﺘﺸﻜﻴﻞ\n- ﺗﺤﺴﻴﻦ RTL" },
      { version: "11.18", title: "ﺇﺻﻼﺣﺎت اﺳﺘﻘﺮار اﻟﺘﺮﺟﻤﺔ", description: "- ﺇﺻﻼﺣﺎت ﻣﺨﺘﻠﻔﺔ" },
    ];
  }

  const changelogs = buildChangelogFromEntries(changelogEntries);
  const ids = Object.keys(changelogs)
    .map((k) => Number(k))
    .filter((n) => Number.isFinite(n))
    .sort((a, b) => b - a);
  const selectedVersionID = ids[0];

  window.__ccState = {
    i18n,
    registry,
    db,
    changelogs,
    selectedVersionID,
    moduleByKey,
    sortIndex: 1,
    changelogFontSizeIndex: 1,
  };

  // Initial render
  renderModulesList(registry, db, i18n, opts);
  setPreview(registry.modules[0], i18n);
  renderVersionList(changelogs, i18n, selectedVersionID);
  renderChangelog(changelogs, i18n, selectedVersionID);
  applyChangelogFontSize(window.__ccState.changelogFontSizeIndex);

  // Bind
  bindTabs();
  bindHighlight();
  bindScrollbars();
  bindClose();
  bindCategories(opts);
  bindSearch(opts);
  bindVersionMenu();
  bindDropdownMenus(i18n);

  // Escape-to-close (menu first, then panel)
  document.addEventListener("keydown", (e) => {
    if (e.key !== "Escape") return;
    const dm = window.__ccState?.dropdownMenu;
    if (dm?.isOpen?.()) {
      dm.hide();
      return;
    }
    closePanel();
  });
}

main().catch((err) => {
  // eslint-disable-next-line no-console
  console.error(err);
  const stage = document.querySelector(".stage");
  if (stage) {
    const pre = document.createElement("pre");
    pre.style.color = "#ffb4b4";
    pre.textContent = String(err?.stack || err);
    stage.appendChild(pre);
  }
});


