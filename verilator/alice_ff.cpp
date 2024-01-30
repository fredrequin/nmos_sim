// Macros to build include file name
#ifndef symbols_header
#define _quoted_string(x) #x
#define quoted_string(x) _quoted_string(x)
#define _symbols_header(x) _quoted_string(x##__Syms.h)
#define symbols_header(x) _symbols_header(x)
#endif
// Top level
#include symbols_header(VM_PREFIX)

#include "alice_ff.h"

// Top level (global)
extern VM_PREFIX* top;

// Chip registers access (global)
extern ff_ptr_t *reg;

// Register access constructor
ff_ptr_t *reg_ctor(void)
{
    ff_ptr_t *p = new ff_ptr_t;
    *p =
    {
        { DDFSTRT_FF },
        { DDFSTOP_FF },
        { DIWSTRT_FF },
        { DIWSTOP_FF },
        { DIWHIGH_FF },
        { BEAMCON0_FF },
        { HBSTRT_FF },
        { HBSTOP_FF },
        { HSSTRT_FF },
        { HSSTOP_FF },
        { HCENTER_FF },
        { HTOTAL_FF },
        { VBSTRT_FF },
        { VBSTOP_FF },
        { VSSTRT_FF },
        { VSSTOP_FF },
        { VTOTAL_FF }
    };
    return p;
}

// Register access destructor
void reg_dtor(ff_ptr_t *reg)
{
    delete reg;
}

// Register write
void reg_write(vluint8_t *p_u8[16], vluint16_t val)
{
    for (int i = 0; i < 16; i++)
    {
        if (p_u8[i] != nullptr) *p_u8[i] = (val >> i) & 1;
    }
}
