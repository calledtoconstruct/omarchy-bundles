---
name: frontend-review
description: Accessibility, performance, and responsive checks to run on a web UI before opening a pull request.
---

# Frontend review

Use this before a pull request that changes what a person sees or operates in a browser. Skip it for backend-only changes.

The checks below are the review this bundle wants. Two public skills cover nearby ground and are the model for caring about the real page rather than a checklist in the abstract: [anthropics/skills frontend-design](https://github.com/anthropics/skills/tree/main/skills/frontend-design) (intentional visual choices, not a generic template) and [anthropics/skills webapp-testing](https://github.com/anthropics/skills/tree/main/skills/webapp-testing) (exercise the running page). This skill does not reuse their text. Do not import their Playwright helpers unless the project already depends on them.

## When

Run it on the project the PR actually builds. Serve it the way a reviewer would (`npm run dev`, `bin/rails server`, or the static file) and open `https://<name>.localhost` when that certificate exists, otherwise the localhost port the server prints.

## Accessibility

- Keyboard: reach every control and dismiss every dialog without a pointer. Focus is visible.
- Names: buttons, links, and inputs have an accessible name that says what they do.
- Contrast: text on its background stays readable. Do not rely on color alone for state.
- Motion: honor `prefers-reduced-motion` if the page animates.

## Performance

- The first view does not wait on a large unused script or image. Note anything that downloads more than the page needs.
- Images and fonts have dimensions or a reserve so the layout does not jump.
- A slow request shows a pending state. A failed request says what failed.

## Responsive

- Check a narrow width (about 360px) and a wide width (about 1200px).
- No horizontal scroll caused by a fixed-width element.
- Hit targets stay usable on the narrow width. Text does not overflow its container.

## Report

Lead with the failures. For each one, name the page, the width, what you did, and what happened. If a check could not be run because the server was down, say that instead of marking it passed.
