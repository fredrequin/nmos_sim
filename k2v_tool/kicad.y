%{
    #include <iostream>
    #include <algorithm>
    #include <string>
    #include <list>
    #include <map>
    #include <cstring>
    #include <cstdlib>
    #include <cstdio>

    #include "kicad_st.hpp"

    // Globals
    int          g_line_num = 1;
    std::string  g_header;
    p_sheets     g_sheets;
    p_comps      g_comps;
    p_parts      g_parts;
    p_nets       g_nets;
    p_buses      g_buses;
    
    const std::string s_net_type[NET_MAX] =
    {
        "none",
        "wire",
        "input  wire",
        "output wire",
        "inout  wire",
        "output tri1"
    };
    
    // Provided externally
    extern "C" int yylex (void);
    extern "C" void yyerror(const char *s);

    extern "C" FILE *yyin;
    extern "C" FILE *yyout;
%}

%code requires 
{
    #include "kicad_st.hpp"
}

%code
{
    static void fix_pin_name(char *s)
    {
        // Fix negative logic names like : "~{Q}"
        if ((s) && (s[0] == '~') && (strlen(s) >= 4))
        {
            int i;
            // Remove "~{"
            for (i = 0; i < (strlen(s) - 3); i++)
            {
                s[i] = s[i + 2];
            }
            // Add "_n"
            s[i++] = '_';
            s[i++] = 'n';
            s[i]   = 0;
        }
    }

    static p_sheets add_sheet(p_sheets p, char *number, char *name, p_sheet_st t)
    {
        // If first element, create the list
        if (!p) p = new std::map<int,t_sheet_st>;
        // Insert a new sheet
        int n = (int)strtoul(number, nullptr, 10);
        t->m_name = std::string(name);
        p->insert(std::make_pair(n, std::move(*t)));
        delete t;
        // Free memory from strdup() calls
        free(number);
        free(name);
        
        return p;
    }

    static p_comments add_comment(p_comments p, char *number, char *value)
    {
        // If first element, create the list
        if (!p) p = new std::map<int,std::string>;
        // Insert a new comment
        int n = (int)strtoul(number, nullptr, 10);
        p->insert(std::make_pair(n, std::string(value)));
        // Free memory from strdup() calls
        free(number);
        free(value);
        
        return p;
    }
    
    static p_buses get_buses(p_buses p, p_comments c)
    {
        if (!p) p = new std::map<std::string,t_bus_st>;
        for (auto it = c->begin(); it != c->end(); it++)
        {
            std::string s = it->second;
            if (s.compare(0, 4, "bus:") == 0)
            {
                t_bus_st obj;
                obj.m_name = "";
                obj.m_msb  = -1;
                obj.m_lsb  = -1;
                int st = 0;
                for (int i = 4; i < s.length(); i++)
                {
                    char ch = s[i];
                    if (std::isblank(ch))
                    {
                        obj.m_name = "";
                        obj.m_msb  = -1;
                        obj.m_lsb  = -1;
                        st = 0;
                        continue;
                    }
                    switch (st)
                    {
                        // Bus name
                        case 0:
                        {
                            if (std::isalnum(ch) || (ch == '_'))
                            {
                                obj.m_name += ch;
                                st = 0;
                            }
                            else if (ch == '[')
                            {
                                st = 1; // Get MSB
                            }
                            else
                            {
                                st = 4; // Error
                            }
                            break;
                        }
                        // MSB
                        case 1:
                        {
                            if (std::isdigit(ch))
                            {
                                if (obj.m_msb == -1) obj.m_msb = std::stoi(s.substr(i));
                                st = 1;
                            }
                            else if (ch == ':')
                            {
                                st = 2; // Get LSB
                            }
                            else
                            {
                                st = 4; // Error
                            }
                            break;
                        }
                        // LSB
                        case 2:
                        {
                            if (std::isdigit(ch))
                            {
                                if (obj.m_lsb == -1) obj.m_lsb = std::stoi(s.substr(i));
                                st = 2;
                            }
                            else if (ch == ']')
                            {
                                // Debug
                                //std::cout << obj.m_name << '[' << obj.m_msb << ':' << obj.m_lsb << "]\n";
                                p->insert(std::make_pair(obj.m_name, std::move(obj)));
                                st = 0; // Next bus
                            }
                            else
                            {
                                st = 4; // Error
                            }
                            break;
                        }
                        // Error
                        default: ;
                    }
                    // Error
                    if (st == 4) break;
                }
            }
        }
        return p;
    }
    
    static int is_bus(char *name)
    {
        for (auto it = g_buses->begin(); it != g_buses->end(); it++)
        {
            std::string s = it->first;
            int l = (int)s.length();
            if (s.compare(0, -1, name, l) == 0)
            {
                int n = (int)strtoul(name + l, nullptr, 10);
                // Debug
                //std::cout << name << " : " << s << '[' << n << "]\n";
                return ((n >= it->second.m_lsb) && (n <= it->second.m_msb)) ? l : -1;
            }
        }
        return -1;
    }

    static p_comps add_component(p_comps p, char *ref, char *value, char *libpart, char *sheet, p_props pl)
    {
        t_comp_st obj;
        // If first element, create the list
        if (!p) p = new std::map<std::string,t_comp_st>;
        // Insert a new component
        obj.m_ref     = std::string(ref);     // ref (char *)
        obj.m_libpart = std::string(libpart); // libpart (char *)
        obj.m_sheet   = std::string(sheet);   // sheet (char *)
        obj.m_props   = pl;                   // prop_list (std::map<std::string,t_prop_st> *)
        obj.m_part    = nullptr;              // filled by associate_parts_comps()
        obj.m_conns   = nullptr;              // fileed by associate_nets_pins()
        obj.m_flags   = 0;
        p->insert(std::make_pair(obj.m_ref, std::move(obj)));
        // Free memory from strdup() calls
        free(ref);
        free(value);
        free(libpart);
        free(sheet);
        
        return p;
    }

    static p_props add_property(p_props p, char *name, char *value)
    {
        t_prop_st obj;
        // If first element, create the list
        if (!p) p = new std::map<std::string,t_prop_st>;
        // Insert a new property
        obj.m_name    = std::string(name);  // name (char *)
        obj.m_value   = std::string(value); // value (char *)
        p->insert(std::make_pair(obj.m_name, std::move(obj)));
        // Free memory from strdup() calls
        free(name);
        free(value);
        
        return p;
    }

    static p_parts add_libpart(p_parts p, char *lib, char *part, char *desc, p_pins pl)
    {
        t_part_st obj;
        // If first element, create the list
        if (!p) p = new std::map<std::string,t_part_st>;
        // Insert a new part
        obj.m_lib     = std::string(lib);  // lib (char *)
        obj.m_part    = std::string(part); // part (char *)
        obj.m_desc    = std::string(desc); // desc (char *)
        obj.m_pins    = pl;                // pin_list (<std::map<int,t_pin_st> *)
        p->insert(std::make_pair(obj.m_lib + "_" + obj.m_part, std::move(obj)));
        // Free memory from strdup() calls
        free(lib);
        free(part);
        free(desc);
        
        return p;
    }
    
    static p_pins add_pin(p_pins p, char *num, char *name, t_pin_type type)
    {
        t_pin_st obj;
        fix_pin_name(name);
        // If first element, create the list
        if (!p) p = new std::map<int,t_pin_st>;
        // Insert a new pin
        int n = (int)strtoul(num, nullptr, 10);
        obj.m_pin  = n;                 // num (int)
        obj.m_name = std::string(name); // name (char *)
        obj.m_type = type;              // type (t_pin_type)
        p->insert(std::make_pair(n, std::move(obj)));
        // Free memory from strdup() calls
        free(num);
        free(name);
        
        return p;
    }

    static p_nets add_net(p_nets p, char *code, char *name, p_nodes nl)
    {
        t_net_st obj;
        // If first element, create the list
        if (!p) p = new std::map<int,t_net_st>;
        // Insert a new net
        int n = (int)strtoul(code, nullptr, 10);
        // Extract hierarchy
        char *sig = strrchr(name, '/');
        if (!sig) sig = name; else sig++;
        obj.m_idx    = n;                 // code (int)
        obj.m_oc     = 0;                 // filled by associate_nets_pins()
        obj.m_in     = 0;                 // filled by associate_nets_pins()
        obj.m_out    = 0;                 // filled by associate_nets_pins()
        obj.m_bdir   = 0;                 // filled by associate_nets_pins()
        obj.m_driven = false;
        obj.m_isbus  = is_bus(sig);
        obj.m_kname  = std::string(sig);  // name (char *)
        *sig = 0;
        obj.m_khier  = std::string(name); // name (char *)
        for (int i = 0; name[i]; i++) if (name[i] == '/') name[i] = '_';
        obj.m_vhier  = std::string(name); // name (char *)
        obj.m_vname  = "";                // filled by associate_nets_pins()
        obj.m_vbus   = "";                // filled by associate_nets_pins()
        obj.m_vtype  = net_none;          // filled by associate_nets_pins()
        obj.m_nodes  = nl;                // node_list (<std::string,t_node_st> *)
        // Debug
        //std::cout << std::to_string(obj.m_idx) << ':' << obj.m_khier << '.' << obj.m_kname << ' ' << obj.m_vhier << '\n';
        p->insert(std::make_pair(n, std::move(obj)));
        // Free memory from strdup() calls
        free(code);
        free(name);
        
        return p;
    }

    static p_nodes add_node(p_nodes p, char *ref, char *pin, char *name, t_pin_type type)
    {
        t_node_st obj;
        // Pin number
        int n = (int)strtoul(pin, nullptr, 10);
        // If first element, create the list
        if (!p) p = new std::map<std::string,t_node_st>;
        // Insert a new node
        fix_pin_name(name);
        obj.m_pin  = n;                               // pin (int)
        obj.m_ref  = std::string(ref);                // ref (char *)
        obj.m_name = (name) ? std::string(name) : ""; // name (char *)
        obj.m_type = type;                            // type (t_pin_type)
        //std::cout << obj.m_ref << "." << std::string(pin) << '\n';
        p->insert(std::make_pair(obj.m_ref + "." + std::string(pin), std::move(obj)));
        // Free memory from strdup() calls
        free(ref);
        free(pin);
        if (name) free(name);
        
        return p;
    }

    static t_pin_type conv_type(char *type)
    {
        std::string s = std::string(type);
        //std::cout << "type : " << type << '\n';
        if (s == "input")          return pin_input;
        if (s == "output")         return pin_output;
        if (s == "bidirectional")  return pin_bidirectional;
        if (s == "tri_state")      return pin_tri_state;
        if (s == "passive")        return pin_passive;
        if (s == "free")           return pin_free;
        if (s == "unspecified")    return pin_unspecified;
        if (s == "power_in")       return pin_power_in;
        if (s == "power_out")      return pin_power_out;
        if (s == "open_collector") return pin_open_collector;
        if (s == "open_emitter")   return pin_open_emitter;
        if (s == "no_connect")     return pin_no_connect;
        return pin_unspecified;
    }
}

