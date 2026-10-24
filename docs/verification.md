# Functional verification

## Supplied test

`tb/dma_tb.v` drives a 10 ns clock period (`always #5`), asserts reset for 20 ns, initializes memory words 0–7 to values 10–17 through a hierarchical testbench reference, and programs:

| Register | Value |
|---|---:|
| Source (`0x0`) | 0 |
| Destination (`0x1`) | 20 |
| Length (`0x2`) | 8 words |
| Start (`0x3`) | 1 |

It waits for `interrupt`, then compares destination words 20–27 against source words 0–7. It prints `DMA TEST PASSED` if no mismatch is found; otherwise it prints the index of the first mismatch and ends simulation.

## Evidence

- `images/simulation_waveform.jpeg`: supplied simulation waveform screenshot.
- `reports/synthesis/`: supplied synthesis/analysis reports (not functional-simulation logs).

## Scope of existing verification

The supplied test is a single directed eight-word copy test. It does not, by itself, establish coverage for zero length, maximum valid address, out-of-range addresses, overlapping regions, reset during transfer, repeated transfers, start while busy, or all status-read cases. Those should be added as separate tests before describing the design as broadly verified.

## Suggested regression matrix

| Test | Expected behavior | Supplied test? |
|---|---|---|
| Reset clears control/status state | FSM returns to `IDLE`; `busy`, `done`, `interrupt` low | Partly exercised |
| 8-word copy from 0 to 20 | Destination words match source | Yes |
| Length = 0 | No transfer starts | Not explicitly checked |
| Length = 1 | Exactly one word copied | Not checked |
| Multiple consecutive transfers | Each transfer completes with a distinct event | Not checked |
| Invalid source/destination index | Defined error/rejection behavior | Not implemented/tested |
| Overlapping source/destination ranges | Defined behavior documented and checked | Not checked |
| Reset while transfer active | Safe cancellation/restart semantics | Not checked |

The original testbench is retained without behavioral changes. Consider adding a separate improved testbench rather than silently changing the evidence for the original project.
