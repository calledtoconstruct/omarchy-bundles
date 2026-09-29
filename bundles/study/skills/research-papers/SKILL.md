---
name: research-papers
description: Find and cite sources in Zotero, then write a course assignment in Typst with a bibliography exported from that library.
---

# Research papers

Use this for an assignment in `~/School/<term>/<course>/assignments/`. Sources go through the Zotero app. The paper is Typst. A `.bib` file is the link between them.

These public skills were the model for searching a library and managing citations. Their text is not copied here, and this skill does not call the Zotero Web API:

- [K-Dense-AI/scientific-agent-skills, pyzotero](https://github.com/K-Dense-AI/scientific-agent-skills/blob/main/skills/pyzotero/SKILL.md)
- [K-Dense-AI/scientific-agent-skills, citation-management](https://github.com/K-Dense-AI/scientific-agent-skills/blob/main/skills/citation-management/SKILL.md)
- [K-Dense-AI/scientific-agent-skills, literature-review](https://github.com/K-Dense-AI/scientific-agent-skills/blob/main/skills/literature-review/SKILL.md)

Ask before any step that needs a Zotero account, an API key, or a sync.

## Find and file the source

Search in the Zotero app, or with the connector in the browser, and save the item into a collection named for the course. Open the item and check the title, authors, and year against the paper or the publisher page. Fix the record in Zotero when they disagree.

Export the collection as BibTeX to `assignments/refs.bib`. Export again after you add a source. The create script's `refs.bib` starts with one `@misc{example, ...}` placeholder. Replace that entry with the export.

## Write in Typst

Edit `assignments/assignment.typ`, or add another `.typ` file beside it. Cite a key from the `.bib` file with `@key`. Keep the bibliography line:

```typst
#bibliography("refs.bib", style: "ieee")
```

Change the style when the assignment names one. Compile from the assignments folder:

```bash
typst compile assignment.typ
```

Typst reads `refs.bib` from that folder. PDFs of the papers themselves belong in `readings/`. `zathura` opens them. `pandoc` is available when a draft arrives as a Word or Markdown file that needs to become Typst. Keep the cited claims inside what the exported sources say.
