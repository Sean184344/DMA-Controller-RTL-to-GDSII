# Synthesis and physical-design flow

## Supplied artifacts

- `sdc/dma_constraints.sdc`: 10 ns clock period (100 MHz), 2 ns input/output delays, 0.2 ns clock uncertainty, `INVX1` input driving cell, and 0.1 load on outputs.
- `reports/synthesis/area.rpt`: Genus 21.14 area report for `dma_top`.
- `reports/synthesis/timing.rpt`: Genus 21.14 timing report.
- `reports/synthesis/power.rpt`: Genus 21.14 power report.
- `reports/synthesis/synthesized.v`: supplied mapped netlist.
- `images/rtl_schematic_*.png`: supplied RTL schematic screenshots.
- `images/innovus_physical_layout.jpeg`: supplied physical-layout screenshot.

## Flow notes

The supplied `scripts/run.tcl.reference` uses a `compile_ultra` command and a typical-library filename, while the separate `scripts/flow_commands_reference.txt` lists `synthesize -to_mapped` and a different SDC filename. These commands appear to be references from different tool flows and should not be treated as one validated, runnable script. The reports themselves identify Cadence Genus Synthesis Solution 21.14 and are the source of the metrics recorded here.

A production/reproducible flow normally needs the exact supported tool commands, technology-library setup, process corner, RC/parasitic assumptions, constraints, and implementation scripts. Those proprietary environment files are not included in this repository.

## Physical implementation evidence

The supplied layout screenshot is included as visual evidence. The image alone is not sufficient to independently verify DRC/LVS closure, extraction settings, signoff timing, or tape-out readiness. Do not claim signoff or tape-out status based only on the screenshot.
