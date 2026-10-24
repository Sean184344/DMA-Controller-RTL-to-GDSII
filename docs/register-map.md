# CPU register map

The CPU-style interface uses `cpu_addr[3:0]` to select registers. Writes are synchronous; reads are combinational.

| Address | Name | Access | Meaning |
|---:|---|---|---|
| `0x0` | `SRC_ADDR` | Read/write | Source word index captured at transfer start |
| `0x1` | `DST_ADDR` | Read/write | Destination word index captured at transfer start |
| `0x2` | `LENGTH` | Read/write | Number of 32-bit words to copy |
| `0x3` | `START` | Write-only | `cpu_wdata[0]` requests start; the RTL auto-clears `start` on the next clock unless rewritten |
| `0x4` | `STATUS` | Read-only | `{30'b0, done, busy}`; `busy` is bit 0, `done` is bit 1 |

Other addresses return zero. A zero transfer length does not start a transfer because the controller checks `length != 0` in `IDLE`.

**Addressing caveat:** although register names say “address,” the internal behavioral memory is indexed by 32-bit values used directly as array indices. For the supplied array, valid indices are 0 through 255. Out-of-range access is not guarded in the RTL.
