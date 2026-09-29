# Schema gaps

`schemaVersion` 1 rejects unknown top-level keys. When a bundle needs something `bundle.json` cannot say, record it here and keep the manifest valid.

| Need | What the schema allows | What a bundle would have to do instead |
| --- | --- | --- |
| Pin a plugin to a tag or commit | `plugins` is a git URL or the id of a plugin that is already installed. There is no pin field. | Ship the git URL and document the reviewed commit in the bundle README until the schema can store a pin. `webdev` records the four commits it was checked against. |
| A launcher sequence | No field for "open a terminal, then a browser, then another app". `project` only creates folders and an optional script. | Document the sequence in the bundle README. `webdev` describes tmux `tdl`, `https://<name>.localhost`, lazydocker, then the GitHub plugin. `creator` describes the script, then OBS or the screen recorder into `raw/`, then Kdenlive, then `publish.md`. A Quickshell button is later work. |
| A package conflict | `conflicts` is a list of other bundle ids. There is no field for pacman package names that must not be installed together. | Name the packages in the bundle README. `creator` records that Omarchy's `obs-studio` and the AUR package `obs-studio-browser` conflict, and this bundle does not install the browser build. |
| A dated project folder | `omarchy bundle project new` takes the folder name as an argument. The manifest cannot compute `<YYYY-MM-DD>-<slug>` from a title. | The create script asks for the title and creates `~/Videos/Projects/<YYYY-MM-DD>-<slug>`. `creator` does this. `project.root` is still `~/Videos/Projects`, and `project.layout` is still the folder list inside that project. |
