# Results analysis

Values below are transcribed from the supplied reports rather than independently regenerated.

## Area

The Genus area report lists 387 cells and a total cell area of **4415.755** for `dma_top`. It breaks down into 207 cells / 1475.955 area for `dma_controller` and 180 cells / 2939.800 area for `dma_registers`. The report's area unit is not explicitly identified as µm²; therefore this repository records it as technology-library area units.

## Power

The power report declares its unit as watts and reports a total of **3.74269 × 10⁻⁴ W**, or **0.374269 mW**. The reported subtotal is composed of leakage (2.36651 × 10⁻⁵ W), internal power (2.91412 × 10⁻⁴ W), and switching power (5.91912 × 10⁻⁵ W). The report lists register, logic, and clock categories. The assumptions/activity setup is not fully documented in the supplied artifact, so this number should not be presented as a universal workload-independent power result.

## Timing

The timing report says `Path 1: MET (4126 ps)` and explicitly labels **Slack: 4126 ps**. The path is from `cpu_addr[3]` to `cpu_rdata[2]`, with a reported data-path value of 1649 ps. It includes 2 ns input delay, 2 ns output delay, and 0.2 ns uncertainty in the constraints. Thus 4126 ps is the slack for this reported path, not the critical-path delay. Avoid calling it “4126 ps timing delay.”

## Clock assumptions

The SDC creates a 10 ns clock (100 MHz). The supplied testbench also uses a 10 ns period (`#5` toggle), although the paper text in one section describes a 20 ns / 50 MHz clock. The repository should identify the 10 ns value as the one evidenced by the current RTL testbench and supplied SDC, and flag the paper's discrepancy rather than silently reconciling it.
