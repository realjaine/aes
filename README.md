
# RTL-to-GDSII Implementation of a 128-bit AES Crypto Core


[![Language](https://img.shields.io/badge/Language-Verilog-yellow.svg)](https://en.wikipedia.org/wiki/Verilog)
[![Tools](https://img.shields.io/badge/Tools-Cadence%20Genus%20%7C%20Innovus-brightgreen.svg)](https://www.cadence.com)
[![Technology](https://img.shields.io/badge/Technology-90nm-blue.svg)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

*A complete ASIC implementation of the AES-128 encryption core from RTL to GDSII*

[Features](#-features) • [Architecture](#-design-architecture) • [Results](#-performance-summary) • [Getting Started](#-repository-structure)

---

## 📖 Overview

This project implements a complete RTL-to-GDSII flow for a **128-bit AES (Advanced Encryption Standard)** cryptography core. The design is implemented in Verilog HDL and synthesized using a **90nm CMOS technology library**, achieving a fully verified, tape-out ready GDSII layout.

### ✨ Key Highlights

- ✅ **Complete AES-128 Implementation**: Both encryption and decryption in hardware
- ✅ **Industry-Standard ASIC Flow**: RTL → Synthesis → P&R → Signoff
- ✅ **Timing Closure Achieved**: 100 MHz operation with positive slack
- ✅ **Verification Complete**: DRC clean, Antenna clean, LEC verified
- ✅ **Low Power Design**: 10.80 mW total power consumption

---

## 🏗️ Design Architecture

The core consists of a modular hierarchy with the following key components:

```
aes.v (Top Module)
├── aes_core.v (Control Logic & FSM)
├── aes_key_mem.v (Key Storage)
├── aes_encipher_block.v (Encryption Datapath)
├── aes_decipher_block.v (Decryption Datapath)
├── aes_sbox.v (Forward Substitution Box)
└── aes_inv_sbox.v (Inverse Substitution Box)
```


## How it is working?

                         AES-128 — BLOCK DIAGRAM

┌───────────────────────────────────────────────────────────────┐
│                        PLAINTEXT                              │
│                     (128 bits / 16 bytes)                     │
└───────────────────────────┬───────────────────────────────────┘
                            │
                 ┌───────────▼───────────┐
                 │   INITIAL ROUND       │
                 │     AddRoundKey       │  ◄── RoundKey[0]
                 │ (State ← State ⊕ RK0) │
                 └───────────┬───────────┘
                            │
         ┌──────────────────▼──────────────────┐
         │         ROUNDS 1 – 9 (×9)           │
         │────────────────────────────────────│
         │  SubBytes     →  Nonlinear S-box    │
         │  ShiftRows    →  Row permutation    │
         │  MixColumns   →  Column mixing      │
         │  AddRoundKey  →  XOR with RK[i]     │
         └──────────────────┬──────────────────┘
                            │
                 ┌──────────▼──────────┐
                 │     FINAL ROUND     │
                 │  SubBytes           │
                 │  ShiftRows          │
                 │  AddRoundKey(RK10)  │  (No MixColumns)
                 └──────────┬──────────┘
                            │
                 ┌──────────▼──────────┐
                 │     CIPHERTEXT      │
                 │  (128 bits output)  │
                 └─────────────────────┘


                          KEY EXPANSION

┌───────────────────────────────────────────────────────────────┐
│                        CIPHER KEY                             │
│                     (128 bits / 16 bytes)                     │
└───────────────────────────┬───────────────────────────────────┘
                            │
                 ┌──────────▼──────────┐
                 │     KEY EXPANSION   │
                 │  (KeySchedule)      │
                 │  Generates:         │
                 │   RoundKey[0..10]   │
                 │  using:             │
                 │   - RotWord         │
                 │   - SubWord         │
                 │   - Rcon            │
                 └──────────┬──────────┘
                            │
     ┌─────────────────────────────────────────────────────────┐
     │  RoundKey Mapping:                                     │
     │   RK[0]  → Initial AddRoundKey                         │
     │   RK[1]  → Round 1 AddRoundKey                         │
     │   RK[2]  → Round 2 AddRoundKey                         │
     │   ...                                                  │
     │   RK[9]  → Round 9 AddRoundKey                         │
     │   RK[10] → Final Round AddRoundKey                     │
     └─────────────────────────────────────────────────────────┘


Notes:
 - AES-128 operates on a 4×4 byte matrix (the State).
 - Total: 10 rounds = 1 initial + 9 main + 1 final.
 - Each round transforms the State with byte substitution,
   shifting, mixing, and key addition.
 - KeyExpansion generates 11 round keys for all AddRoundKey steps.

### Interface Specifications

| Signal | Width | Direction | Description |
|--------|-------|-----------|-------------|
| `clk` | 1 | Input | System clock (100 MHz) |
| `reset_n` | 1 | Input | Active-low asynchronous reset |
| `cs` | 1 | Input | Chip select |
| `we` | 1 | Input | Write enable |
| `address` | 8 | Input | Register address |
| `write_data` | 32 | Input | Data to write |
| `read_data` | 32 | Output | Data read from registers |
| `ready` | 1 | Output | Core ready indicator |
| `valid` | 1 | Output | Output data valid |

---

## 🚀 VLSI Design Flow

This project follows the complete industry-standard ASIC design flow:

| Stage | Tool | Key Deliverables |
|-------|------|------------------|
| **RTL Design** | Verilog HDL | Synthesizable RTL modules |
| **Logic Synthesis** | Cadence Genus | Gate-level netlist, Area/Timing/Power reports |
| **Formal Verification** | Cadence Conformal | Logic Equivalence Check (LEC) |
| **Floorplanning** | Cadence Innovus | Floorplan with power grid |
| **Placement** | Cadence Innovus | Optimized cell placement |
| **Clock Tree Synthesis** | Cadence Innovus | Balanced clock tree |
| **Routing** | Cadence Innovus | Detailed routing completion |
| **Signoff** | Cadence Innovus | DRC/LVS/Antenna verification |
| **GDSII Generation** | Cadence Innovus | Final tape-out ready layout |

---

## 📊 Performance Summary

### Design Metrics at a Glance

| Metric | Value | Status |
|--------|-------|--------|
| **Technology Node** | 90nm CMOS | — |
| **Operating Frequency** | 100 MHz (10 ns period) | ✅ Target met |
| **Total Area** | 129,749 μm² | Optimized |
| **Cell Count** | 15,491 standard cells | — |
| **Power Consumption** | 10.80 mW | ✅ Low power |
| **Timing Slack (WNS)** | +2.190 ns (post-placement) | ✅ Positive |
| **Setup Violations** | 0 | ✅ Clean |
| **DRC Violations** | 0 | ✅ Clean |
| **Antenna Violations** | 0 | ✅ Clean |

### Power Breakdown (Genus Synthesis)

| Component | Power (mW) | Percentage |
|-----------|------------|------------|
| Internal Power | 8.789 | 81.4% |
| Switching Power | 1.371 | 12.7% |
| Leakage Power | 0.642 | 5.9% |
| **Total** | **10.80** | **100%** |

### Critical Path Analysis

**Pre-Layout (Genus):**
- Launch: `core/aes_core_ctrl_reg_reg[1]/CK`
- Capture: `core/keymem_key_mem_reg[13][68]/SI`
- Data Arrival: 5.404 ns
- Slack: **+4.130 ns** ✅

**Post-Placement (Innovus):**
- Launch: `init_reg_reg/Q`
- Capture: `core/keymem_key_mem_reg[13][61]/SI`
- Data Arrival: 7.314 ns
- Slack: **+2.190 ns** ✅

---

## 📸 Design Visualizations

### Simulation Waveforms

<img width="1728" alt="Functional simulation showing AES operations" src="https://github.com/user-attachments/assets/be111efb-87ee-4b95-af68-e71803b43f49" />

*Functional verification waveforms demonstrating encryption and decryption cycles*

---

### Synthesis Results

https://github.com/user-attachments/assets/aadf8c12-3963-4d89-b23b-a4c03144fd3c

*Cadence Genus synthesis interface with compiled design*

---

### Floorplan

<img width="1316" alt="Physical floorplan" src="https://github.com/user-attachments/assets/f1666895-ecf5-44c1-a890-37cccbb23d57" />

*Initial floorplan showing core area, I/O placement, and power grid*

---

### Placement

<img width="1419" alt="Standard cell placement" src="https://github.com/user-attachments/assets/c7090b7b-ec85-493e-983f-636417d1ba85" />

*Optimized standard cell placement after detailed placement*

---

### Clock Tree Synthesis

<img width="1338" alt="Clock tree structure" src="https://github.com/user-attachments/assets/c71fba2b-a214-4790-bf19-7d60b1090399" />

*Balanced clock distribution network ensuring uniform clock arrival*

---

### Final GDSII Layout

<img width="1406" alt="Complete GDSII layout" src="https://github.com/user-attachments/assets/2568190e-f0f6-4135-a140-4e8db344cb55" />

<img width="1486" alt="Zoomed layout view" src="https://github.com/user-attachments/assets/4cb47634-b11d-4f47-8467-ac8d6a62f953" />

*Final tape-out ready GDSII layout with all metal layers*

---

## 💻 Technology Stack

| Category | Tools & Technologies |
|----------|---------------------|
| **HDL** | Verilog HDL (IEEE 1364-2001) |
| **Simulation** | Cadence Xcelium |
| **Synthesis** | Cadence Genus 20.11 |
| **Place & Route** | Cadence Innovus 20.14 |
| **Formal Verification** | Cadence Conformal LEC |
| **Technology Library** | 90nm CMOS Standard Cells |
| **Operating System** | Linux (CentOS/RHEL) |

---

## 📂 Repository Structure

```
aes-crypto-core/
├── rtl/                      # RTL Verilog source files
│   ├── aes.v                 # Top-level wrapper
│   ├── aes_core.v            # Core control logic
│   ├── aes_key_mem.v         # Key memory
│   ├── aes_encipher_block.v  # Encryption datapath
│   ├── aes_decipher_block.v  # Decryption datapath
│   ├── aes_sbox.v            # Forward S-box
│   └── aes_inv_sbox.v        # Inverse S-box
│
├── synthesis/                # Synthesis flow
│   ├── scripts/              # TCL synthesis scripts
│   ├── reports/              # Area/Timing/Power reports
│   │   ├── aes_area.rpt
│   │   ├── aes_timing.rpt
│   │   └── aes_power.rpt
│   └── netlist/              # Gate-level netlist
│
├── pnr/                      # Place & Route flow
│   ├── scripts/              # Innovus TCL scripts
│   ├── reports/              # P&R reports
│   │   ├── aes_preCTS.summary
│   │   ├── aes.drc.rpt
│   │   └── aes.antenna.rpt
│   └── gds/                  # GDSII layout
│       └── aes.gds
│
├── verification/             # Verification files
│   ├── testbench/            # Simulation testbenches
│   └── formal/               # Formal verification
│
├── docs/                     # Additional documentation
├── img/                      # Screenshots and figures
└── README.md                 # This file
```

---

## 🎯 Learning Outcomes

This project demonstrates proficiency in:

1. ✅ **RTL Design**: Complex multi-module Verilog implementation
2. ✅ **Digital Design**: FSM-based control and datapath architecture
3. ✅ **Synthesis**: Logic optimization and technology mapping
4. ✅ **Physical Design**: Floorplanning, placement, CTS, and routing
5. ✅ **Timing Analysis**: Static timing analysis and timing closure
6. ✅ **Power Analysis**: Power estimation and optimization
7. ✅ **Verification**: Functional simulation and formal verification
8. ✅ **Signoff**: DRC, LVS, and antenna checks

---

## 🤝 Contributing

Contributions are welcome! Here are some areas for improvement:

### Potential Enhancements

- 🔧 Port to advanced technology nodes (65nm, 45nm, 28nm)
- 🔧 Implement additional AES modes (CBC, CTR, GCM)
- 🔧 Add FPGA synthesis and testing
- 🔧 Perform side-channel attack analysis
- 🔧 Optimize for ultra-low power operation
- 🔧 Compare with other crypto cores (PRESENT, ChaCha20)

### How to Contribute

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit changes: `git commit -m 'Add feature'`
4. Push to branch: `git push origin feature-name`
5. Submit a pull request

---

## 📚 References

1. **FIPS 197** - Advanced Encryption Standard (AES), NIST
2. **Strombergson, J.** - Original AES Core Implementation
3. **Cadence Design Systems** - Genus & Innovus User Guides
4. **Rabaey, J. et al.** - *Digital Integrated Circuits*, Pearson
5. **Weste, N. & Harris, D.** - *CMOS VLSI Design*, Addison-Wesley

---

## 🎓 Academic Information

| | |
|---|---|
| **Project** | VLSI System Design Course Project |
| **Course Code** | EC-307 |
| **Institution** | IIITDM Kurnool |
| **Department** | Electronics and Communication Engineering |
| **Semester** | Odd Semester 2025 |
| **Instructor** | Dr. P. Ranga Babu |
| **Developer** | Tanmay Jain (123ec0025) |

---

## 📧 Contact

**Tanmay Jain**  
B.Tech, Electronics and Communication Engineering  
Indian Institute of Information Technology, Design and Manufacturing (IIITDM) Kurnool

- 📧 Email: 123ec0025@iiitk.ac.in
- 💼 LinkedIn: https://www.linkedin.com/in/tanmay-jain-838b19261?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app
- 🐙 GitHub: https://github.com/realjaine

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

Special thanks to:

- **Dr. P. Ranga Babu** - Course instructor and mentor
- **Joachim Strombergson** - Original AES core design
- **Cadence Design Systems** - EDA tools and support
- **IIITDM Kurnool** - Infrastructure and resources

---

<div align="center">

**⭐ If you found this project helpful, please consider giving it a star! ⭐**

---

*Developed with 💙 for learning and research*

**© 2025 Tanmay Jain • IIITDM Kurnool**

</div>
