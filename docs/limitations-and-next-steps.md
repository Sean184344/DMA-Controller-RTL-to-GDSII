# Limitations and next steps

This repository documents the supplied implementation; the items below are not claimed as completed features.

## Current limitations visible in the RTL

1. **Behavioral internal memory:** the controller owns a `reg [31:0] memory [0:255]` array. There is no external SRAM/DRAM request/response interface.
2. **Index bounds:** source and destination are 32-bit values used directly as array indices; the controller does not reject indices above 255.
3. **Word-index semantics:** the design increments addresses by one per word. It does not implement byte addressing or alignment checks.
4. **Limited verification:** the supplied test checks one eight-word transfer only.
5. **No bus protocol:** there is no AXI/AHB/APB master interface, burst protocol, bus arbitration, or transaction backpressure.
6. **No explicit error status:** invalid requests do not produce an error code or interrupt cause.
7. **Start while busy:** there is no explicit queue or rejection response for a new start request while a transfer is active.
8. **Memory initialization:** the RTL initializes the memory array in an `initial` loop for demonstration; ASIC implementation support/meaning depends on the target flow and memory inference strategy.

## Recommended extensions

- Add address bounds and zero-length handling with explicit status/error reporting.
- Separate the DMA engine from a memory model using request/response handshakes.
- Add a scoreboard-based testbench and directed/random tests for corner cases.
- Define behavior for overlapping ranges and reset during an active transfer.
- Add assertions for FSM legality, pointer/count behavior, and one-cycle completion signals.
- Re-run synthesis with documented library, constraints, and activity assumptions; preserve scripts and logs that reproduce each report.
- For a more realistic SoC project, add an AXI4-Lite configuration interface and an AXI4 memory-mapped master with burst transfers and response handling.
