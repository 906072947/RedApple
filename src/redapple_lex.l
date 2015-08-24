%{
#include <string>
#include "redapple_parser.hpp"

#define SAVE_TOKEN     yylval.str = maketoken(yytext, yyleng)
#define SAVE_STRING    yylval.str = makestring(yytext, yyleng, 2)
#define SAVE_STRING_NC yylval.str = makestring(yytext, yyleng, 3)
extern "C" int yywrap() { return 1; }
char* maketoken(const char* data, int len);
char* makestring(const char* data, int len, int s);

%}

%%

"/*"([^\*]|(\*)*[^\*/])*(\*)*"*/" ; /* 就是这种注释 */ 

#[^\n]*\n               ; /* 井号注释 */ 
"//"[^\n]*\n            ; /* 双线注释 */ 

[ \t\v\n\f]             ; /* 过滤空白字符 */

[0-9]*\.[0-9]*          SAVE_TOKEN; return DOUBLE;
(\+|\-)?[0-9]+          SAVE_TOKEN; return INTEGER;

"=="                    SAVE_TOKEN; return CEQ;
"<="                    SAVE_TOKEN; return CLE;
">="                    SAVE_TOKEN; return CGE;
"!="                    SAVE_TOKEN; return CNE;

"<"                     SAVE_TOKEN; return '<';
"="                     SAVE_TOKEN; return '=';
">"                     SAVE_TOKEN; return '>';
"("                     return '(';
")"                     return ')';
"["                     return '[';
"]"                     return ']';
"{"                     return '{';
"}"                     return '}';
"."                     return '.';
","                     return ',';
":"                     return ':';
";"                     return ';';
"+"                     SAVE_TOKEN; return '+';
"-"                     SAVE_TOKEN; return '-';
"*"                     SAVE_TOKEN; return '*';
"/"                     SAVE_TOKEN; return '/';
"%"                     SAVE_TOKEN; return '%';
"^"                     SAVE_TOKEN; return '^';
"&"                     SAVE_TOKEN; return '&';
"|"                     SAVE_TOKEN; return '|';
"~"                     SAVE_TOKEN; return '~';

	/* 下面声明要用到的关键字 */

	/* 控制流 */
"if"					return IF;
"else"					return ELSE;
"while"					return WHILE;
"do"					return DO;
"goto"					return GOTO;
"for"					return FOR;
"foreach"				return FOREACH;

	/* 退出控制 */
"break" | "continue" | "exit" 
						SAVE_TOKENl; return KWS_EXIT;

"return" 				return RETURN;

	/* 特殊运算符 */
"new"					return NEW;
"this"					return THIS;
	
	/* 特殊定义 */
"delegate"				return DELEGATE;
"def"					return DEF;
"define"				return DEFINE;
"import"				return IMPORT;
"using"					return USING;
"namespace"				return NAMESPACE;

"try" | "catch" | "finally" | "throw" 
						SAVE_TOKEN; return KWS_ERROR; /* 异常控制 */

"null" | "true" | "false"
						SAVE_TOKEN; return KWS_TSZ; /* 特殊值 */

"struct" | "enum" | "union" | "module" | "interface" | "class"
						SAVE_TOKEN; return KWS_STRUCT; /* 结构声明 */

"public" | "private" | "protected"
						SAVE_TOKEN; return KWS_FWKZ; /* 访问控制 */

"const" | "static" | "virtual" | "abstract" | "in" | "out" 
						SAVE_TOKEN; return KWS_FUNC_XS; /* 函数修饰符 */

"void" |"double" | "int" | "float" | "char" | "bool" | "var" | "auto" /* 基本类型 */
						SAVE_TOKEN; return KWS_TYPE;

[a-zA-Z_][a-zA-Z0-9_]*  SAVE_TOKEN; return ID;

\"(\\.|[^\\"])*\"       SAVE_STRING; return STRING; /* 字符串 */
@\"(\\.|[^\\"])*\"      SAVE_STRING_NC; return STRING; /* 无转义字符串 */
\'(\\.|.)\'             SAVE_STRING; return CHAR;   /* 字符 */

.                       printf("Unknown Token!\n"); yyterminate();

%%


char* maketoken(const char* data, int len) {
	char* str = new char[len+1];
	strncpy(str, data, len);
	str[len] = 0;
	return str;
}

char* makestring(const char* data, int len, int s) {
	char* str = new char[len-s+1];
	strncpy(str, data+s-1, len-s);
	str[len-s] = 0;
	return str;
}