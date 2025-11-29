%{
#include "parser.tab.h"
#include <string.h>
%}

%%

form        { return FORM; }
meta        { return META; }
section     { return SECTION; }
field       { return FIELD; }
validate    { return VALIDATE; }
if          { return IF; }
error       { return ERROR; }

required    { return REQUIRED; }
min         { return MIN; }
max         { return MAX; }
default     { return DEFAULT; }

true|false  { yylval.str = strdup(yytext); return BOOL; }

":"         { return COLON; }
";"         { return SEMICOLON; }
"="         { return EQUAL; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
"["         { return LBRACK; }
"]"         { return RBRACK; }
","         { return COMMA; }

"<"         { return LT; }
">"         { return GT; }
"=="        { return EQ; }

[0-9]+      { yylval.num = atoi(yytext); return NUMBER; }

\"[^\"]+\"  {
    yylval.str = strdup(yytext + 1);
    yylval.str[strlen(yylval.str)-1] = '\0';
    return STRING;
}

[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.str = strdup(yytext);
    return ID;
}

[ \t\r\n]+  ; // Ignore whitespace
.           { return *yytext; }

%%

int yywrap() { return 1; }
