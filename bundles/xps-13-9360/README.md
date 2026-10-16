# XPS 13 9360 power

For owners of the Dell XPS 13 9360. One install copies this folder and links one agent skill. It does not change power settings, the boot entry, or the running kernel.

## What it installs

No packages. No plugins. No config files are copied into the home directory.

The skill `skills/power` is linked into each agent skill folder that already exists. The link name is `xps-13-9360-power`. It tells an agent where to look on this laptop and which kinds of changes can freeze the machine, drop the link, or make it run hot.

## Applying changes

Install does not apply them. The owner chooses one of the two paths in `introduction.md`.

The script `scripts/apply` is the fixed path. It checks that the product name is `XPS 13 9360`, then writes only the tweaks that still apply on this BIOS. `scripts/apply --full` asks before the two boot parameters that can lock the machine or drop IOMMU isolation for the graphics device.

The skill is the other path. An agent that follows it investigates the machine and repairs what it finds. That can include problems the script does not know about.

## Conflicts

None.
