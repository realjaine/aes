###############################################################
# AES Core Synthesis Constraints File
# For: aes.v (Top module)
# Tool: Cadence Genus
# Author: Suraj Kumar Pal
# Description: Timing, clock, and design constraints for AES
###############################################################

# =============================================================
# Design environment setup
# =============================================================

# Define top-level design name
set DESIGN_NAME aes

# =============================================================
# Clock Definition
# =============================================================

# Define main clock — assume 100 MHz (period = 10 ns)
create_clock -name clk -period 10 [get_ports clk]

# Define uncertainty (clock jitter + skew)
set_clock_uncertainty 0.2 [get_clocks clk]

# =============================================================
# Input and Output Delays
# =============================================================

# Assume inputs arrive 2 ns after clock edge (input delay)
set_input_delay 2 -clock [get_clocks clk] [all_inputs]

# Assume outputs required 2 ns before next clock edge (output delay)
set_output_delay 2 -clock [get_clocks clk] [all_outputs]

# =============================================================
# Reset and Control Signals
# =============================================================

# Reset is asynchronous and active low
set_false_path -from [get_ports reset_n]

# Control signals (not timing-critical)
set_false_path -from [get_ports {cs we address write_data}]
set_false_path -to   [get_ports {read_data}]

# =============================================================
# Design Rules and Limits
# =============================================================

# Limit transition time and fanout to keep design clean
set_max_transition 0.5 [current_design]
set_max_fanout 10 [current_design]
set_max_capacitance 1.0 [current_design]

# =============================================================
# Operating Conditions and Library (optional section)
# =============================================================
# These are generally defined in Genus .tcl script, but can be included here:
# set_operating_conditions typical
# set_wire_load_model -name typical

# =============================================================
# End of File
# =============================================================
puts "INFO: AES SDC constraints successfully loaded for synthesis."