%union
{
    char       *string_v;
    t_pin_type  pintype_v;
    p_sheet_st  sheet_p;
    p_sheets    sheets_p;
    p_comments  comments_p;
    p_comps     comps_p;
    p_parts     parts_p;
    p_nets      nets_p;
    p_nodes     nodes_p;
    p_pins      pins_p;
    p_props     props_p;
}

%token TOK_STRING

%token KW_CODE
%token KW_COMMENT
%token KW_COMP
%token KW_COMPANY
%token KW_COMPONENTS
%token KW_DATE
%token KW_DATASHEET
%token KW_DESCRIPTION
%token KW_DESIGN
%token KW_DOCS
%token KW_EXPORT
%token KW_FIELD
%token KW_FIELDS
%token KW_FOOTPRINTS
%token KW_FP
%token KW_LIB
%token KW_LIBPART
%token KW_LIBPARTS
%token KW_LIBRARIES
%token KW_LIBRARY
%token KW_LIBSOURCE
%token KW_LOGICAL
%token KW_NAME
%token KW_NAMES
%token KW_NET
%token KW_NETS
%token KW_NODE
%token KW_NUM
%token KW_NUMBER
%token KW_PART
%token KW_PIN
%token KW_PINFUNCTION
%token KW_PINS
%token KW_PINTYPE
%token KW_PROPERTY
%token KW_REF
%token KW_REV
%token KW_SHEET
%token KW_SHEETPATH
%token KW_SOURCE
%token KW_TITLE
%token KW_TITLE_BLOCK
%token KW_TOOL
%token KW_TSTAMPS
%token KW_TYPE
%token KW_URI
%token KW_VALUE
%token KW_VERSION

