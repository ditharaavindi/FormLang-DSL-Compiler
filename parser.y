%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void yyerror(const char *msg);
int yylex();

char *currentFieldName;
char *currentFieldType;
char *textareaDefault;
char validateJS[8192] = ""; // JavaScript validation logic

char *capitalize(const char *str) {
    char *cap = strdup(str);
    if (cap && strlen(cap) > 0) {
        cap[0] = toupper(cap[0]);
    }
    return cap;
}
%}

%union {
    char *str;
    int num;
}

%token FORM META SECTION FIELD VALIDATE IF ERROR
%token REQUIRED MIN MAX DEFAULT
%token COLON SEMICOLON EQUAL LBRACE RBRACE
%token LBRACK RBRACK COMMA
%token LT GT EQ
%token <str> ID STRING BOOL
%token <num> NUMBER

%type <str> attr attr_block attr_list string_list string_items condition

%%

program:
    FORM ID LBRACE form_body validate_block RBRACE {
        printf("<div style='margin-top: 20px;'>\n");
        printf("<button type=\"submit\">Submit</button>\n</div>\n</form>\n");

        if (strlen(validateJS) > 0) {
            printf("<script>\n");
            printf("document.forms['MyForm'].addEventListener('submit', function(e) {\n");
            printf("%s", validateJS);
            printf("});\n</script>\n");
        }
    }
;

form_body:
    meta_list section_list
;

meta_list:
    | meta_list META ID EQUAL STRING SEMICOLON {
        printf("<!-- Meta: %s = %s -->\n", $3, $5);
    }
;

section_list:
    | section_list SECTION ID LBRACE field_list RBRACE
;

field_list:
    | field_list field
;

field:
    FIELD ID COLON ID attr_block SEMICOLON {
        currentFieldName = $2;
        currentFieldType = $4;
        char *label = capitalize($2);
        printf("<div style='margin-bottom: 12px;'>");

        if (strcmp($4, "checkbox") == 0) {
            int isChecked = strstr($5, "checked") != NULL;
            printf("<label><input type=\"checkbox\" name=\"%s\"%s> %s</label>", $2, isChecked ? " checked" : "", label);
        } else if (strcmp($4, "textarea") == 0) {
            printf("<label>%s:<br><textarea name=\"%s\" %s>%s</textarea></label>", label, $2, $5, textareaDefault ? textareaDefault : "");
            free(textareaDefault); textareaDefault = NULL;
        } else {
            printf("<label>%s:<br><input type=\"%s\" name=\"%s\" %s></label>", label, $4, $2, $5);
        }

        printf("</div>\n");
        free($5);
        free(label);
    }

    | FIELD ID COLON ID {
        currentFieldName = $2;
        currentFieldType = $4;
    } string_list attr_block SEMICOLON {
        char *label = capitalize($2);
        printf("<div style='margin-bottom: 12px;'>");

        if (strcmp($4, "radio") == 0) {
            printf("<label>%s:</label><br>%s", label, $6);
        } else if (strcmp($4, "dropdown") == 0) {
            printf("<label>%s:<br><select name=\"%s\" %s>%s</select></label>", label, $2, $7, $6);
        }

        printf("</div>\n");
        free($6); free($7); free(label);
    }
;

validate_block:
    | VALIDATE LBRACE validations RBRACE
;

validations:
    | validations IF condition LBRACE ERROR STRING SEMICOLON RBRACE {
        char buf[512];
        sprintf(buf, "if ((%s)) { e.preventDefault(); alert(\"%s\"); }\n", $3, $6);
        strcat(validateJS, buf);
    }
;

condition:
    ID LT NUMBER {
        char buf[128];
        sprintf(buf, "Number(document.forms['MyForm'].elements['%s'].value) < %d", $1, $3);
        $$ = strdup(buf);
    }
  | ID GT NUMBER {
        char buf[128];
        sprintf(buf, "Number(document.forms['MyForm'].elements['%s'].value) > %d", $1, $3);
        $$ = strdup(buf);
    }
  | ID EQ NUMBER {
        char buf[128];
        sprintf(buf, "Number(document.forms['MyForm'].elements['%s'].value) == %d", $1, $3);
        $$ = strdup(buf);
    }
