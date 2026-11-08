# Guiding principles: calledtoconstruct/omarchy-bundles

## Purpose and scope
Example Omarchy activity bundles: each bundle's manifest lists packages, plugins, agent skills, config files and an optional project layout; plus a generated static site.

## Stack and layout
`bundles/<id>/` (bundle.json, README.md, skills/, config/, scripts/), `scripts/` (validate-all.sh, check-packages.sh, build-site.py), `site/` (generated), `AUR-PACKAGES.md`, `SCHEMA-GAPS.md`.

## Commands
| Check | Command | Evidence |
|---|---|---|
| Lint | `shellcheck scripts/*.sh` (CI checks every `*.sh` under scripts/ and bundles/) | README.md, .github/workflows/validate.yml |
| Validate | `scripts/validate-all.sh` with `OMARCHY_PATH` pointing at a checkout of the omarchy `bundles` branch | README.md, validate.yml |
| Package check | `scripts/check-packages.sh` | validate.yml |
| Site | `python3 scripts/build-site.py` regenerates `site/` | README.md |
| Changed-feature tests | Validate the bundle you changed; run its own `tests/*.sh` if it has them | bundles/*/tests |
| CI | `validate` workflow on every push and PR (shellcheck, validate, package check); `pages` deploys `site/` on main | ./.github/workflows/ |

Commands marked as not written down come from the build files, not from project docs; confirm them before relying on them.

## Before every push
Before every push: run the build and type-check/lint that exist here, plus only the tests for the files or feature you changed (team rule, ideas #14 note 6797). Do not run the full suite locally as a routine gate; this repository has no CI that runs the full suite, so run the full suite only when the change is broad, and say in the PR that CI coverage is missing. Merge needs a positive review. Explain any new failure your change caused. Never weaken a valid test to make it pass, and never invent a command this file does not list.

## Project rules
- Follow CONTRIBUTING.md: no unknown manifest keys, ids match the folder, no `omarchy.*` ids, relative paths only.
- Package order: official Arch repos, then Omarchy installers, then AUR. Every AUR package is recorded in AUR-PACKAGES.md with its maintainer and reason.
- Do not list packages Omarchy already installs.
- Nothing in a bundle runs at install time; keep scripts limited to the create-project step.

## What to avoid
- Committing to the default branch; work on a branch and open a pull request.
- Deleting files, branches or history, or changing repository settings.
- Adding tooling, CI or dependencies that the change does not need.
- Rules copied from other projects (file-size limits, clocks, quotas) that this repository never adopted.

## Delivery and safety
- Merging to main redeploys the site to GitHub Pages when `site/` changes.

## Open questions
- None beyond keeping `site/` regenerated when bundles change.

## Sources
Read from the `main` branch on 2026-11-08 ET: `README.md`, `CONTRIBUTING.md`, `.github/workflows/validate.yml`, `.github/workflows/pages.yml`.

## Instruction updates
Check `guiding-principles.version` at the start of each turn and when you enter this project; reload this file when the version changes. Change this file, its version and date, and `PRINCIPLES_HISTORY.md` in the same commit. Team-wide role instructions are versioned separately in the team-process repository.
