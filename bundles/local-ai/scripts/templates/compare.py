#!/usr/bin/env python3
"""Run evals/cases.json against two local Ollama models and print a markdown table."""

import json
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CASES = ROOT / "evals" / "cases.json"
API = "http://127.0.0.1:11434/api/generate"


def cell(text: str) -> str:
    return " ".join(text.replace("|", "\\|").split())


def generate(model: str, prompt: str) -> str:
    body = json.dumps({"model": model, "prompt": prompt, "stream": False}).encode()
    request = urllib.request.Request(
        API, data=body, headers={"Content-Type": "application/json"}
    )
    with urllib.request.urlopen(request, timeout=600) as response:
        payload = json.load(response)
    return cell(str(payload.get("response", "")))


def main() -> int:
    if len(sys.argv) != 3:
        print(
            "usage: uv run python evals/compare.py <model-a> <model-b>",
            file=sys.stderr,
        )
        return 2
    models = [sys.argv[1], sys.argv[2]]
    cases = json.loads(CASES.read_text())
    print("| Case | Expected | " + " | ".join(models) + " |")
    print("| --- | --- | --- | --- |")
    for case in cases:
        outputs = [generate(model, case["prompt"]) for model in models]
        print(
            "| "
            + " | ".join([cell(case["id"]), cell(case["expected"]), *outputs])
            + " |"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