;

attr_block:
    /* empty */ { $$ = strdup(""); }
  | attr_list  { $$ = $1; }
;

attr_list:
    attr                { $$ = $1; }
  | attr_list attr      {
        $$ = malloc(strlen($1) + strlen($2) + 2);
        sprintf($$, "%s %s", $1, $2);
        free($1); free($2);
    }
;

attr:
    REQUIRED                        { $$ = strdup("required"); }
  | MIN EQUAL NUMBER                { char buf[32]; sprintf(buf, "min=\"%d\"", $3); $$ = strdup(buf); }
  | MAX EQUAL NUMBER                { char buf[32]; sprintf(buf, "max=\"%d\"", $3); $$ = strdup(buf); }
  | MIN EQUAL STRING                { char buf[64]; sprintf(buf, "min=\"%s\"", $3); $$ = strdup(buf); }
  | MAX EQUAL STRING                { char buf[64]; sprintf(buf, "max=\"%s\"", $3); $$ = strdup(buf); }
  | DEFAULT EQUAL STRING            {
        if (strcmp(currentFieldType, "textarea") == 0) {
            textareaDefault = strdup($3); $$ = strdup("");
        } else {
            char buf[256]; sprintf(buf, "value=\"%s\"", $3); $$ = strdup(buf);
        }
    }
  | DEFAULT EQUAL BOOL              { $$ = strdup(strcmp($3, "true") == 0 ? "checked" : ""); }
  | ID EQUAL NUMBER                 { char buf[64]; sprintf(buf, "%s=\"%d\"", $1, $3); $$ = strdup(buf); }
  | ID EQUAL STRING                 { char buf[256]; sprintf(buf, "%s=\"%s\"", $1, $3); $$ = strdup(buf); }
;

string_list:
    LBRACK string_items RBRACK { $$ = $2; }
;

string_items:
    STRING {
        char buf[256];
        if (strcmp(currentFieldType, "radio") == 0)
            sprintf(buf, "<input type=\"radio\" name=\"%s\" value=\"%s\"> %s<br>\n", currentFieldName, $1, $1);
        else
            sprintf(buf, "<option value=\"%s\">%s</option>\n", $1, $1);
        $$ = strdup(buf);
    }
  | string_items COMMA STRING {
        char *combined = malloc(strlen($1) + 256);
        if (strcmp(currentFieldType, "radio") == 0)
            sprintf(combined, "%s<input type=\"radio\" name=\"%s\" value=\"%s\"> %s<br>\n", $1, currentFieldName, $3, $3);
        else
            sprintf(combined, "%s<option value=\"%s\">%s</option>\n", $1, $3, $3);
        free($1); $$ = combined;
    }
;

%%

int main() {
    printf("<style>"
        "body { background: #f2f2f2; font-family: 'Segoe UI', sans-serif; }"
        ".form-container {"
        "  background: #fff; max-width: 600px; margin: 40px auto; padding: 30px;"
        "  border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1);"
        "}"
        ".form-container label { display: block; font-weight: 500; margin-bottom: 6px; color: #333; }"
        ".form-container input[type='text'], .form-container input[type='password'],"
        ".form-container input[type='number'], .form-container input[type='email'],"
        ".form-container input[type='date'], .form-container select, .form-container textarea {"
        "  width: 100%%; padding: 10px; margin-bottom: 16px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px;"
        "}"
        ".form-container button { padding: 10px 20px; background-color: #007bff; border: none;"
        " border-radius: 4px; color: white; font-size: 16px; cursor: pointer; }"
        ".form-container button:hover { background-color: #0056b3; }"
        "</style>");
    printf("<form name=\"MyForm\" class=\"form-container\">\n");
    return yyparse();
}

void yyerror(const char *msg) {
    fprintf(stderr, "Error: %s\n", msg);
}