%type <string_v>   TOK_STRING

%type <string_v>   code
%type <string_v>   company
%type <string_v>   date
%type <string_v>   datasheet
%type <string_v>   description
%type <string_v>   docs
%type <string_v>   lib
%type <string_v>   libsource
%type <string_v>   logical
%type <string_v>   name
%type <string_v>   names
%type <string_v>   num
%type <string_v>   number
%type <string_v>   part
%type <string_v>   pin
%type <string_v>   pinfunction
%type <string_v>   ref
%type <string_v>   rev
%type <string_v>   sheetpath
%type <string_v>   source
%type <string_v>   title
%type <string_v>   tool
%type <string_v>   tstamps
%type <string_v>   uri
%type <string_v>   value
%type <string_v>   version

%type <pintype_v>  pin_type pintype

%type <sheet_p>    title_block
%type <sheets_p>   sheet_list
%type <comments_p> comment_list
%type <comps_p>    component_list components
%type <parts_p>    libpart_list libparts
%type <nets_p>     net_list nets
%type <nodes_p>    node_list
%type <pins_p>     pin_list pins
%type <props_p>    prop_list

%start netlist_file

%%

code        : '(' KW_CODE        TOK_STRING ')' { $$ = $3; }
company     : '(' KW_COMPANY     TOK_STRING ')' { $$ = $3; }
date        : '(' KW_DATE        TOK_STRING ')' { $$ = $3; }
datasheet   : '(' KW_DATASHEET   TOK_STRING ')' { $$ = nullptr; free($3); }
description : '(' KW_DESCRIPTION TOK_STRING ')' { $$ = $3; }
docs        : '(' KW_DOCS        TOK_STRING ')' { $$ = nullptr; free($3); }
lib         : '(' KW_LIB         TOK_STRING ')' { $$ = $3; }
logical     : '(' KW_LOGICAL     TOK_STRING ')' { $$ = nullptr; free($3); }
name        : '(' KW_NAME        TOK_STRING ')' { $$ = $3; }
names       : '(' KW_NAMES       TOK_STRING ')' { $$ = $3; }
num         : '(' KW_NUM         TOK_STRING ')' { $$ = $3; }
number      : '(' KW_NUMBER      TOK_STRING ')' { $$ = $3; }
part        : '(' KW_PART        TOK_STRING ')' { $$ = $3; }
pin         : '(' KW_PIN         TOK_STRING ')' { $$ = $3; }
pinfunction : '(' KW_PINFUNCTION TOK_STRING ')' { $$ = $3; }
ref         : '(' KW_REF         TOK_STRING ')' { $$ = $3; }
rev         : '(' KW_REV         TOK_STRING ')' { $$ = $3; }
source      : '(' KW_SOURCE      TOK_STRING ')' { $$ = $3; }
title       : '(' KW_TITLE       TOK_STRING ')' { $$ = $3; }
tool        : '(' KW_TOOL        TOK_STRING ')' { $$ = $3; }
tstamps     : '(' KW_TSTAMPS     TOK_STRING ')' { $$ = nullptr; free($3); }
uri         : '(' KW_URI         TOK_STRING ')' { $$ = nullptr; free($3); }
value       : '(' KW_VALUE       TOK_STRING ')' { $$ = $3; }
version     : '(' KW_VERSION     TOK_STRING ')' { $$ = $3; }

