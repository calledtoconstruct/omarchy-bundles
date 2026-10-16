#!/usr/bin/env python3
"""Write the static bundle catalog into site/ from bundles/*/bundle.json."""

import html
import json
import re
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BUNDLES = ROOT / "bundles"
OUT = ROOT / "site"
CSS_SOURCE = Path(__file__).with_name("site.css")
CATALOG = "https://github.com/calledtoconstruct/omarchy-bundles"
ORDER = ["webdev", "creator", "local-ai", "study", "gaming", "cyber", "backup", "xps-13-9360"]

NOTICE = (
    "This catalog is not part of stock Omarchy. The omarchy bundle command is "
    "proposed in pull request 15603. A git URL installs only a repository whose "
    "root contains bundle.json, and that command warns the source is unreviewed. "
    "Each bundle here lives in a subfolder, so the command clones this catalog "
    "and adds that folder."
)


def escape(text):
    return html.escape(text, quote=True)


def inline(text):
    """Escape text, then allow code, bold, and http(s) links."""
    parts = re.split(r"(`[^`]+`)", text)
    rendered = []
    for part in parts:
        if part.startswith("`") and part.endswith("`") and len(part) >= 2:
            rendered.append("<code>" + escape(part[1:-1]) + "</code>")
            continue
        chunk = escape(part)
        chunk = re.sub(r"\*\*([^*]+)\*\*", r"<strong>\1</strong>", chunk)
        def link(match):
            label, url = match.group(1), match.group(2)
            if not url.startswith("https://"):
                return label
            return f'<a href="{escape(url)}">{label}</a>'
        chunk = re.sub(r"\[([^\]]+)\]\(([^)\s]+)\)", link, chunk)
        rendered.append(chunk)
    return "".join(rendered)


def markdown(source):
    lines = source.replace("\r\n", "\n").split("\n")
    blocks = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if not line.strip():
            i += 1
            continue
        if line.startswith("```"):
            fence = []
            i += 1
            while i < len(lines) and not lines[i].startswith("```"):
                fence.append(lines[i])
                i += 1
            i += 1
            blocks.append("<pre><code>" + escape("\n".join(fence)) + "</code></pre>")
            continue
        if line.startswith("#"):
            level = len(line) - len(line.lstrip("#"))
            level = min(max(level, 1), 3)
            tag = "h2" if level == 1 else "h3"
            blocks.append(f"<{tag}>{inline(line[level:].strip())}</{tag}>")
            i += 1
            continue
        if line.startswith("|") and i + 1 < len(lines) and re.match(r"^\|\s*-+", lines[i + 1]):
            rows = []
            while i < len(lines) and lines[i].startswith("|"):
                rows.append([cell.strip() for cell in lines[i].strip().strip("|").split("|")])
                i += 1
            head, body = rows[0], rows[2:]
            thead = "".join(f"<th>{inline(cell)}</th>" for cell in head)
            body_html = []
            for row in body:
                body_html.append("<tr>" + "".join(f"<td>{inline(cell)}</td>" for cell in row) + "</tr>")
            blocks.append("<table><thead><tr>" + thead + "</tr></thead><tbody>" + "".join(body_html) + "</tbody></table>")
            continue
        if line.startswith(">"):
            quoted = []
            while i < len(lines) and lines[i].startswith(">"):
                quoted.append(lines[i].lstrip(">").strip())
                i += 1
            blocks.append("<blockquote><p>" + inline(" ".join(quoted)) + "</p></blockquote>")
            continue
        if re.match(r"^[-*] ", line):
            items = []
            while i < len(lines) and re.match(r"^[-*] ", lines[i]):
                items.append("<li>" + inline(lines[i][2:].strip()) + "</li>")
                i += 1
            blocks.append("<ul>" + "".join(items) + "</ul>")
            continue
        if re.match(r"^\d+\. ", line):
            items = []
            while i < len(lines) and re.match(r"^\d+\. ", lines[i]):
                items.append("<li>" + inline(re.sub(r"^\d+\. ", "", lines[i]).strip()) + "</li>")
                i += 1
            blocks.append("<ol>" + "".join(items) + "</ol>")
            continue
        para = [line.strip()]
        i += 1
        while i < len(lines) and lines[i].strip() and not lines[i].startswith(("#", ">", "|", "-", "*", "```")) and not re.match(r"^\d+\. ", lines[i]):
            para.append(lines[i].strip())
            i += 1
        blocks.append("<p>" + inline(" ".join(para)) + "</p>")
    return "\n".join(blocks)


