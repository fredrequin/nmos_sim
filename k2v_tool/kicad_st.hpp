#ifndef KICAD_ST_H
#define KICAD_ST_H

#include <string>
#include <map>
#include <vector>

// Bus
typedef struct
{
    int          m_lsb;
    int          m_msb;
    std::string  m_name;
} t_bus_st, *p_bus_st;

typedef std::map<std::string,t_bus_st> *p_buses; // indexed by m_name

// Sheet comment
typedef std::map<int,std::string> *p_comments;

// Sheet
typedef struct
{
    std::string  m_name;
    std::string  m_title;
    std::string  m_company;
    std::string  m_revision;
    std::string  m_date;
    p_comments   m_comments;
    //p_buses      m_buses;
} t_sheet_st, *p_sheet_st;

typedef std::map<int,t_sheet_st> *p_sheets;

// Pin type
typedef enum
{
    pin_input,
    pin_output,
    pin_bidirectional,
    pin_tri_state,
    pin_passive,
    pin_free,
    pin_unspecified,
    pin_power_in,
    pin_power_out,
    pin_open_collector,
    pin_open_emitter,
    pin_no_connect
} t_pin_type;

// Net type
typedef enum
{
    net_none = 0,
    net_wire,
    net_input,
    net_output,
    net_inout,
    net_tri1,
    NET_MAX
} t_net_type;

// Pin of a part
typedef struct
{
    int          m_pin;
    t_pin_type   m_type;
    std::string  m_name;
} t_pin_st, *p_pin_st;

typedef std::map<int,t_pin_st> *p_pins;

// Part
typedef struct
{
    std::string  m_lib;
    std::string  m_part;
    std::string  m_desc;
    p_pins       m_pins;
} t_part_st, *p_part_st;

typedef std::map<std::string,t_part_st> *p_parts;

// Node of a net
typedef struct
{
    int          m_pin;
    t_pin_type   m_type;
    std::string  m_ref;
    std::string  m_name;
} t_node_st, *p_node_st;

typedef std::map<std::string,t_node_st> *p_nodes; // indexed by m_ref + '.' + m_pin

// Net
typedef struct
{
    int          m_idx;
    int          m_oc;
    int          m_in;
    int          m_out;
    int          m_bdir;
    int          m_isbus;
    bool         m_driven;
    std::string  m_khier;
    std::string  m_kname;
    std::string  m_vhier;
    std::string  m_vname;
    std::string  m_vbus;
    t_net_type   m_vtype;
    p_nodes      m_nodes;
} t_net_st, *p_net_st;

typedef std::map<int,t_net_st> *p_nets; // indexed by m_idx

// Component property
typedef struct
{
    std::string  m_name;
    std::string  m_value;
} t_prop_st, *p_prop_st;

typedef std::map<std::string,t_prop_st> *p_props; // indexed by m_name

// Pin <-> Net connect
typedef std::map<int,int> *p_conns; // indexed by m_pin

// Component
typedef struct
{
    std::string  m_ref;     // instance
    std::string  m_libpart; // module
    std::string  m_sheet;   // parent module
    p_props      m_props;
    p_part_st    m_part;
    p_conns      m_conns;
    int          m_flags;
} t_comp_st, *p_comp_st;

typedef std::map<std::string,t_comp_st> *p_comps; // indexed by m_ref

const int GATE_AND  = 0b000001;
const int GATE_OR   = 0b000010;
const int GATE_XOR  = 0b000100;
const int GATE_NOT  = 0b001000;
const int GATE_MUX  = 0b010000;
const int GATE_BUF  = 0b100000;

const int GATE_NAND = GATE_AND | GATE_NOT;
const int GATE_NOR  = GATE_OR  | GATE_NOT;
const int GATE_XNOR = GATE_XOR | GATE_NOT;

#endif /* KICAD_ST_H */