pin_type    : '(' KW_TYPE        TOK_STRING ')' { $$ = conv_type($3); free($3); }
pintype     : '(' KW_PINTYPE     TOK_STRING ')' { $$ = conv_type($3); free($3); }

netlist_file : '(' KW_EXPORT version[ve] design components[co] libparts[pa] libraries nets[ne] ')'
{
    g_comps = $co;
    g_parts = $pa;
    g_nets  = $ne;
    free($ve);
}



design : '(' KW_DESIGN source[so] date[da] tool[to] sheet_list[sl] ')'
{
    g_header = "// Source : " + std::string($so) + "\n"
             + "// Date   : " + std::string($da) + "\n"
             + "// Tool   : " + std::string($to) + "\n";
    g_sheets = $sl;
    // Free memory from strdup() calls
    free($so);
    free($da);
    free($to);
}

sheet_list
: '(' KW_SHEET number[nu] name[na] tstamps title_block[tb] ')'
{
    $$ = add_sheet(nullptr, $nu, $na, $tb);
}
| sheet_list '(' KW_SHEET number[nu] name[na] tstamps title_block[tb] ')'
{
    $$ = add_sheet($$, $nu, $na, $tb);
}
;

title_block : '(' KW_TITLE_BLOCK title[ti] company[co] rev[re] date[da] source[so] comment_list[cl] ')'
{
    // Initialize the t_sheet_st structure
    p_sheet_st p = new t_sheet_st;
    p->m_name     = "";
    p->m_title    = std::string($ti);
    p->m_company  = std::string($co);
    p->m_revision = std::string($re);
    p->m_date     = std::string($da);
    p->m_comments = $cl;
    //p->m_buses    = get_buses(nullptr, $cl);
    $$ = p;
    g_buses = get_buses(g_buses, $cl);
    // Free memory from strdup() calls
    free($ti);
    free($co);
    free($re);
    free($da);
    free($so);
}

comment_list
: '(' KW_COMMENT number[nu] value[va] ')'
{
    $$ = add_comment(nullptr, $nu, $va);
}
| comment_list '(' KW_COMMENT number[nu] value[va] ')'
{ 
    $$ = add_comment($$, $nu, $va);
}
;



components : '(' KW_COMPONENTS component_list ')' { $$ = $3; }

component_list
: '(' KW_COMP ref[re] value[va] libsource[ls] prop_list[pl] sheetpath[sp] tstamps ')'
{
    $$ = add_component(nullptr, $re, $va, $ls, $sp, $pl);
}
| '(' KW_COMP ref[re] value[va] datasheet libsource[ls] prop_list[pl] sheetpath[sp] tstamps ')'
{
    $$ = add_component(nullptr, $re, $va, $ls, $sp, $pl);
}
| component_list '(' KW_COMP ref[re] value[va] libsource[ls] prop_list[pl] sheetpath[sp] tstamps ')'
{ 
    $$ = add_component($$, $re, $va, $ls, $sp, $pl);
}
| component_list '(' KW_COMP ref[re] value[va] datasheet libsource[ls] prop_list[pl] sheetpath[sp] tstamps ')'
{ 
    $$ = add_component($$, $re, $va, $ls, $sp, $pl);
}
;

