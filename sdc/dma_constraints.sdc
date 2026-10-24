# ==============================
# CLOCK DEFINITION
# ==============================

# Define clock (100 MHz → period = 10 ns)
create_clock -name clk -period 10 [get_ports clk]

# ==============================
# INPUT DELAYS
# ==============================

# Assume inputs arrive 2ns after clock edge
set_input_delay 2 -clock clk [all_inputs]

# ==============================
# OUTPUT DELAYS
# ==============================

# Assume outputs required within 2ns
set_output_delay 2 -clock clk [all_outputs]

# ==============================
# CLOCK UNCERTAINTY (optional but good)
# ==============================

set_clock_uncertainty 0.2 [get_clocks clk]

# ==============================
# DRIVING CELL (optional realistic modeling)
# ==============================

set_driving_cell -lib_cell INVX1 [all_inputs]

# ==============================
# LOAD CAPACITANCE (optional)
# ==============================

set_load 0.1 [all_outputs]
