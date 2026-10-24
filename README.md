# Design and Implementation of a Memory-Mapped DMA Controller Using ASIC Flow

A Verilog RTL project implementing a simple memory-to-memory Direct Memory Access (DMA) controller with a memory-mapped CPU configuration interface, an FSM-based transfer engine, simulation-based functional checking, synthesis, timing/power/area reporting, and physical-design evidence.

> **Publication note:** The supplied conference materials identify this work as *“Design and Implementation of a Memory-Mapped DMA Controller Using ASIC Flow,”* paper ID **ICCES-332**, presented at the 11th International Conference on Communication and Electronics Systems (ICCES 2026). A presentation certificate and a proceedings-formatted PDF were supplied with the project. This repository does not claim a DOI or an IEEE Xplore record because neither is recorded here.

## At a glance

- **HDL:** Verilog
- **Design hierarchy:** `dma_top` → `dma_registers` + `dma_controller`
- **Control:** Three-state FSM (`IDLE`, `TRANSFER`, `COMPLETE`)
- **Data path:** 32-bit words; one word copied per transfer-state clock cycle
- **Memory model:** 256 × 32-bit internal array in the RTL
- **CPU-facing interface:** 4-bit register address, 32-bit write/read data, write enable
- **Completion:** `busy`, `done`, and `interrupt` status/control signals
- **EDA evidence supplied:** Cadence Genus 21.14 reports; Cadence Xcelium waveform; RTL schematics; Innovus physical-layout image

## Results reported by the supplied Genus reports

| Metric | Reported result | Interpretation |
|---|---:|---|
| Cell count | 387 | Genus area report for `dma_top` |
| Cell area | 4415.755 | Technology-library area units; the report does not state a physical unit such as µm² |
| Total power | 3.74269 × 10⁻⁴ W = 0.374269 mW | Reported total in the supplied power report |
| Timing slack | 4126 ps = 4.126 ns | Report says `Path 1: MET (4126 ps)`; this is slack, not the critical-path delay |
| Data path on reported timing path | 1649 ps | Timing report's `Data Path` value for the listed path |

These are results from the supplied reports and should be interpreted in the context of their constraints, libraries, operating conditions, and activity assumptions. See [results analysis](docs/results-analysis.md). The reports are retained verbatim under `reports/synthesis/`.

## Architecture

```text
CPU-style interface
  cpu_addr[3:0], cpu_wdata[31:0], cpu_write
                 │
                 ▼
          ┌───────────────┐
          │ dma_registers │── start, src_addr, dst_addr, length ──┐
          │ register file │                                       ▼
          └───────────────┘                              ┌────────────────┐
                 ▲                                      │ dma_controller │
                 │ cpu_rdata                            │ FSM + pointers │
                 │                                      │ + memory model │
                 │                                      └───────┬────────┘
                 │                                              │
                 └──── status via done/busy                     └─ interrupt
```

The register file accepts configuration writes. The controller captures source, destination, and length when it accepts a start request, copies words from its internal array, advances source/destination pointers, decrements the count, and raises completion indications.

## Repository map

```text
DMA-Controller-RTL-to-GDSII/
├── README.md
├── LICENSE
├── CITATION.cff
├── .gitignore
├── rtl/                         # Synthesizable RTL sources as supplied
├── tb/                          # Original directed testbench
├── sdc/                         # Timing constraints as supplied
├── scripts/                     # Supplied flow command references
├── reports/synthesis/           # Area, power, timing reports and netlist
├── images/                      # Waveform, schematics, layout, certificate
├── docs/
│   ├── architecture.md
│   ├── register-map.md
│   ├── verification.md
│   ├── implementation-flow.md
│   ├── results-analysis.md
│   ├── limitations-and-next-steps.md
│   └── publication.md
└── paper/                       # Citation / publication metadata only
```

## Quick start: simulation

The supplied testbench is written for a simulator supporting Verilog. Example with Icarus Verilog:

```bash
iverilog -g2012 -s tb_dma -o build/dma_sim \
  rtl/dma_top.v rtl/dma_registers.v rtl/dma_controller.v tb/dma_tb.v
vvp build/dma_sim
```

The testbench prints `DMA TEST PASSED` when all eight destination words match their source words. It accesses `dut.ctrl.memory` hierarchically to preload and check the internal memory, so this is a simulation testbench rather than a portable system-level memory-interface test.

## ASIC flow

The repository preserves the provided timing constraints, synthesis reports, and command references. The original run scripts contain tool-flow and path assumptions that depend on a local EDA installation and technology library. They are **reference material, not guaranteed drop-in scripts**. See [implementation flow](docs/implementation-flow.md) before running them.

## Important design scope

This is an educational, single-transfer-engine DMA model with internal behavioral memory. It is not an AXI/AHB bus master and does not include a standard external SRAM/DRAM controller interface, bus arbitration, burst protocol, descriptor engine, or multi-channel scheduling. See [limitations and next steps](docs/limitations-and-next-steps.md).

## Publication and attribution

The project paper lists six authors. Please preserve team attribution when reusing the project. The repository includes a citation record and a publication note, not the full proceedings PDF, to avoid republishing conference-copyrighted content without checking the applicable permission terms. The supplied presentation certificate is included as portfolio evidence; remove it if you prefer not to publish personal identification information.

## License

The source files were supplied by the project team. A permissive license should only be applied if all contributors have agreed to it. The included `LICENSE` therefore marks the repository as **all rights reserved by default** until the authors choose and authorize a license.