libsource : '(' KW_LIBSOURCE lib[li] part[pa] description[de] ')'
{
    char *p = (char *)malloc(strlen($li) + strlen($pa) + 2);
    strcpy(p, $li);
    strcat(p, "_");
    strcat(p, $pa);
    $$ = p;
    // Free memory from strdup() calls
    free($li);
    free($pa);
    free($de);
}

prop_list
: '(' KW_PROPERTY name[na] value[va] ')'
{
    $$ = add_property(nullptr, $na, $va);
}
| prop_list '(' KW_PROPERTY name[na] value[va] ')'
{
    $$ = add_property($$, $na, $va);
}
;

sheetpath : '(' KW_SHEETPATH names tstamps ')' { $$ = $3; } ;



libparts : '(' KW_LIBPARTS libpart_list ')' { $$ = $3; } ;

libpart_list
: '(' KW_LIBPART lib[li] part[pa] description[de] opt_fields pins[pi] ')'
{
    $$ = add_libpart(nullptr, $li, $pa, $de, $pi);
}
| libpart_list '(' KW_LIBPART lib[li] part[pa] description[de] opt_fields pins[pi] ')'
{
    $$ = add_libpart($$, $li, $pa, $de, $pi);
}
;

opt_fields : fields
           | footprints fields
           | docs fields
           | docs footprints fields
           ;

footprints : '(' KW_FOOTPRINTS ')'
           | '(' KW_FOOTPRINTS fp_list ')' ;

fp_list : '(' KW_FP TOK_STRING ')'
        | fp_list '(' KW_FP TOK_STRING ')'
        ;

fields : '(' KW_FIELDS ')'
       | '(' KW_FIELDS field_list ')' ;

field_list : '(' KW_FIELD name[na] TOK_STRING ')' { free($na); }
           | field_list '(' KW_FIELD name[na] TOK_STRING ')' { free($na); }
           ;

pins : '(' KW_PINS pin_list ')' { $$ = $3; } ;

pin_list
: '(' KW_PIN num[nu] name[na] pin_type[pt] ')'
{
    $$ = add_pin(nullptr, $nu, $na, $pt);
}
| pin_list '(' KW_PIN num[nu] name[na] pin_type[pt] ')'
{
    $$ = add_pin($$, $nu, $na, $pt);
}
;



libraries : '(' KW_LIBRARIES library_list ')' ;

library_list : '(' KW_LIBRARY logical uri ')'
             | library_list '(' KW_LIBRARY logical uri ')'
             ;



nets : '(' KW_NETS net_list ')' { $$ = $3; } ;

net_list
: '(' KW_NET code[co] name[na] node_list[nl] ')'
{
    $$ = add_net(nullptr, $co, $na, $nl);
}
| net_list '(' KW_NET code[co] name[na] node_list[nl] ')'
{
    $$ = add_net($$, $co, $na, $nl);
}
;


node_list
: '(' KW_NODE ref[re] pin[pi] pintype[pt] ')'
{
    $$ = add_node(nullptr, $re, $pi, nullptr, $pt);
}
| '(' KW_NODE ref[re] pin[pi] pinfunction[pf] pintype[pt] ')'
{
    $$ = add_node(nullptr, $re, $pi, $pf, $pt);
}
| node_list '(' KW_NODE ref[re] pin[pi] pintype[pt] ')'
{
    $$ = add_node($$, $re, $pi, nullptr, $pt);
}
| node_list '(' KW_NODE ref[re] pin[pi] pinfunction[pf] pintype[pt] ')'
{
    $$ = add_node($$, $re, $pi, $pf, $pt);
}
;


%%

// Associate parts to components
static void associate_parts_comps(void)
{
    // Scan the component instances
    std::cout << "Pass 1...\n";
    for (auto c = g_comps->begin(); c != g_comps->end(); c++)
    {
        p_comp_st comp = &c->second;
        // Find the part attached to the component
        auto p = g_parts->find(comp->m_libpart);
        // Save the part's pointer into the component structure
        comp->m_part = &p->second;
        // Identify logic gates
        std::string s = p->second.m_part;
             if (s == "NOT"  ) comp->m_flags = GATE_NOT;
        else if (s == "MUX"  ) comp->m_flags = GATE_MUX;
        else if (s.compare(0, 3, "AND" ) == 0) comp->m_flags = GATE_AND;
        else if (s.compare(0, 4, "NAND") == 0) comp->m_flags = GATE_NAND;
        else if (s.compare(0, 2, "OR"  ) == 0) comp->m_flags = GATE_OR;
        else if (s.compare(0, 3, "NOR" ) == 0) comp->m_flags = GATE_NOR;
        else if (s.compare(0, 3, "XOR" ) == 0) comp->m_flags = GATE_XOR;
        else if (s.compare(0, 4, "XNOR") == 0) comp->m_flags = GATE_XNOR;
        // Debug
        //std::cout << comp->m_sheet << comp->m_ref << " : " << comp->m_libpart << '\n';
    }
    std::cout << "Found " << g_comps->size() << " instances of " << g_parts->size() << " parts\n";
}

