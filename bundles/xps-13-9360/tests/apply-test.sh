#!/bin/bash

set -euo pipefail

bundle=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
apply=$bundle/scripts/apply
hook=$bundle/scripts/s0ix-fallback
fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

scratch=$(mktemp -d)
trap 'export PATH="/usr/bin:/bin"; rm -rf "$scratch"' EXIT

fresh() {
  local product=${1:-XPS 13 9360} bios=${2:-2.21.0}
  export PATH="/usr/bin:/bin"
  rm -rf "$scratch/root" "$scratch/state" "$scratch/sys" "$scratch/bin" "$scratch/calls"
  mkdir -p "$scratch/root" "$scratch/state" "$scratch/sys/pci" "$scratch/sys/i915" "$scratch/bin"
  printf '%s\n' "$product" >"$scratch/sys/product"
  printf '%s\n' "$bios" >"$scratch/sys/bios"
  printf 's2idle\n' >"$scratch/sys/mem_sleep"
  printf '\n' >"$scratch/sys/dmesg"
  : >"$scratch/calls"
  export XPS9360_PRODUCT_FILE=$scratch/sys/product
  export XPS9360_BIOS_FILE=$scratch/sys/bios
  export XPS9360_ROOT=$scratch/root
  export XPS9360_STATE_DIR=$scratch/state
  export XPS9360_PCI_ROOT=$scratch/sys/pci
  export XPS9360_I915_DIR=$scratch/sys/i915
  export XPS9360_MEM_SLEEP_FILE=$scratch/sys/mem_sleep
  export XPS9360_DMESG_FILE=$scratch/sys/dmesg
  export XPS9360_S0IX_RESIDENCY_FILE=$scratch/sys/residency
  export XPS9360_SUSPEND_SUCCESS_FILE=$scratch/sys/success
  export XPS9360_UPTIME_FILE=$scratch/sys/uptime
  export XPS9360_AC_ONLINE_FILE=$scratch/sys/ac
  export XPS9360_S0IX_DROP_IN=$scratch/root/etc/systemd/sleep.conf.d/xps-9360-s0ix.conf
  export XPS9360_S0IX_PROBE_FILE=$scratch/root/run/probe
  export XPS9360_SLEEP_CONF_ROOTS=$scratch/sys/sleep.d
  export XPS9360_LIMINE=$scratch/bin/limine-mkinitcpio
  unset XPS9360_ASSUME_YES
  cat >"$XPS9360_LIMINE" <<'SH'
#!/bin/bash
printf 'limine\n' >>"$CALL_LOG"
SH
  chmod +x "$XPS9360_LIMINE"
  export CALL_LOG=$scratch/calls
  export PATH="$scratch/bin:/usr/bin:/bin"
}

controller() {
  local remap=$1 class=$2
  local dev=$scratch/sys/pci/0000:00:17.0
  mkdir -p "$dev/power" "$dev/ata1/link1/dev1.0/ata_device/dev1.0"
  printf '0x8086\n' >"$dev/vendor"
  printf '0x282a\n' >"$dev/device"
  printf '%s\n' "$remap" >"$dev/remapped_nvme"
  printf 'on\n' >"$dev/power/control"
  printf '%s\n' "$class" >"$dev/ata1/link1/dev1.0/ata_device/dev1.0/class"
}

iris() {
  local dev=$scratch/sys/pci/0000:00:02.0
  mkdir -p "$dev"
  printf '0x8086\n' >"$dev/vendor"
  printf '0x5926\n' >"$dev/device"
}

fresh "XPS 13 9365"
out=$("$apply")
grep -F 'This bundle applies only to the XPS 13 9360.' <<<"$out" >/dev/null || fail "refusal sentence"
find "$scratch/root" -type f | grep -q . && fail "other product left a file"

fresh
"$apply" >/dev/null
grep -qx '2.21.0' "$scratch/state/bios" || fail "state bios"
before=$(cat "$scratch/state/bios")
out=$("$apply")
grep -F 'already' <<<"$out" >/dev/null || fail "second run already"
[[ $(cat "$scratch/state/bios") == "$before" ]] || fail "state bytes changed"

fresh
printf '[s2idle] deep\n' >"$scratch/sys/mem_sleep"
printf '0\n' >"$scratch/sys/residency"
controller 0 unknown
"$apply" >/dev/null
[[ -x $scratch/root/usr/lib/systemd/system-sleep/xps-9360-s0ix-fallback ]] || fail "hook missing"
[[ -f $scratch/root/etc/udev/rules.d/71-xps-9360-ahci-idle.rules ]] || fail "ahci rule missing"
cmp -s "$hook" "$scratch/root/usr/lib/systemd/system-sleep/xps-9360-s0ix-fallback" || fail "hook copy"

fresh
printf '[s2idle] deep\n' >"$scratch/sys/mem_sleep"
controller 1 unknown
"$apply" >/dev/null
[[ ! -e $scratch/root/etc/udev/rules.d/71-xps-9360-ahci-idle.rules ]] || fail "remapped nvme got a rule"

fresh
printf '[s2idle] deep\n' >"$scratch/sys/mem_sleep"
controller 0 ata
"$apply" >/dev/null
[[ ! -e $scratch/root/etc/udev/rules.d/71-xps-9360-ahci-idle.rules ]] || fail "a disk got a rule"

