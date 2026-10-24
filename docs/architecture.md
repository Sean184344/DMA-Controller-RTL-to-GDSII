# Architecture

## Functional blocks

### `dma_top`

Structural top-level wrapper. It exposes `clk`, active-high asynchronous reset `rst`, a 4-bit CPU register address, 32-bit CPU write/read data, `cpu_write`, and `interrupt`. It instantiates `dma_registers` and `dma_controller` and wires their control/status signals together.

### `dma_registers`

Stores source address, destination address, transfer length, and a one-cycle start request. Writes occur on the rising clock edge while `cpu_write` is high. The read mux is combinational. Status readback packs `done` into bit 1 and `busy` into bit 0.

### `dma_controller`

Contains the three-state FSM, source/destination pointers, a word count, and a behavioral 256 × 32-bit array. In `TRANSFER`, it schedules `memory[dst] <= memory[src]`, increments both pointers, and decrements the count. When the old count is 1, it transitions to `COMPLETE`; the following state asserts `done` and `interrupt` and clears `busy`.

## FSM

| State | Encoded value | Main behavior |
|---|---|---|
| `IDLE` | `2'b00` | Waits for `start && length != 0`; captures transfer parameters |
| `TRANSFER` | `2'b01` | Copies one word per clock and updates pointers/count |
| `COMPLETE` | `2'b10` | Asserts `done` and `interrupt`, clears `busy`, returns to `IDLE` |

The RTL's `done` and `interrupt` signals are cleared in `IDLE`, so they are intended as brief completion indications. Verify pulse width and back-to-back operation in simulation if modifying the controller.

## Data movement semantics

The RTL uses array indices directly: `memory[dst] <= memory[src]`. These are word indices into a 256-entry array, not byte addresses. The register names `src_addr` and `dst_addr` are 32 bits wide, but the implementation does not convert byte addresses into word indices or check that indices are within 0–255.