// Associate nets to pins
static void associate_nets_pins(void)
{
    int n_cnt = 0; // Total node count
    int w_cnt = 0; // Total wire count
    int p_cnt = 0; // Total port count
    int o_cnt = 0; // Total open count
    
    std::list<std::string> bus = {};

    // Scan the nets
    std::cout << "Pass 2...\n";
    for (auto n = g_nets->begin(); n != g_nets->end(); n++)
    {
        std::string drv = "";
        p_net_st net = &n->second;
        // Scan the nodes
        for (auto m = net->m_nodes->begin(); m != net->m_nodes->end(); m++)
        {
            p_node_st node = &m->second;
            // Find the component instance attached to the node
            auto c = g_comps->find(node->m_ref);
            p_comp_st comp = &c->second;
            // Connection list
            if (!comp->m_conns) comp->m_conns = new std::map<int,int>;
            auto l = comp->m_conns;
            // Insert a connection
            l->insert(std::make_pair(node->m_pin, net->m_idx));
            // Count the node types
            if (node->m_type == pin_open_collector) net->m_oc++;
            if (comp->m_libpart != "NMOS_PULLUP") // Do no count pull-ups connections
            {
                if (node->m_type == pin_input)         net->m_in++;
                if (node->m_type == pin_output)        net->m_out++;
                if (node->m_type == pin_bidirectional) net->m_bdir++;
                if (node->m_type == pin_tri_state)     net->m_bdir++;
            }
            // Keep track of node that drives the net
            if (node->m_type == pin_output)
            {
                if (node->m_name.empty())
                    drv = node->m_ref + "_pin" + std::to_string(node->m_pin);
                else
                    drv = node->m_ref + "_" + node->m_name;
            }
            // Debug
            //std::cout << '<' << net->m_idx << '>' << net->m_kname << " : " << comp->m_ref << '.' << node->m_pin << '\n';
            //std::cout.flush();
        }
        // Generate Verilog net names
        if (net->m_kname == "VCC")
        {
            // Tied to VCC
            net->m_vname = "1'b1";
            net->m_vtype = net_none;
        }
        else if (net->m_kname == "GND")
        {
            // Tied to GND
            net->m_vname = "1'b0";
            net->m_vtype = net_none;
        }
        else if (net->m_kname.compare(0, 13, "unconnected-(") == 0)
        {
            // No connect (open)
            net->m_vname = "/* open */";
            net->m_vtype = net_none;
            o_cnt++;
        }
        else if (net->m_kname.compare(0,  5, "Net-(") == 0)
        {
            // Unnamed wire
            net->m_vname = "w_" + drv;
            net->m_vtype = net_wire;
            w_cnt++;
        }
        else if (net->m_khier[0])
        {
            // Named wire
            std::string s = net->m_kname.substr(0, net->m_isbus);
            if (net->m_isbus > 0)
            {
                auto it = std::find(bus.begin(), bus.end(), s);
                if (it == bus.end())
                {
                    int msb = g_buses->find(s)->second.m_msb;
                    int lsb = g_buses->find(s)->second.m_lsb;
                    net->m_vbus = "[" + std::to_string(msb) + ":" + std::to_string(lsb) + "] w" + net->m_vhier + s;
                    bus.push_back(s);
                }
                net->m_vname = "w" + net->m_vhier + s + "[" + net->m_kname.substr(net->m_isbus) + "]";
            }
            else
            {
                net->m_vname = "w" + net->m_vhier + s;
            }
            net->m_vtype = net_wire;
            w_cnt++;
        }
        else
        {
            // Named I/O port
            std::string s = net->m_kname.substr(0, net->m_isbus);
            if (net->m_isbus > 0)
            {
                auto it = std::find(bus.begin(), bus.end(), s);
                if (it == bus.end())
                {
                    int msb = g_buses->find(s)->second.m_msb;
                    int lsb = g_buses->find(s)->second.m_lsb;
                    net->m_vbus = "[" + std::to_string(msb) + ":" + std::to_string(lsb) + "] " + s;
                    bus.push_back(s);
                }
                net->m_vname = s + "[" + net->m_kname.substr(net->m_isbus) + "]";
            }
            else
            {
                net->m_vname = s;
            }
            
            if (net->m_out)
            {
                net->m_vtype = net_output;
            }
            else if (net->m_oc)
            {
                net->m_vtype = net_tri1;
            }
            else if (net->m_bdir)
            {
                net->m_vtype = net_inout;
            }
            else
            {
                net->m_vtype = net_input;
            }
            p_cnt++;
            // Debug
            //std::cout << net->m_vname << " : " << s_net_type[net->m_vtype] << "\n";
        }
        // Count the number of nodes
        n_cnt += net->m_nodes->size();
        // Debug
        //std::cout << net->m_vname << " : " << s_net_type[net->m_vtype] << " (" << net->m_oc << ',' << net->m_in << ',' << net->m_out << ',' << net->m_bdir << ")\n";
    }
    std::cout << "Found " << g_nets->size() << " nets with " << n_cnt << " nodes";
    std::cout << " (" << w_cnt << " wires, " << p_cnt << " ports, " << o_cnt << " opens)\n";
}

