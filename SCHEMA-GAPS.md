# Schema gaps

No bundle has been added yet, so nothing below was forced by a manifest in this catalog. `schemaVersion` 1 rejects unknown top-level keys. When a bundle needs something `bundle.json` cannot say, record it here and keep the manifest valid.

| Need | What the schema allows | What a bundle would have to do instead |
| --- | --- | --- |
| Pin a plugin to a tag or commit | `plugins` is a git URL or the id of a plugin that is already installed. There is no pin field. | Ship the git URL and document the reviewed commit in the bundle README until the schema can store a pin. |
