###############################################################
# Cadence Genus Synthesis Script for mult32x32_karatsuba4.v
###############################################################

# -------------------------------------------------------------
# Library setup
# -------------------------------------------------------------
set_db init_lib_search_path {/home/install/FOUNDRY/digital/90nm/dig/lib/}
set_db library slow.lib

# -------------------------------------------------------------
# Read and elaborate the design hierarchy
# -------------------------------------------------------------
# Read all submodules first, then the top module
read_hdl {./ aes_decipher_block.v}
read_hdl {./ aes_encipher_block.v}
read_hdl {./aes_inv_sbox.v}
read_hdl {./ aes_sbox.v}
read_hdl {./aes_key_mem.v}
read_hdl {./aes_core.v}
read_hdl {./aes.v}
# -------------------------------------------------------------
# Set the top-level module
# -------------------------------------------------------------
elaborate aes

# -------------------------------------------------------------
# Read timing constraints
# -------------------------------------------------------------
# (Make sure the SDC file exists with proper clock definition)
read_sdc ./tan_aes.sdc

# -------------------------------------------------------------
# Synthesis effort settings
# -------------------------------------------------------------
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

# -------------------------------------------------------------
# Run synthesis flow
# -------------------------------------------------------------
syn_generic
syn_map
syn_opt

# -------------------------------------------------------------
# Write out the synthesized results
# -------------------------------------------------------------
write_hdl > aes_netlist.v
write_sdc > aes_postsyn.sdc

# -------------------------------------------------------------
# Generate reports
# -------------------------------------------------------------
report timing > aes_timing.rpt
report power  > aes_power.rpt
report area   > aes_area.rpt
report gates  > aes_gates.rpt

# -------------------------------------------------------------
# Optional: Launch GUI for post-synthesis inspection
# -------------------------------------------------------------
gui_show

