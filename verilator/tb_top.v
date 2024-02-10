
// Trace configuration
// -------------------
`verilator_config

// NMOS library :
//===============
tracing_off -file "../nmos_lib/hdl/NMOS_BIDIR.v"
tracing_off -file "../nmos_lib/hdl/NMOS_CLOCKGEN.v"
tracing_off -file "../nmos_lib/hdl/NMOS_CMPC.v"
tracing_off -file "../nmos_lib/hdl/NMOS_CMPD.v"
tracing_off -file "../nmos_lib/hdl/NMOS_CMPM.v"
tracing_off -file "../nmos_lib/hdl/NMOS_CMPQ.v"
tracing_off -file "../nmos_lib/hdl/NMOS_CT.v"
tracing_off -file "../nmos_lib/hdl/NMOS_DFF.v"
tracing_off -file "../nmos_lib/hdl/NMOS_DFFR.v"
tracing_off -file "../nmos_lib/hdl/NMOS_DFFSR.v"
tracing_off -file "../nmos_lib/hdl/NMOS_DFFN.v"
tracing_off -file "../nmos_lib/hdl/NMOS_DFFNR.v"
tracing_off -file "../nmos_lib/hdl/NMOS_DFFNSR.v"
tracing_off -file "../nmos_lib/hdl/NMOS_DEMUX8.v"
tracing_off -file "../nmos_lib/hdl/NMOS_FAINB.v"
tracing_off -file "../nmos_lib/hdl/NMOS_FAMUX.v"
tracing_off -file "../nmos_lib/hdl/NMOS_LB.v"
tracing_off -file "../nmos_lib/hdl/NMOS_LB2.v"
tracing_off -file "../nmos_lib/hdl/NMOS_LDR.v"
tracing_off -file "../nmos_lib/hdl/NMOS_LD2R.v"
tracing_off -file "../nmos_lib/hdl/NMOS_LD3R.v"
tracing_off -file "../nmos_lib/hdl/NMOS_LT.v"
tracing_off -file "../nmos_lib/hdl/NMOS_PASS.v"
tracing_off -file "../nmos_lib/hdl/NMOS_SE.v"
tracing_off -file "../nmos_lib/hdl/NMOS_SR.v"
tracing_off -file "../nmos_lib/hdl/NMOS_SR2.v"
tracing_off -file "../nmos_lib/hdl/NMOS_TR.v"

// Alice chip :
//=============
tracing_on  -file "Alice.v"

// Test bench :
//=============
tracing_off -file "osc_28m.v"
tracing_on  -file "Alice_tb.v"

`verilog

`define CLK_GEN Alice_tb.X1

`include "../nmos_lib/hdl/NMOS_BIDIR.v"
`include "../nmos_lib/hdl/NMOS_CLOCKGEN.v"
`include "../nmos_lib/hdl/NMOS_CMPC.v"
`include "../nmos_lib/hdl/NMOS_CMPD.v"
`include "../nmos_lib/hdl/NMOS_CMPM.v"
`include "../nmos_lib/hdl/NMOS_CMPQ.v"
`include "../nmos_lib/hdl/NMOS_CT.v"
`include "../nmos_lib/hdl/NMOS_DFF.v"
`include "../nmos_lib/hdl/NMOS_DFFR.v"
`include "../nmos_lib/hdl/NMOS_DFFSR.v"
`include "../nmos_lib/hdl/NMOS_DFFN.v"
`include "../nmos_lib/hdl/NMOS_DFFNR.v"
`include "../nmos_lib/hdl/NMOS_DFFNSR.v"
`include "../nmos_lib/hdl/NMOS_DEMUX8.v"
`include "../nmos_lib/hdl/NMOS_FAINB.v"
`include "../nmos_lib/hdl/NMOS_FAMUX.v"
`include "../nmos_lib/hdl/NMOS_LB.v"
`include "../nmos_lib/hdl/NMOS_LB2.v"
`include "../nmos_lib/hdl/NMOS_LDR.v"
`include "../nmos_lib/hdl/NMOS_LD2R.v"
`include "../nmos_lib/hdl/NMOS_LD3R.v"
`include "../nmos_lib/hdl/NMOS_LT.v"
`include "../nmos_lib/hdl/NMOS_PASS.v"
`include "../nmos_lib/hdl/NMOS_SE.v"
`include "../nmos_lib/hdl/NMOS_SR.v"
`include "../nmos_lib/hdl/NMOS_SR2.v"
`include "../nmos_lib/hdl/NMOS_TR.v"

/* verilator lint_off PINMISSING */
`include "Alice.v"
/* verilator lint_on PINMISSING */

`include "osc_28m.v"
`include "Alice_tb.v"
