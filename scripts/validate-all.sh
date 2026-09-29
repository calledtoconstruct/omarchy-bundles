#!/bin/bash

# Validate every bundles/<id> directory with omarchy-bundle-validate
# from a checkout of calledtoconstruct/omarchy on the bundles branch.

set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)

if [[ -n ${OMARCHY_PATH:-} ]]; then
  omarchy=$OMARCHY_PATH
elif [[ -x $root/../omarchy/bin/omarchy-bundle-validate ]]; then
  omarchy=$(cd -- "$root/../omarchy" && pwd)
else
  echo "omarchy-bundle-validate was not found. Set OMARCHY_PATH to a checkout of calledtoconstruct/omarchy on the bundles branch." >&2
  exit 1
fi

validator=$omarchy/bin/omarchy-bundle-validate
if [[ ! -x $validator ]]; then
  echo "omarchy-bundle-validate was not found at $validator. Check out the bundles branch." >&2
  exit 1
fi

shopt -s nullglob
manifests=("$root"/bundles/*/bundle.json)
if (( ${#manifests[@]} == 0 )); then
  echo "No bundles to validate."
  exit 0
fi

for manifest in "${manifests[@]}"; do
  "$validator" "$(dirname -- "$manifest")"
done
