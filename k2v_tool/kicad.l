%option noyywrap noinput nounput

%{
    #define YY_DECL int yylex (void)
    // Provided externally
    extern "C" YY_DECL;
    extern "C" void yyerror(const char *s);

    // Needed for fprintf()
    #include <stdio.h>

    // Needed for the tokens
    #include "kicad.tab.hpp"
    
    #ifndef YYEOF
    #define YYEOF (0)
    #endif /* YYEOF */
    
    extern int g_line_num;
%}

%%

[ \t]           { /* Skip spaces and tabs */ }
"\n"            { g_line_num++; /* Count lines */ }
"\r\n"          { g_line_num++; /* Count lines */ }

"code"          { return KW_CODE; }
"comment"       { return KW_COMMENT; }
"comp"          { return KW_COMP; }
"company"       { return KW_COMPANY; }
"components"    { return KW_COMPONENTS; }
"date"          { return KW_DATE; }
"datasheet"     { return KW_DATASHEET; }
"description"   { return KW_DESCRIPTION; }
"design"        { return KW_DESIGN; }
"docs"          { return KW_DOCS; }
"export"        { return KW_EXPORT; }
"field"         { return KW_FIELD; }
"fields"        { return KW_FIELDS; }
"footprints"    { return KW_FOOTPRINTS; }
"fp"            { return KW_FP; }
"lib"           { return KW_LIB; }
"libpart"       { return KW_LIBPART; }
"libparts"      { return KW_LIBPARTS; }
"libraries"     { return KW_LIBRARIES; }
"library"       { return KW_LIBRARY; }
"libsource"     { return KW_LIBSOURCE; }
"logical"       { return KW_LOGICAL; }
"name"          { return KW_NAME; }
"names"         { return KW_NAMES; }
"net"           { return KW_NET; }
"nets"          { return KW_NETS; }
"node"          { return KW_NODE; }
"num"           { return KW_NUM; }
"number"        { return KW_NUMBER; }
"part"          { return KW_PART; }
"pin"           { return KW_PIN; }
"pinfunction"   { return KW_PINFUNCTION; }
"pins"          { return KW_PINS; }
"pintype"       { return KW_PINTYPE; }
"property"      { return KW_PROPERTY; }
"ref"           { return KW_REF; }
"rev"           { return KW_REV; }
"sheet"         { return KW_SHEET; }
"sheetpath"     { return KW_SHEETPATH; }
"source"        { return KW_SOURCE; }
"title"         { return KW_TITLE; }
"title_block"   { return KW_TITLE_BLOCK; }
"tool"          { return KW_TOOL; }
"tstamps"       { return KW_TSTAMPS; }
"type"          { return KW_TYPE; }
"uri"           { return KW_URI; }
"value"         { return KW_VALUE; }
"version"       { return KW_VERSION; }

<<EOF>>         { return YYEOF; }

"\""([^"]*)"\"" {
                    /* String between quotes */
                    yytext[yyleng - 1] = 0;
                    yylval.string_v = strdup(yytext + 1);
                    //puts (yytext + 1);
                    return TOK_STRING;
                }

.               { return *yytext; }

%%
 
void yyerror(const char *s)
{
  fprintf(stderr,"%s at \"%s\" in line %d.\n\n", s, yytext, g_line_num);
}
