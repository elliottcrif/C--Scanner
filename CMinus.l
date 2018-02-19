/****************************************************/
/* File: CMinus.l                                   */
/* Lex specification for C- language from           */
/* Compiler Construction: Principles and Practice   */
/*                                                  */
/* To compile and run:                              */
/*   flex CMinus.l                                  */
/*   g++ lex.yy.c                                   */
/*   ./a.out < cminusfilename                       */
/* Note the redirection arrow, < , is needed.       */
/****************************************************/

%{
#include <iostream>
#include <iomanip>

using namespace std;
/*
   This enum will be replaced in more advanced versions
   with the generated enum from bison
*/
typedef enum

   {
       /* book-keeping tokens */
       ENDFILE, ERROR,

    /* reserved words */
    ELSE, IF, INT, RETURN, VOID, WHILE,

    /* special symbols */
    PLUS, MINUS, TIMES, OVER, LT, LE, GT, GE, EQ, NE, ASSIGN,
    SEMI, COMMA, DOT, LPAREN, RPAREN, LBRACK, RBRACK, LBRACE, RBRACE,

    /* Comment tokens, currently not used */
    LCOMMENT, RCOMMENT,

    /* multicharacter tokens */
    ID, NUM
   } TokenType;

/* These methods are defined below and show how to skip
   comments.
*/
void skipcmnts(void);

/* lexeme of identifier or reserved word */
string tokenString;

/* line number counter */
int lineno = 1;
%}

%option noyywrap 

newline     \n
whitespace  [ \t]+
digit       [0-9]
num         {digit}+
letter      [a-zA-Z]
id  	    {letter}+

%%

"if"		{return IF;}
"else"		{return ELSE;}
"int"		{return INT;}
"return"	{return RETURN;}
"void"		{return VOID;}
"while"		{return WHILE;}

"+"		{return PLUS;}
"-"		{return MINUS;}
"*"		{return TIMES;}
"/"		{return OVER;}
"<"		{return LT;}
"<="		{return LE;}
">"		{return GT;}
">="		{return GE;}
"=="		{return EQ;}
"!="		{return NE;}

"="		{return ASSIGN;}
";"		{return SEMI;}
","		{return COMMA;}
"."		{return DOT;}

"("		{return LPAREN;}
")"		{return RPAREN;}
"["		{return LBRACK;}
"]"		{return RBRACK;}
"{"		{return LBRACE;}
"}"		{return RBRACE;}

{id}		{return ID;}
{num}		{return NUM;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}

"/*"            { skipcmnts(); }
.               {return ERROR;}
<<EOF>> 	{return ENDFILE;}


%%


/* Borrowed mostly from TINY.l */
void skipcmnts (void) {
   char previous = '\0';
   char c;
   c = yyinput();
   do
   {
      if (c == EOF) {
         break;
      }
      if (c == '\n') {
         lineno++;
      }
      previous = c;
      c = yyinput();
   } while (previous != '*' || c != '/');

}

/*
   Our main simply scans for tokens until
   we come to the end of the file.
*/
int main(int argc, char** argv) {
    int tokentype;
    do {
        tokentype = yylex();
        cout << setw(4) << lineno << setw(5) << tokentype << setw(10) << yytext << endl;
    } while ( tokentype != ENDFILE);
    return 0;
}
