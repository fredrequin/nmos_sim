
NMOS_SIM - Simulation of old NMOS chip using KiCad and Verilator
================================================================

NMOS_SIM is an attempt to run gate-level simulation of old NMOS chips using KiCad 6.0 and Verilator

Features
--------

- The main focus is Commodore/Amiga NMOS chips
- Uses KiCad 6.0 as a schematics capture tool
- Uses a special KiCad library that contains all the NMOS primitives
- Uses a custom "k2v" tool (KiCad to Verilog) to convert the KiCad netlist into a Verilog file
- Uses Verilator to run the gate-level simulation
- Uses the https://github.com/fredrequin/verilator_helpers repository

Files in this Repository
------------------------

#### README.md

You are reading it right now.

#### k2v_tool/kicad.l

KiCad 6.0 netlist conversion tool lex/flex configuration file

#### k2v_tool/kicad.y

KiCad 6.0 netlist conversion tool yacc/bison configuration file

#### k2v_tool/kicad_st.hpp

C++ structures definition of KiCad netlist objects (sheet, part, component, pin, net, node, ...)

#### k2v_tool/Makefile

Makefile to generate the "k2v" tool

#### nmos_lib/NMOS.kicad_sym

KiCad symbols library that contains all the NMOS primitives

#### nmos_lib/hdl/NMOS_*.v

The same NMOS primitives written in Verilog (for the gate-level simulation)

#### Alice/

Folder containing the KiCad schematics and netlist of Alice/Agnus chip (WIP), it based on this document: https://github.com/nonarkitten/amiga_replacement_project/blob/master/agnus/alice_schematics.pdf

#### verilator/osc_28m.v

"Fake" 28.375160 MHz or 28.636363 Mhz oscillator for the Verilator simulation

#### verilator/Alice_tb.v

Top level testbench file containing the 28 MHz oscillator and Alice/Agnus chip

#### verilator/tb_top.v

Master verilog file that references other verilog files and configures the traces

#### verilator/main.cpp

C++ wrapper for Verilator

#### verilator/Makefile

Makefile to run the Verilator simulation

How to run the simulation
-------------------------

First, clone the repository:
```
git clone --recurse-submodules https://github.com/fredrequin/nmos_sim
```

Then, build the KiCad to Verilog conversion tool:
```
cd nmos_sim/k2v_tool
make
```

Finally, run the simulation:
```
cd ../verilator
make
```

If you change the Alice/Agnus schematics, the KiCad netlist must re-generated (Files->Export->Netlist) and written to "Alice/Alice.net" file.
