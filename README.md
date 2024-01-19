
NMOS_SIM - Simulation of old NMOS chip using KiCad and Verilator
================================================================

NMOS_SIM is an attempt to run gate-level simulation of old NMOS chips by using KiCad 6.0 and Verilator

Features
--------

- The main focus is on Commodore/Amiga NMOS chips
- Uses KiCad 6.0 as a schematics capture tool
- Uses a special KiCad library that contains all the NMOS primitives
- Uses a custom "k2v" tool (KiCad to Verilog) to convert the KiCad netlist into a Verilog file
- Uses Verilator to run the gate-level simulation
- Uses the [verilator_helpers](https://github.com/fredrequin/verilator_helpers) repository

Files in this Repository
------------------------

#### README.md

You are reading it right now.

#### k2v_tool/kicad.l

KiCad 6.0 netlist conversion tool - lex/flex configuration file

#### k2v_tool/kicad.y

KiCad 6.0 netlist conversion tool - yacc/bison configuration file

#### k2v_tool/kicad_st.hpp

C++ structures definition of KiCad netlist objects (sheet, part, component, pin, net, node, ...)

#### k2v_tool/Makefile

Makefile to generate the "k2v" tool

#### nmos_lib/NMOS.kicad_sym

KiCad symbols library that contains all the NMOS primitives

#### nmos_lib/hdl/NMOS_*.v

The same NMOS primitives written in Verilog (for the gate-level simulation)

#### Alice/

Folder containing the KiCad schematics and netlist of Alice/Agnus chip (WIP), it is based on this document: [alice_schematics.pdf](https://github.com/nonarkitten/amiga_replacement_project/blob/master/agnus/alice_schematics.pdf)

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

If you change the Alice/Agnus schematics, the KiCad netlist must re-generated (Files->Export->Netlist) and written to the "Alice/Alice.net" file.

Tips and tricks for KiCad
-------------------------

### Components references

KiCad components references (U.., R.., Q..) are only kept in the Verilog file for complex/clocked primitives.\
For simple primitive, let KiCad do the numbering for you. This does apply for :
- the gates (AND, OR, NAND, NOR, XOR, XNOR, NOT, BUF)
- the PLA structures (NMOS pull-up and NMOS transistor)
- the MUXes

### Bus signals

KiCad generated netlist does not keep the buses defined in the schematics.\
Having individual wires in the Verilog file has an impact on simulation speed and generates VCD traces that are not user friendly.\
To overcome this limitation, some bus directives can be hidden in the sheet's title block : in the comment section.\
For example, if you want to declare DB, HCTR and VCTR as buses, you can write in comment line #5:
```
bus: DB[15:0] VCTR[10:0] NVCTR[10:0]
```

### Sheet's title block fields

Fields "Date", "Revision", "Title" and "Company" should not be left empty because, by default, the KiCad netlist generator does not append an empty string next to these field.\
This prevents the netlist converter tool from running correctly (it will throw a syntax error).

### PLA structures

The netlist converter tool conveniently supports PLA structures by using NMOS "PULLUP" and NMOS "NOT_OC" symbols.
They get translated to this Verilog construct (note the inverted logic):
```
assign <PLA out signal> = (<PLA in 1> | <PLA in 2> |... ) ? 1'b0 : 1'b1;
```
The output wires of the PLA should be named, otherwise the assign statement will be invalid.

### Hierarchical design

The netlist converter tool does support hierarchical design but the result Verilog file shows a flattened design inside a unique module.\
It is planned to have one Verilog module per sheet later on.

### Labels

Labels on the wires are useful to give a meaningful name for a Verilog wire. If a wire does not have a label, it gets the name of the output driving it. For PLAs, it is mandatory to specify a label for the output wires.\
For the moment, hierarchical labels are mostly useful for KiCad hierarchical design. They are also useful to name Verilog wires. In the future, they will appear on the Verilog sub-modules interfaces.\
Global labels will appear on the Verilog top level interface as external pins.