platform_hook() {
  local mode=$1 residency=$2 success=$3 uptime=$4 bios=${5:-2.21.0}
  printf '%s\n' "$mode" >"$scratch/sys/mem_sleep"
  printf '%s\n' "$residency" >"$scratch/sys/residency"
  printf '%s\n' "$success" >"$scratch/sys/success"
  printf '%s 0\n' "$uptime" >"$scratch/sys/uptime"
  printf '%s\n' "$bios" >"$scratch/sys/bios"
}
fresh
mkdir -p "$scratch/sys/sleep.d"
platform_hook "[s2idle] deep" 0 1 1000
"$hook" pre hibernate
platform_hook "[s2idle] deep" 0 2 1100
"$hook" post hibernate
[[ ! -e $XPS9360_S0IX_DROP_IN ]] || fail "hibernate wrote a sleep drop-in"

platform_hook "[s2idle] deep" 0 8 6000
"$hook" pre suspend
platform_hook "[s2idle] deep" 0 9 6100
"$hook" post suspend
grep -F 'MemorySleepMode=deep' "$XPS9360_S0IX_DROP_IN" >/dev/null || fail "s2idle did not select deep"

fresh
cat >"$scratch/bin/powerprofilesctl" <<'SH'
#!/bin/bash
printf '%s\n' "$*" >>"$CALL_LOG"
SH
chmod +x "$scratch/bin/powerprofilesctl"
printf '1\n' >"$scratch/sys/ac"
"$apply" >/dev/null
[[ -x $scratch/root/usr/local/lib/xps-9360/power-profile ]] || fail "profile helper missing"
[[ -f $scratch/root/etc/udev/rules.d/71-xps-9360-power-profile.rules ]] || fail "profile rule missing"
: >"$scratch/calls"
"$scratch/root/usr/local/lib/xps-9360/power-profile"
grep -qx 'set balanced' "$scratch/calls" || fail "ac did not select balanced"

fresh
for cmd in dirname install mkdir mktemp cmp cp sed rm cat; do
  ln -sfn "$(command -v "$cmd")" "$scratch/bin/$cmd"
done
export PATH="$scratch/bin"
"$apply" >/dev/null
[[ ! -e $scratch/root/usr/local/lib/xps-9360/power-profile && ! -e $scratch/root/etc/udev/rules.d/71-xps-9360-power-profile.rules ]] || fail "profile installed without powerprofilesctl"

fresh
iris
printf '0\n' >"$scratch/sys/i915/enable_psr"
"$apply" >/dev/null
[[ $(<"$scratch/sys/i915/enable_psr") == "-1" ]] || fail "psr stayed off"

fresh
iris
printf -- '-1' >"$scratch/sys/i915/enable_psr"
"$apply" >/dev/null
[[ $(cat "$scratch/sys/i915/enable_psr") == "-1" ]] || fail "psr default was rewritten"

fresh
printf '0' >"$scratch/sys/i915/enable_psr"
"$apply" >/dev/null
[[ $(cat "$scratch/sys/i915/enable_psr") == "0" ]] || fail "psr changed without the iris gpu"

grep -E 'undervolt|wifi.powersave' "$apply" "$hook" && fail "script mentions a forbidden tweak"

fresh
iris
printf "ACPI FADT declares the system doesn't support PCIe ASPM\n" >"$scratch/sys/dmesg"
printf 'n\n' | "$apply" --full >/dev/null
[[ ! -e $scratch/root/etc/limine-entry-tool.d/xps-9360-power.conf ]] || fail "declined full wrote limine"

fresh
iris
printf "ACPI FADT declares the system doesn't support PCIe ASPM\n" >"$scratch/sys/dmesg"
XPS9360_ASSUME_YES=1 "$apply" --full >/dev/null
limine=$scratch/root/etc/limine-entry-tool.d/xps-9360-power.conf
grep -F 'pcie_aspm=force' "$limine" >/dev/null || fail "missing aspm"
grep -F 'intel_iommu=igfx_off' "$limine" >/dev/null || fail "missing igfx"
[[ $(grep -c limine "$scratch/calls") -eq 1 ]] || fail "limine was not run once"
XPS9360_ASSUME_YES=1 "$apply" --full >/dev/null
[[ $(grep -c limine "$scratch/calls") -eq 1 ]] || fail "second full run rebuilt limine"
grep -F 'already' <<<"$(XPS9360_ASSUME_YES=1 "$apply" --full)" >/dev/null || fail "second full run did not say already"

fresh
iris
printf "ACPI FADT declares the system doesn't support PCIe ASPM\n" >"$scratch/sys/dmesg"
XPS9360_ASSUME_YES=1 "$apply" --full >/dev/null
printf '2.22.0\n' >"$scratch/sys/bios"
printf '\n' >"$scratch/sys/dmesg"
"$apply" >/dev/null
grep -F 'pcie_aspm=force' "$limine" && fail "aspm survived a bios that allows it"
grep -F 'intel_iommu=igfx_off' "$limine" >/dev/null || fail "igfx was dropped"

fresh
iris
printf "ACPI FADT declares the system doesn't support PCIe ASPM\n" >"$scratch/sys/dmesg"
XPS9360_ASSUME_YES=1 "$apply" --full >/dev/null
printf 'edited\n' >"$limine"
printf '2.22.0\n' >"$scratch/sys/bios"
printf '\n' >"$scratch/sys/dmesg"
"$apply" >/dev/null
[[ $(<"$limine") == "edited" ]] || fail "an edited limine file was replaced"

printf 'ok\n'
