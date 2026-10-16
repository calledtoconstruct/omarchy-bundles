---
name: xps-13-9360-power
description: Look around a Dell XPS 13 9360 for power and performance problems, including sleep, BIOS, PCIe, the disk, the iGPU, Wi-Fi, CPU idle, and heat. Repair what the readings show.
---

# XPS 13 9360 power

Use this when the owner of a Dell XPS 13 9360 asks about battery life, performance, sleep, heat, Wi-Fi, or the GPU. The notes below are places to look and hazards. They are not a complete repair list. The script's list is not the whole job.

Confirm the product name before you change the machine. Read the BIOS version and check whether the vendor still publishes a newer one for this model. After a BIOS change, look again. A reading from the previous BIOS is not evidence about the new one.

When the owner asks you to apply changes, repair a problem you can show from these readings. A different mechanism than any prewritten script is appropriate when it fixes what you found. Pause and tell the owner before a change that a gotcha below marks as able to freeze, fail to wake, or overheat the machine.

## Look at

- BIOS version, and whether a newer BIOS exists for this model.
- Which sleep the firmware advertises, and which sleep the last session actually used (suspend versus hibernate).
- The S0ix residency counter and the suspend success counter.
- PCIe ASPM, and what the firmware told the kernel about it.
- The SATA or RAID controller, and whether the NVMe disk sits behind it.
- The iGPU and its power features.
- The Wi-Fi device and its firmware.
- CPU idle states, the current power profile, and whether the machine is on AC power.
- Thermal management.

A flat S0ix counter after hibernation is not evidence that suspend is broken.

## Gotchas

- Forcing PCIe ASPM when the firmware told the kernel it is unsupported can lock the machine.
- The deepest NVMe power states have hung some Samsung drives.
- Turning off deep CPU idle can make the machine run hot.
- Wi-Fi power save on this Killer card can drop the link.
- An aggressive undervolt can crash the machine, and the newest BIOS locks the voltage controls.