static void emit_ports(FILE *fh)
{
    char ch = ' ';
    std::cout << "Create ports...\n";
    auto s = g_sheets->find(1);
    p_sheet_st sheet = &s->second;
    fprintf(fh, "module %s\n(\n", sheet->m_title.c_str());
    for (auto n = g_nets->begin(); n != g_nets->end(); n++)
    {
        p_net_st net = &n->second;
        if (net->m_vtype > net_wire)
        {
            if (net->m_isbus > 0)
            {
                if (net->m_vbus.length())
                {
                    fprintf(fh, "    %c%s %s\n", ch, s_net_type[net->m_vtype].c_str(), net->m_vbus.c_str());
                    ch = ',';
                }
            }
            else
            {
                fprintf(fh, "    %c%s %s\n", ch, s_net_type[net->m_vtype].c_str(), net->m_vname.c_str());
                ch = ',';
            }
        }
        if ((net->m_vtype == net_input) ||
            (net->m_vtype == net_inout)) net->m_driven = true;
    }
    fprintf(fh, ");\n");
}

static void emit_wires(FILE *fh)
{
    std::cout << "Create wires...\n";
    fputs("\n// Wires declaration :\n//====================\n", fh);
    for (auto n = g_nets->begin(); n != g_nets->end(); n++)
    {
        p_net_st net = &n->second;
        if (net->m_vtype == net_wire)
        {
            if (net->m_isbus > 0)
            {
                if (net->m_vbus.length()) fprintf(fh, "wire %s;\n", net->m_vbus.c_str());
            }
            else
            {
                fprintf(fh, "wire        %s;\n", net->m_vname.c_str());
            }
        }
    }
}

static void emit_gates(FILE *fh)
{
    // Scan the component instances
    std::cout << "Create gates...\n";
    fputs("\n// Combinational gates :\n//======================\n", fh);
    for (auto c = g_comps->begin(); c != g_comps->end(); c++)
    {
        // Get the component and the part attached to it
        p_comp_st comp = &c->second;
        p_part_st part = comp->m_part;
        // Logical gate case
        if (comp->m_flags)
        {
            if (comp->m_flags & GATE_MUX)
            {
                for (int io = 1; io <= 4; io++)
                {
                    auto r = comp->m_conns->find(io);
                    auto n = g_nets->find(r->second);
                    p_net_st net = &n->second;

                    switch (io)
                    {
                        // Output
                        case 1:
                        {
                            fprintf(fh, "assign %-20s =  (", net->m_vname.c_str());
                            net->m_driven = true;
                            break;
                        }
                        // Select
                        case 2:
                        {
                            fprintf(fh, "%s) ? ", net->m_vname.c_str());
                            break;
                        }
                        // D1
                        case 3:
                        {
                            fprintf(fh, "%s : ", net->m_vname.c_str());
                            break;
                        }
                        // D0
                        case 4:
                        {
                            fprintf(fh, "%s;\n", net->m_vname.c_str());
                            break;
                        }
                    }
                }
            }
            else
            {
                // Verilog operators
                char op1 = (comp->m_flags & GATE_AND) ? '&'
                         : (comp->m_flags & GATE_OR ) ? '|'
                         : (comp->m_flags & GATE_XOR) ? '^'
                         : ' ';
                char op2 = (comp->m_flags & GATE_NOT) ? '~' : ' ';
                // Number of gate I/Os (3 to 10)
                int  num_io = (comp->m_flags == GATE_NOT) ? 2 : part->m_part.back() - '0' + 1;
                // Scan the gate I/Os
                //std::cout << part->m_part << " : " << num_io << op1 << op2 << '\n';
                for (int io = 1; io <= num_io; io++)
                {
                    auto r = comp->m_conns->find(io);
                    auto n = g_nets->find(r->second);
                    p_net_st net = &n->second;
                    // Output
                    if (io == 1)
                    {
                        fprintf(fh, "assign %-20s = %c(", net->m_vname.c_str(), op2);
                        net->m_driven = true;
                    }
                    // Last input
                    else if (io == num_io)
                    {
                        fprintf(fh, "%s);\n", net->m_vname.c_str());
                    }
                    else
                    {
                        fprintf(fh, "%s %c ", net->m_vname.c_str(), op1);
                    }
                }
            }
        }
    }
}

