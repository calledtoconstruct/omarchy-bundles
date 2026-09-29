#!/usr/bin/env python3
"""Send one prompt to the Ollama server on this machine."""

import json
import os
import sys
import urllib.request

API = "http://127.0.0.1:11434/api/generate"


def main() -> int:
    prompt = " ".join(sys.argv[1:]).strip() or "Say hello in one sentence."
    model = os.environ.get("OLLAMA_MODEL", "llama3.2:3b")
    body = json.dumps({"model": model, "prompt": prompt, "stream": False}).encode()
    request = urllib.request.Request(
        API, data=body, headers={"Content-Type": "application/json"}
    )
    with urllib.request.urlopen(request, timeout=600) as response:
        payload = json.load(response)
    print(payload.get("response", ""), end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
