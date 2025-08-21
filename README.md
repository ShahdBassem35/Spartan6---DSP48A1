Spartan6 – DSP48A1 Slice Design
Project Overview

This repository delivers a complete implementation of the DSP48A1 slice for the Xilinx Spartan-6 FPGA. It includes RTL design, simulations, and full FPGA flow, showcasing functionality such as multiply, add, subtract, and accumulation operations using both Verilog and VHDL.

Features

Parameterized RTL implementation supporting arithmetic operations

RTL simulation and functional verification via QuestaSim

Full Vivado flow: elaboration → synthesis → implementation → timing closure

Pipeline registers, carry-in/out, and optional register stages for A, B, C, D, M, P paths

Clean synthesis with no critical warnings or errors

Tools Used
Component	Tool
Simulation	QuestaSim
Synthesis & Implementation	Xilinx Vivado
(Optional) Linting	QuestaLint
Repository Structure
Spartan6---DSP48A1/
├── RTL/           # Verilog/VHDL source files
├── Testbench/     # Verification files and testbenches
├── Do_Files/      # Scripts for QuestaSim automation
├── constraints/   # XDC constraint files
├── DOCS/          # Documentation such as design reports or PDFs

Getting Started

Clone the repository:

git clone https://github.com/ShahdBassem35/Spartan6---DSP48A1.git
cd Spartan6---DSP48A1


Simulate in QuestaSim:

cd Do_Files
vsim -do run.do


Synthesize & implement using Vivado:

Open the RTL files in Vivado

Use constraints/*.xdc for pin/timing constraints

Run through the full flow to generate implementation reports and timing closure

Learning Outcomes

Gained hands-on experience with DSP48A1 architecture, including pipelining and operation modes

Practiced RTL design and verification workflows in a real-world FPGA context

Improved understanding of timing analysis, synthesis constraints, and resource utilization in FPGAs