def load_bundles():
    found = {}
    for path in sorted(BUNDLES.glob("*/bundle.json")):
        data = json.loads(path.read_text())
        data["_dir"] = path.parent
        found[data["id"]] = data
    missing = [name for name in ORDER if name not in found]
    extra = [name for name in found if name not in ORDER]
    if missing or extra:
        raise SystemExit(f"bundle order mismatch missing={missing} extra={extra}")
    return [found[name] for name in ORDER]


def install_command(bundle_id):
    return (
        "git clone https://github.com/calledtoconstruct/omarchy-bundles.git\n"
        f"omarchy bundle add ./omarchy-bundles/bundles/{bundle_id}"
    )


def repo_name(url):
    match = re.match(r"https://github\.com/([^/]+)/([^/#]+?)(?:\.git)?/?$", url)
    if not match:
        return url
    return f"{match.group(1)}/{match.group(2)}"


def page(title, body, depth):
    prefix = "../" * depth
    return f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{escape(title)}</title>
<link rel="stylesheet" href="{prefix}css/site.css">
</head>
<body>
<a class="skip" href="#content">Skip to content</a>
<header class="site">
  <div class="wrap brand">
    <a class="mark" href="{prefix}index.html">Omarchy bundles</a>
    <nav>
      <a href="{CATALOG}">Catalog source</a>
      <a href="https://github.com/omacom/omarchy/pull/15603">Command pull request</a>
    </nav>
  </div>
</header>
{body}
<footer class="site">
  <div class="wrap">
    <p>A community catalog of activity bundles. Not an official Omarchy site, and not a review of the packages a bundle installs. In Chromium on Omarchy, the Theme Sync extension paints these pages with the desktop palette. Other browsers keep the paper colors.</p>
    <p><a href="https://github.com/omacom/omarchy/discussions/13551">Discussion 13551</a> asked whether a bundle should be a registry type. <code>publisher/name</code> still is not served.</p>
  </div>
</footer>
<script>
document.querySelectorAll("button.copy").forEach(function (button) {{
  button.addEventListener("click", function () {{
    var text = button.parentElement.nextElementSibling.textContent;
    navigator.clipboard.writeText(text).then(function () {{
      button.textContent = "Copied";
    }});
  }});
}});
</script>
</body>
</html>
"""


def fact_list(title, items):
    if not items:
        return f"<section><h2>{escape(title)}</h2><p class=\"empty\">None.</p></section>"
    lis = "".join(f"<li>{item}</li>" for item in items)
    return f"<section><h2>{escape(title)}</h2><ul>{lis}</ul></section>"


def render_index(bundles):
    cards = []
    for bundle in bundles:
        cards.append(
            "<a class=\"card\" href=\"bundles/" + escape(bundle["id"]) + "/\">"
            f"<p class=\"meta\">{escape(bundle['id'])} · {escape(bundle['version'])}</p>"
            f"<h2>{escape(bundle['name'])}</h2>"
            f"<p>{escape(bundle['description'])}</p>"
            "</a>"
        )
    body = f"""
<main id="content">
  <div class="wrap hero">
    <h1>Activities you can add and remove.</h1>
    <p class="lede">{len(bundles)} bundles group the packages, plugins, skills, and config for one kind of work. Copy the install command, then read what that bundle changes.</p>
    <p class="notice">{escape(NOTICE)}</p>
  </div>
  <div class="wrap grid">
    {''.join(cards)}
  </div>
