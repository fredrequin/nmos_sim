# Verilog top module
TOP_FILE = Alice_tb

# Folders
OUT_CPP = obj_dir
DESIGN  = $(realpath ../Alice)
HELPERS = $(realpath ../verilator_helpers)
NMOS    = $(realpath ../nmos_lib/hdl)

# Tools
K2V  = ../k2v_tool/k2v
MAKE = make -j4

# Executable
EXE_FILE = V$(TOP_FILE)

# C++ support files
CPP_FILES =\
 $(HELPERS)/clock_gen/clock_gen.cpp\
 main.cpp

# Options for Verilator
VERILATOR_OPT =\
 --cc\
 --no-decoration\
 --output-split 20000\
 --output-split-ctrace 10000\
 --Wno-UNUSED\
 -O3

# Options for GCC compiler
COMPILE_OPT =\
 -CFLAGS -DVM_PREFIX=V$(TOP_FILE)\
 -CFLAGS -Wno-attributes\
 -CFLAGS -O3\
 -CFLAGS -iquote$(HELPERS)\
 -CFLAGS -iquote..

# Tracing
FST ?= 0
VCD ?= 1
ifeq ($(FST), 1)
  TRACE_OPT = --trace-fst --no-trace-params --trace-max-array 64
else
  ifeq ($(VCD), 1)
    TRACE_OPT = --trace --no-trace-params --trace-max-array 64
  endif
endif

# Clock signals
CLOCK_OPT =\
 -clk v.main_clk

.PHONY: convert verilate simulate

all: convert verilate simulate

# Kicad -> Verilog conversion
convert: Alice.v

# Executable generation
verilate: $(OUT_CPP)/$(EXE_FILE)

# Run simulation
simulate: 
	$(OUT_CPP)/$(EXE_FILE) +msec=33 +chip=ntsc

# Convert Kicad netlist into Verilog
Alice.v: $(DESIGN)/Alice.net
	$(K2V) $(DESIGN)/Alice.net Alice.v

# Convert Verilog into C++
$(OUT_CPP)/$(EXE_FILE).mk: tb_top.v Alice_tb.v Alice_clk_gen.v osc_28m.v Alice.v $(NMOS)/*.v $(CPP_FILES)
	verilator $< $(VERILATOR_OPT) $(COMPILE_OPT) $(TRACE_OPT) $(CLOCK_OPT) --top-module $(TOP_FILE) --exe $(CPP_FILES) verilated_dpi.cpp

# Create an executable from the C++ files
$(OUT_CPP)/$(EXE_FILE): $(OUT_CPP)/$(EXE_FILE).mk $(CPP_FILES)
	cd $(OUT_CPP) && $(MAKE) VM_PARALLEL_BUILDS=1 -f $(EXE_FILE).mk

clean:
	@rm -rf $(OUT_CPP)
	@rm -rf Alice.v
