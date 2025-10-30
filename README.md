AES-128/256 ASIC Crypto Core
A full-featured, hardware-oriented implementation and design flow for AES-128 and AES-256 encryption/decryption. Built for ASIC tapeout with simulation, synthesis, and layout using Xilinx Vivado and Cadence Genus/Innovus.

✨ What is AES?
Advanced Encryption Standard (AES) is a symmetric-key algorithm used worldwide for secure data encryption. Its main highlights:

Block cipher: Operates on 128-bit data blocks.

Key sizes: Supports 128-bit and 256-bit keys.

Rounds: 10 (AES-128) or 14 (AES-256) transformation rounds.

AES consists of the following steps per round (except first/last):

SubBytes: Substitute each byte via S-box.

ShiftRows: Permute bytes in each row.

MixColumns: Mix columns via linear transformation (not in last round).

AddRoundKey: XOR with expanded round key.

📋 AES Algorithm Block Diagram
![AES Algorithm Structure](

<!-- Upload aes_algorithm.png for a visual of the block cipher process -->
📝 AES Single Round Block Diagram
![AES Single Round](images/aes_single_round.png aes_single_round.png showing the SubBytes, ShiftRows, MixColumns, AddRoundKey sequence -->

🛠 Project Workflow
RTL Development (Verilog)

Simulation/Verification (Vivado, NIST vectors)

ASIC Synthesis (Cadence Genus)

Physical Layout (Cadence Innovus)

DRC/LVS Verification

![Design Workflow]( Upload workflow.png for the overall design process -->

🔗 Module Hierarchy & Architecture
text
aes.v               Top-level wrapper, memory-mapped
└─ aescore.v           Main AES core
   ├─ aesencipherblock.v   Encryption datapath
   ├─ aesdecipherblock.v   Decryption datapath
   ├─ aeskeymem.v          Key schedule expansion
   ├─ aessbox.v            Substitute box (S-Box)
   └─ aesinvsbox.v         Inverse S-Box
📐 Top Module Architecture Diagram
![AES Top Module Block Diagram](

<!-- Upload block_diagram.png visualizing your RTL hierarchy -->
🚀 Vivado Simulation Testing
Testbench: Comprehensive, based on NIST FIPS-197 standard vectors (128, 256-bit).

Validation: ECB mode for both encryption and decryption.

Example Output:
![Vivado Simulation Waveform](

![Vivado TCL Output](

🏭 Cadence Genus Synthesis
Inputs: All Verilog modules, timing constraints (SDC).

Process: Batch TCL script for synthesis, area and timing optimization.

Example Result:
![Genus schematic](

🗺️ Physical Design (Innovus)
Procedure: Netlist importation, floorplanning, placement, routing.

Verification: DRC, LVS, timing.

Visuals:
![Innovus first layout](

![DRC Results](

![Final layout](

📂 File Overview
aes.v — Top module, memory-mapped interface

aescore.v — Main controller

aesencipherblock.v — Encryption datapath

aesdecipherblock.v — Decryption datapath

aeskeymem.v — Key expansion/storage

aessbox.v — S-Box

aesinvsbox.v — Inverse S-Box

tbaes.v — Testbench (NIST vectors)

genus_script.tcl — Genus synthesis script

tanaes.sdc — Timing constraints

🔒 Features
Fully synchronous AES design

Memory-mapped register interface

Parameterized for both 128-bit and 256-bit keys

Both encipher and decipher paths

Area and timing optimized

✅ Results Summary
Metric	Result
Functional	NIST FIPS197 verified
Frequency	100 MHz (target met)
Synthesis	Area/power optimized
DRC/LVS	Passed
Test Status	All cases success (128/256 bit)
📜 Licensing
BSD/ISC-style license. See individual Verilog files for full statements.

⚡ Quick Start
AES Top-Level Example:

verilog
module aes (
    input wire clk,
    input wire resetn,
    input wire cs,
    input wire we,
    input wire [7:0] address,
    input wire [31:0] writedata,
    output wire [31:0] readdata
);
// ... implementation ...
endmodule
🛠 Dependencies
Xilinx Vivado (simulation)

Cadence Genus, Innovus (synthesis/layout)

Standard Verilog toolchain

📁 Image Placement
Upload required diagrams/screenshots to /images directory:

aes_algorithm.png

aes_single_round.png

workflow.png

block_diagram.png

waveform.png

vivadotcl.png

guischematic.png

firstlay.png

drc.png

layout.png

Diagrams will render in the README once images are uploaded. If missing, “not found” displays.

