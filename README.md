# Spartan6 – DSP48A1 Slice Design

## 📌 Project Overview
This repository delivers a complete implementation of the **DSP48A1 slice** for the Xilinx Spartan-6 FPGA. It includes **RTL design**, **simulations**, and **full FPGA flow**, showcasing functionality such as multiply, add, subtract, and accumulation operations using both Verilog and VHDL.

---

## ✨ Features
- Parameterized RTL implementation supporting arithmetic operations  
- RTL simulation and functional verification via **QuestaSim**  
- Full Vivado flow: elaboration → synthesis → implementation → timing closure  
- Pipeline registers, carry-in/out, and optional register stages for A, B, C, D, M, P paths  
- Clean synthesis with no critical warnings or errors  

---

## 🛠 Tools Used
| Component              | Tool            |
|------------------------|-----------------|
| Simulation             | QuestaSim       |
| Synthesis & Implementation | Xilinx Vivado |
| Linting (optional)     | QuestaLint      |

---

## 🛠 Tools
- **QuestaSim** — Simulation  
- **QuestaLint** — Linting  
- **Xilinx Vivado** — Synthesis & Implementation  

---

## 📄 Documentation
The full design documentation can be found in **[DSP48A1_Report.pdf](./DOCS/DSP48A1_Report.pdf)** and includes:

- RTL design  
- Testbench description  
- Simulation results  
- DO file  
- Constraint file  
- RTL schematic  
- Synthesis report  
- Implementation report  
- Timing analysis  
- Device utilization  
- Linting with **0 errors and warnings**  

---

## 📂 Design Files
- **[Spartan6.v](./RTL/Spartan6.v)** — Top-level Verilog module for DSP48A1 slice implementation  
- **[Spartan6_tb.v](./Testbench/Spartan6_tb.v)** — Verilog testbench for simulation and verification  
- **[run_Spartan6.do](./Do_Files/run_Spartan6.do)** — Script for automating the simulation process  