static void emit_prims(FILE *fh)
{
    // Scan the component instances
    std::cout << "Create primitives...\n";
    fputs("\n// Clocked primitives :\n//=====================\n", fh);
    for (auto c = g_comps->begin(); c != g_comps->end(); c++)
    {
        // Get the component and the part attached to it
        p_comp_st comp = &c->second;
        p_part_st part = comp->m_part;
        // Clocked primitive case
        if ((!comp->m_flags) && (comp->m_libpart != "NMOS_NOT_OC") && (comp->m_libpart != "NMOS_PULLUP"))
        {
            char ch = '(';
            fprintf(fh, "%s %s\n", comp->m_libpart.c_str(), comp->m_ref.c_str());
            for (auto p = part->m_pins->begin(); p != part->m_pins->end(); p++)
            {
                auto r = comp->m_conns->find(p->second.m_pin);
                auto n = g_nets->find(r->second);
                p_net_st net = &n->second;
                if ((p->second.m_type == pin_output) ||
                    (p->second.m_type == pin_bidirectional)) net->m_driven = true;
                fprintf(fh, "%c\n    .%-10s(%s)", ch, p->second.m_name.c_str(), net->m_vname.c_str());
                ch = ',';
            }
            fputs("\n);\n\n", fh);
        }
    }
}

static void emit_plas(FILE *fh)
{
    std::cout << "Create PLAs...\n";
    fputs("\n// PLAs equations :\n//=================\n", fh);
    for (auto n = g_nets->begin(); n != g_nets->end(); n++)
    {
        p_net_st net = &n->second;
        if (net->m_oc > 0)
        {
            char op = '(';
            fprintf(fh, "assign %-20s =", net->m_vname.c_str());
            // Scan the nodes
            for (auto m = net->m_nodes->begin(); m != net->m_nodes->end(); m++)
            {
                p_node_st node = &m->second;
                // The node is an open collector output
                if ((node->m_pin == 1) && (node->m_type == pin_open_collector))
                {
                    // Find the component instance attached to the node
                    auto c = g_comps->find(node->m_ref);
                    p_comp_st comp = &c->second;
                    // Check if it is an NMOS transistor
                    if (comp->m_libpart == "NMOS_NOT_OC")
                    {
                        // Get its input net
                        auto r = comp->m_conns->find(2);
                        auto i = g_nets->find(r->second);
                        fprintf(fh, " %c %s", op, i->second.m_vname.c_str());
                        op = '|';
                    }
                }
            }
            fputs(") ? 1'b0 : 1'b1;\n", fh);
            net->m_driven = true;
        }
    }
}

static void check_nets(FILE *fh)
{
    std::cout << "Check undriven nets...\n";
    for (auto n = g_nets->begin(); n != g_nets->end(); n++)
    {
        p_net_st net = &n->second;
        if ((!net->m_driven) && (net->m_kname != "GND") && (net->m_kname != "VCC"))
        {
            std::cerr << "Net " << net->m_vname << " not driven !!\n";
            //std::cout << net->m_vname << " (" << net->m_oc << ',' << net->m_in << ',' << net->m_out << ',' << net->m_bdir << ")\n";
        }
    }
}

int main(int argc, char **argv)
{
    FILE *dest;
    int status;

    if (argc == 3)
    {
        yyin = fopen(argv[1], "r");
        if (!yyin)
        {
            std::cerr << "Cannot open file \"" << argv[1] << "\" for reading !!\n";
            return -1;
        }

        dest = fopen(argv[2], "w");
        if (!dest)
        {
            std::cerr << "Cannot open file \"" << argv[2] << "\" for writing !!\n";
            fclose(yyin);
            return -1;
        }

        if (yyout == NULL) yyout = stdout;
        
        g_buses = nullptr;

        status = yyparse();
        
        associate_parts_comps();
        associate_nets_pins();

        emit_ports(dest);
        emit_wires(dest);
        emit_plas (dest);
        emit_gates(dest);
        emit_prims(dest);
        
        check_nets(dest);
        
        fputs("endmodule\n", dest);

        fclose(dest);
        fclose(yyin);
    }
    else
    {
        std::cerr << "USAGE : k2v <netlist file> <verilog file>\n";
        return -1;
    }
}