</main>
"""
    return page("Omarchy bundles", body, 0)


def render_bundle(bundle):
    command = install_command(bundle["id"])
    packages = [f"<code>{escape(name)}</code>" for name in bundle.get("packages", [])]
    aur = [f"<code>{escape(name)}</code> on the AUR" for name in bundle.get("aurPackages", [])]
    plugins = []
    for url in bundle.get("plugins", []):
        if url.startswith("https://github.com/"):
            plugins.append(f'<a href="{escape(url)}"><code>{escape(repo_name(url))}</code></a>')
        else:
            plugins.append(f"<code>{escape(url)}</code>")
    skills = [f"<code>{escape(Path(item).name)}</code>" for item in bundle.get("skills", [])]
    configs = [
        f"<code>{escape(item['source'])}</code> to <code>{escape(item['target'])}</code>"
        for item in bundle.get("config", [])
    ]
    conflicts = [f"<code>{escape(name)}</code>" for name in bundle.get("conflicts", [])]
    project = bundle.get("project")
    if project:
        layout = ", ".join(project.get("layout", [])) or "none"
        project_html = (
            f"<section><h2>Project</h2><p><code>omarchy bundle project new {escape(bundle['id'])} &lt;name&gt;</code> "
            f"creates the layout under <code>{escape(project.get('root', ''))}</code> "
            f"({escape(layout)}). The create script runs only after you confirm it.</p></section>"
        )
    else:
        project_html = "<section><h2>Project</h2><p class=\"empty\">This bundle does not create a project folder.</p></section>"
    intro_path = bundle["_dir"] / bundle.get("introduction", "")
    prose = markdown(intro_path.read_text()) if intro_path.is_file() else f"<p>{escape(bundle['description'])}</p>"
    source = f"{CATALOG}/tree/main/bundles/{bundle['id']}"
    body = f"""
<main id="content" class="detail">
  <div class="wrap">
    <p class="kicker"><a href="../../index.html">All bundles</a> · {escape(bundle['id'])} · {escape(bundle['version'])}</p>
    <h1>{escape(bundle['name'])}</h1>
    <p class="lede">{escape(bundle['description'])}</p>
    <p class="notice">{escape(NOTICE)}</p>
    <div class="install">
      <div class="row"><p>Install this bundle</p><button class="copy" type="button">Copy command</button></div>
      <pre><code>{escape(command)}</code></pre>
    </div>
    <div class="facts">
      {fact_list("Arch packages", packages)}
      {fact_list("AUR packages", aur)}
      {fact_list("Plugins", plugins)}
      {fact_list("Skills", skills)}
      {fact_list("Config files", configs) if configs else ""}
      {fact_list("Conflicts", conflicts) if conflicts else ""}
      {project_html}
    </div>
    <article class="prose">
      {prose}
      <p><a href="{source}">Read this bundle on GitHub</a>.</p>
    </article>
  </div>
</main>
"""
    return page(f"{bundle['name']} · Omarchy bundles", body, 2)


def self_check():
    sample = markdown("See **<script>alert(1)</script>** and `a<b>` and [ok](https://example.com/a) and [no](javascript:alert(1)).")
    if "<script>" in sample or 'href="javascript:' in sample:
        raise SystemExit("markdown escaped unsafe input poorly: " + sample)
    if "<strong>" not in sample or "<code>a&lt;b&gt;</code>" not in sample:
        raise SystemExit("markdown dropped safe formatting: " + sample)


def main():
    self_check()
    bundles = load_bundles()
    if OUT.exists():
        shutil.rmtree(OUT)
    (OUT / "css").mkdir(parents=True)
    (OUT / "bundles").mkdir()
    shutil.copyfile(CSS_SOURCE, OUT / "css" / "site.css")
    (OUT / "index.html").write_text(render_index(bundles))
    for bundle in bundles:
        folder = OUT / "bundles" / bundle["id"]
        folder.mkdir()
        (folder / "index.html").write_text(render_bundle(bundle))
        text = (folder / "index.html").read_text()
        for name in bundle.get("packages", []):
            if escape(name) not in text:
                raise SystemExit(f"{bundle['id']} page missing package {name}")
        if f"bundles/{bundle['id']}" not in text:
            raise SystemExit(f"{bundle['id']} page missing install path")
    not_found = page("Page not found · Omarchy bundles", """
<main id="content"><div class="wrap hero"><h1>That page is not in the catalog.</h1>
<p class="lede"><a href="index.html">Back to the bundles</a>.</p></div></main>
""", 0)
    (OUT / "404.html").write_text(not_found)
    (OUT / "_redirects").write_text("/* /404.html 404\n")
    print(f"wrote {len(bundles)} bundles to {OUT}")


if __name__ == "__main__":
    main()
