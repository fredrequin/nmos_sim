// Macros to build include file name
#ifndef symbols_header
#define _quoted_string(x) #x
#define quoted_string(x) _quoted_string(x)
#define _symbols_header(x) _quoted_string(x##__Syms.h)
#define symbols_header(x) _symbols_header(x)
#endif
// Top level
#include symbols_header(VM_PREFIX)
// Helpers
#include "../verilator_helpers/clock_gen/clock_gen.h"
#include "alice_ff.h"

#include <ctime>

#if VM_TRACE
#include "verilated_vcd_c.h"
#endif

// Period for a ~141.875800 MHz clock
#define PERIOD_PAL_142MHz_ps       ((vluint64_t)7048)
// Period for a ~143.181815 MHz clock
#define PERIOD_NTSC_143MHz_ps      ((vluint64_t)6984)


// Top level (global)
VM_PREFIX* top;

// Clocks generation (global)
ClockGen *clk;

// Chip registers access (global)
ff_ptr_t *reg;

int main(int argc, char **argv, char **env)
{
    // Simulation duration
    clock_t     beg, end;
    double      secs;
    // Trace index
    int         trc_idx = 0;
    int         min_idx = 0;
    vluint8_t   dbg_vs = 1;
    // File name generation
    char        file_name[256];
    // Simulation time
    vluint64_t  tb_time;
    vluint64_t  max_time;
    // Testbench configuration
    vluint8_t   pal = 0;
    const char *arg;
    
    beg = clock();
    
    // Parse parameters
    Verilated::commandArgs(argc, argv);
    
    // Default : 1 msec
    max_time = (vluint64_t)1000000000;
    
    // Simulation duration : +usec=<num>
    arg = Verilated::commandArgsPlusMatch("usec=");
    if ((arg) && (arg[0]))
    {
        arg += 6;
        max_time = (vluint64_t)atoi(arg) * (vluint64_t)1000000;
    }
    
    // Simulation duration : +msec=<num>
    arg = Verilated::commandArgsPlusMatch("msec=");
    if ((arg) && (arg[0]))
    {
        arg += 6;
        max_time = (vluint64_t)atoi(arg) * (vluint64_t)1000000000;
    }
    
    // Trace start index : +tidx=<num>
    arg = Verilated::commandArgsPlusMatch("tidx=");
    if ((arg) && (arg[0]))
    {
        arg += 6;
        min_idx = atoi(arg);
    }
    else
    {
        min_idx = 0;
    }
    
    // PAL or NTSC chip
    arg = Verilated::commandArgsPlusMatch("chip=");
    if ((arg) && (arg[0]))
    {
        arg += 6;
        if (!strcmp(arg, "ntsc")) pal = 0;
        if (!strcmp(arg, "pal" )) pal = 1;
    }

    // Initialize top verilog instance
    top = new VM_PREFIX;
    top->eval ();
    
    // Initialize the register access
    reg = reg_ctor();
    
    // Initialize clock generator    
    clk = new ClockGen(1);
    tb_time = (vluint64_t)0;
    // 5 x 28 MHz clock
    clk->NewClock(0, (pal) ? PERIOD_PAL_142MHz_ps : PERIOD_NTSC_143MHz_ps);
    clk->ConnectClock(0, &top->main_clk);
    clk->StartClock(0, tb_time);
    
#if VM_TRACE
    // Initialize VCD trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->spTrace()->set_time_resolution ("1 ps");
    if (trc_idx == min_idx)
    {
        sprintf(file_name, quoted_string(VM_PREFIX) "_%04d.vcd", trc_idx);
        printf("Opening VCD file \"%s\"\n", file_name);
        tfp->open (file_name);
    }
#endif /* VM_TRACE */
  
    top->ntscn_pal = pal;
    // Reset ON during 48 cycles
    top->main_rst = 1;
    for (int i = 0; i < 96; i ++)
    {
        // Toggle clocks
        clk->AdvanceClocks(tb_time, false);
        // Evaluate verilated model
        top->eval ();
        
#if VM_TRACE
        // Dump signals into VCD file
        if (tfp)
        {
            if (trc_idx >= min_idx)
            {
                tfp->dump (tb_time);
            }
        }
#endif /* VM_TRACE */
    }
    top->main_rst = 0;
    
    REG_WRITE(DDFSTRT, 0x0038);
    REG_WRITE(DDFSTOP, 0x00D0);
    REG_WRITE(DIWSTRT, 0x2C81);
    REG_WRITE(DIWSTOP, 0x2CC1);
    REG_WRITE(BPLCON0, 0x6000);
    REG_WRITE(COPIR1,  0x6401);
    REG_WRITE(COPIR2,  0xFF01);

    // Simulation loop
    while (tb_time < max_time)
    {
        // Toggle clocks
        clk->AdvanceClocks(tb_time, false);
        // Evaluate verilated model
        top->eval ();
        
#if VM_TRACE
        // Dump signals into VCD file
        if (tfp)
        {
            /*
            if (dbg_vs != top->VSYNC_n)
            {
                if (dbg_vs)
                {
                    // New VCD file
                    if (trc_idx >= min_idx) tfp->close();
                    trc_idx++;
                    if (trc_idx >= min_idx)
                    {
                        sprintf(file_name, quoted_string(VM_PREFIX) "_%04d.vcd", trc_idx);
                        printf("Opening VCD file \"%s\"\n", file_name);
                        tfp->open (file_name);
                    }
                }
                dbg_vs = top->VSYNC_n;
            }
            */
            
            if (trc_idx >= min_idx)
            {
                tfp->dump (tb_time);
            }
        }
#endif /* VM_TRACE */

        if (Verilated::gotFinish()) break;
    }
    
#if VM_TRACE
    if (tfp && trc_idx >= min_idx) tfp->close();
#endif /* VM_TRACE */

    top->final();
    
    reg_dtor(reg);
    reg = nullptr;
    
    delete top;
    
    delete clk;
  
    // Calculate running time
    end = clock();
    printf("\nSeconds elapsed : %5.3f\n", (float)(end - beg) / CLOCKS_PER_SEC);

    exit(0);
}
