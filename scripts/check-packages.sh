#!/bin/bash

# Confirm every package named by a bundle is in core, extra, or multilib,
# or in the AUR. Warn for each AUR package. Fail if one is flagged out of date
# or if a name exists in neither place.

set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
arch_search="https://archlinux.org/packages/search/json/"
aur_info="https://aur.archlinux.org/rpc/v5/info"
user_agent="omarchy-bundles-check"

shopt -s nullglob
manifests=("$root"/bundles/*/bundle.json)
if (( ${#manifests[@]} == 0 )); then
  echo "No bundle packages to check."
  exit 0
fi

failed=0
checked=0

official_count() {
  local pkg="$1" body
  body=$(curl -fsS --retry 3 --retry-delay 1 -A "$user_agent" -G --data-urlencode "name=$pkg" "$arch_search")
  # shellcheck disable=SC2016
  jq -r --arg name "$pkg" '
    [.results[] | select(.pkgname == $name and (.repo == "core" or .repo == "extra" or .repo == "multilib"))] | length
  ' <<<"$body"
}

aur_lookup() {
  local pkg="$1"
  curl -fsS --retry 3 --retry-delay 1 -A "$user_agent" -G --data-urlencode "arg[]=$pkg" "$aur_info"
}

maintainer_package_count() {
  local maintainer="$1" encoded body
  # shellcheck disable=SC2016
  encoded=$(jq -rn --arg name "$maintainer" '$name | @uri')
  body=$(curl -fsS --retry 3 --retry-delay 1 -A "$user_agent" \
    "https://aur.archlinux.org/rpc/v5/search/${encoded}?by=maintainer")
  jq -r '.resultcount' <<<"$body"
}

for manifest in "${manifests[@]}"; do
  bundle_id=$(jq -r '.id' "$manifest")
  while IFS= read -r pkg; do
    [[ -n $pkg ]] || continue
    checked=$((checked + 1))
    official=$(official_count "$pkg")
    if (( official > 0 )); then
      continue
    fi

    info=$(aur_lookup "$pkg")
    found=$(jq -r '.resultcount' <<<"$info")
    if (( found == 0 )); then
      echo "Package ${pkg} from bundle ${bundle_id} is not in core, extra, multilib, or the AUR." >&2
      failed=1
      continue
    fi

    maintainer=$(jq -r '.results[0].Maintainer // "orphaned"' <<<"$info")
    votes=$(jq -r '.results[0].NumVotes' <<<"$info")
    out_of_date=$(jq -r '.results[0].OutOfDate | if . == null then "no" else "yes" end' <<<"$info")
    if [[ $maintainer == "orphaned" ]]; then
      maintained=0
    else
      maintained=$(maintainer_package_count "$maintainer")
    fi

    echo "AUR warning: ${bundle_id} uses ${pkg} (maintainer: ${maintainer}, votes: ${votes}, maintainer packages: ${maintained}, out of date: ${out_of_date})"
    if [[ $out_of_date == "yes" ]]; then
      echo "AUR package ${pkg} from bundle ${bundle_id} is flagged out of date." >&2
      failed=1
    fi
  done < <(jq -r '.packages[]?' "$manifest")
done

if (( failed )); then
  exit 1
fi

echo "Checked ${checked} package references."
