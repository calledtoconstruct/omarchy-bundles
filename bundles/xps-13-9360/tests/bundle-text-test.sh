#!/bin/bash

set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../.." && pwd)
bundle=$root/bundles/xps-13-9360
fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

manifest=$bundle/bundle.json
intro=$bundle/introduction.md
skill=$bundle/skills/power/SKILL.md

[[ -f $manifest ]] || fail "missing bundle.json"
jq -e '.schemaVersion == 1 and .id == "xps-13-9360"' "$manifest" >/dev/null || fail "id or schema"
jq -e '.packages == [] and .aurPackages == [] and .plugins == [] and .config == [] and .conflicts == []' "$manifest" >/dev/null || fail "expected empty install lists"
jq -e '.skills == ["skills/power"]' "$manifest" >/dev/null || fail "skills"
grep -F '~/.local/share/omarchy-bundles/xps-13-9360/scripts/apply' "$intro" >/dev/null || fail "introduction script path"
grep -F 'the agent investigates and repairs on its own' "$intro" >/dev/null || fail "introduction agent path"
grep -F 'XPS 13 9360' "$skill" >/dev/null || fail "skill description"
grep -F '## Look at' "$skill" >/dev/null || fail "look at"
for phrase in sleep BIOS "PCIe" "SATA" "NVMe" "iGPU" "Wi-Fi" "CPU idle" "power profile"; do
  grep -F "$phrase" "$skill" >/dev/null || fail "look at missing $phrase"
done
grep -F '## Gotchas' "$skill" >/dev/null || fail "gotchas"
grep -F 'Forcing PCIe ASPM when the firmware told the kernel it is unsupported can lock the machine.' "$skill" >/dev/null || fail "aspm gotcha"
grep -F 'The deepest NVMe power states have hung some Samsung drives.' "$skill" >/dev/null || fail "nvme gotcha"
grep -F 'Turning off deep CPU idle can make the machine run hot.' "$skill" >/dev/null || fail "idle gotcha"
grep -F 'Wi-Fi power save on this Killer card can drop the link.' "$skill" >/dev/null || fail "wifi gotcha"
grep -F 'An aggressive undervolt can crash the machine' "$skill" >/dev/null || fail "undervolt gotcha"
grep -F 'A flat S0ix counter after hibernation is not evidence that suspend is broken.' "$skill" >/dev/null || fail "hibernate trap"
grep -F "The script's list is not the whole job." "$skill" >/dev/null || fail "script list"
grep -F 'scripts/apply' "$skill" >/dev/null && fail "skill tells the agent to run the script"
grep -F 'MemorySleepMode=deep' "$skill" >/dev/null && fail "skill names the sleep drop-in"
grep -F '71-xps-9360-ahci-idle.rules' "$skill" >/dev/null && fail "skill names the ahci rule"
printf 'ok\n'
