# XPS 13 9360 power

This install copied a script and linked a skill. It did not change how this laptop sleeps, how fast it runs on AC power, or what the kernel does with the disk and the GPU.

You can apply changes in either of two ways.

Run the fixed script:

```
~/.local/share/omarchy-bundles/xps-13-9360/scripts/apply
```

That script checks this is an XPS 13 9360, then applies the set it knows. A normal run can switch the power profile to balanced on AC and power-saver on battery. Add `--full` and it asks before forcing PCIe ASPM or turning the IOMMU off for the Iris Plus 640. Those two can lock the machine or drop a layer of isolation. Run the script again after a BIOS update. It drops a tweak the new BIOS no longer needs, and it leaves a file you edited.

Or ask your agent to apply the changes. In that case, the agent investigates and repairs on its own. The skill tells it where to look and which changes can freeze the machine, stop it waking, drop Wi-Fi, or make it run hot. What the agent writes can differ from the script, and it can cover a problem the script does not.
