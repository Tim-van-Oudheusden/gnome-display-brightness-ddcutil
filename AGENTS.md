# Agent Instructions

Display Brightness (ddcutil) is a GNOME Shell extension (UUID `display-brightness-ddcutil@tim-van-oudheusden.github.io`,
GNOME Shell 50 and 51) that puts a brightness slider for every monitor `ddcutil` detects in Quick Settings or the top
bar. It is plain GJS with ES modules, no build step and no npm runtime dependencies. It started as a fork of
[daitj/gnome-display-brightness-ddcutil](https://github.com/daitj/gnome-display-brightness-ddcutil); keep the credits in
`README.md`.

## Layout

| Path | What it is |
| --- | --- |
| `src/` | Everything that ships in the bundle; `gnome-extensions pack` reads it |
| `src/extension.js`, `src/lib/` | GNOME Shell process: ddcutil calls, menus, sliders, keyboard shortcuts |
| `src/prefs.js`, `src/preferences/`, `src/ui/` | Preferences process: the libadwaita window and its GtkBuilder templates |
| `src/schemas/` | GSettings schema `org.gnome.shell.extensions.display-brightness-ddcutil` |
| `po/` | Translations; `po/POTFILES` lists every file with translatable strings |
| `data/screenshots/` | Screenshots used by `README.md` |

## Rules

- Follow the [EGO review guidelines](https://gjs.guide/extensions/review-guidelines/review-guidelines.html). In
  particular: create nothing before `enable()` and undo everything in `disable()`; never import `Gtk`, `Gdk` or `Adw`
  in `src/extension.js` or `src/lib/`, and never import `St`, `Clutter`, `Meta` or `Shell` in `src/prefs.js`,
  `src/preferences/` or `src/ui/`.
- Do not change the schema ID or its path: users' settings live there. Do not change the UUID.
- New modules use camelCase file names, as GNOME Shell does (`shortcutWidget.js`). Add files with translatable strings
  to `po/POTFILES`.
- EGO rejects code that reads as machine-generated: no prompt-like comments, no unused code, keep the existing style.
- Commits and PR titles follow [Conventional Commits](https://www.conventionalcommits.org/) (`fix: …`, `feat(prefs): …`).
  Branch off `main`; work lands through a pull request.

## Commands

```sh
npm ci          # ESLint, once
make lint       # ESLint with the gjs.guide configuration
make check      # validate the schema and the .po files
make build      # dist/display-brightness-ddcutil@tim-van-oudheusden.github.io.shell-extension.zip
make update-po  # refresh po/display-brightness-ddcutil.pot and merge it into every .po
make install    # build, then install the bundle for the current user
```

CI (`.github/workflows/ci.yml`) runs `npx eslint .`, `make check` and `make build`. Run them before pushing. `make
install` changes the user's GNOME Shell: only run it when asked to.
