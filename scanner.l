%{
int lineno = 1;
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define AUTO 1
#define BREAK 2
#define CASE 3
#define CHAR 4
#define CONST 5
#define CONTINUE 6
#define DEFAULT 7
#define DO 8
#define DOUBLE 9
#define ELSE 10
#define ENUM 11
#define EXTERN 12
#define FLOAT 13
#define FOR 14
#define GOTO 15
#define IF 16
#define INT 17
#define LONG 18
#define REGISTER 19
#define RETURN 20
#define SHORT 21
#define SIGNED 22
#define SIZEOF 23
#define STATIC 24
#define STRUCT 25
#define SWITCH 26
#define TYPEDEF 27
#define UNION 28
#define UNSIGNED 29
#define VOID 30
#define VOLATILE 31
#define WHILE 32

#define IDENTIFIER 33
#define SLC 34
#define MLCS 35
#define MLCE 36

#define LEQ 37
#define GEQ 38
#define EQEQ 39
#define NEQ 40
#define LOR 41
#define LAND 42
#define ASSIGN 43
#define PLUS 44
#define SUB 45
#define STAR 46
#define DIV 47
#define MOD 48
#define LESSER 49
#define GREATER 50
#define INCR 51
#define DECR 52

#define COMMA 53
#define SEMI 54

#define HEADER 55
#define MAIN 56

#define PRINTF 57
#define SCANF 58
#define DEFINE 59

#define INT_CONST 60
#define FLOAT_CONST 61

#define TYPE_SPEC 62

#define DQ 63

#define OBO 64
#define OBC 65
#define CBO 66
#define CBC 67
#define HASH 68
#define QM 93

#define ARR 69
#define FUNC 70

#define NUM_ERR 71
#define UNKNOWN 72

#define CHAR_CONST 73
#define SIGNED_CONST 74
#define STRING_CONST 75
#define HEX_CONST 81

#define GETCH 76
#define STRLEN 77
#define STRCMP 78
#define STRCPY 79
#define STRINGH 80

#define AMPERSAND 82
#define BOR 83
#define BLS 84
#define BRS 85
#define XOR 86
#define NOT 87

#define MEMBER 88
#define PTR_MEMBER 89
#define PRAGMA 90
#define INCLUDE 91
#define LINE 92
%}

alpha [A-Za-z]
digit [0-9]
und [_]
space [ ]
tab [	]
line [\n]
char \'.\'
at [@]
string \"([^\\\"]|\\.)*\"

%%
{space}* {}
{tab}* {}
{string} return STRING_CONST;
{char} return CHAR_CONST;
{line} {lineno++;}
auto return AUTO;
break return BREAK;
case return CASE;
char return CHAR;
const return CONST;
continue return CONTINUE;
default return DEFAULT;
do return DO;
double return DOUBLE;
else return ELSE;
enum return ENUM;
extern return EXTERN;
float return FLOAT;
for return FOR;
goto return GOTO;
if return IF;
int return INT;
long return LONG;
register return REGISTER;
return return RETURN;
short return SHORT;
signed return SIGNED;
sizeof return SIZEOF;
static return STATIC;
struct return STRUCT;
switch return SWITCH;
typedef return TYPEDEF;
union return UNION;
unsigned return UNSIGNED;
void return VOID;
volatile return VOLATILE;
while return WHILE;

printf return PRINTF;
scanf return SCANF;

getch return GETCH;
strlen return STRLEN;
strcpy return STRCPY;
strcmp return STRCMP;

[<]({alpha}|{digit}|{und}|[.])+[>] return HEADER;
"#pragma" return PRAGMA;
"#include" return INCLUDE;
"#line" return LINE;
"#define" return DEFINE;
"main()" return MAIN;

{alpha}({alpha}|{digit}|{und})* return IDENTIFIER;

[+-][0-9]{digit}*(\.{digit}+)? return SIGNED_CONST;
0[xX][0-9a-fA-F]+  return HEX_CONST;

"//" return SLC;
"/*" return MLCS;
"*/" return MLCE;

"->" return PTR_MEMBER;
"." return MEMBER;

"<=" return LEQ;
">=" return GEQ;
"==" return EQEQ;
"!=" return NEQ;
"||" return LOR;
"&&" return LAND;

"|" return BOR;
"&" return AMPERSAND;
"<<" return BLS;
">>" return BRS;
"~" return NOT;
"^" return XOR;

"=" return ASSIGN;
"+" return PLUS;
"-" return SUB;
"*" return STAR;
"/" return DIV;
"%" return MOD;
"<" return LESSER;
">" return GREATER;
"++" return INCR;
"--" return DECR;

"," return COMMA;
";" return SEMI;



{digit}+ return INT_CONST;
({digit}+)\.({digit}+) return FLOAT_CONST;

"%d"|"%f"|"%u"|"%s"|"%li"|"%ld"|"%lf"|"%p"|"%x"|"%o" return TYPE_SPEC;
"\"" return DQ;
"(" return OBO;
")" return OBC;
"{" return CBO;
"}" return CBC;
"#" return HASH;
"?" return QM;

{alpha}({alpha}|{digit}|{und})*\[({digit}*|{alpha}({alpha}|{digit}|{und})*)\] return ARR;
{alpha}({alpha}|{digit}|{und})*\(({alpha}|{digit}|{und}|{space})*\) return FUNC;
({digit}+)\.({digit}*)\.({digit}|\.)* return NUM_ERR;
({digit}|{at})+({alpha}|{digit}|{und}|{at})* return UNKNOWN;
%%

struct node
{
	char token[100];
    	char attr[100];
	struct node *next;
};

struct hash
{
	struct node *head;
	int count;
};

struct hash hashTable[1000];
int eleCount = 1000;

struct node * createNode(char *token, char *attr)
{
	struct node *newnode;
	newnode = (struct node *) malloc(sizeof(struct node));
	strcpy(newnode->token, token);
	strcpy(newnode->attr, attr);
	newnode->next = NULL;
	return newnode;
}

int hashIndex(char *token)
{
    int hp = 59;
	int hi=0;
	int l,i;
	for(i=0;token[i]!='\0';i++)
	{
		hi = (hp*hi) + (int)token[i];
        hi %= eleCount;
	}
	return hi;
}

void insertToHash(char *token, char *attr)
{
	int flag=0;
	int hi;
	hi = hashIndex(token);
	struct node *newnode = createNode(token, attr);
	/* head of list for the bucket with index "hashIndex" */
	if (hashTable[hi].head==NULL)
	{
		hashTable[hi].head = newnode;
	        hashTable[hi].count = 1;
	        return;
	}
	struct node *myNode;
    	myNode = hashTable[hi].head;
	while (myNode != NULL)
    	{
        	if (strcmp(myNode->token, token)==0)
        	{
            		flag = 1;
            		break;
        	}
        	myNode = myNode->next;
    	}
	if(!flag)
	{
		//adding new node to the list
		newnode->next = (hashTable[hi].head);
		//update the head of the list and no of nodes in the current bucket
		hashTable[hi].head = newnode;
		hashTable[hi].count++;
	}
	return;
}

void display()
{
    	struct node *myNode;
    	int i,j, k=1;
    	printf("-------------------------------------------------------------------");
    	printf("\nSNo \t|\tToken \t\t|\tToken Type \t\n");
        printf("-------------------------------------------------------------------\n");
    	for (i = 0; i < eleCount; i++)
    	{
        	if (hashTable[i].count == 0)
            		continue;
        	myNode = hashTable[i].head;
        	if (!myNode)
            		continue;
        	while (myNode != NULL)
        	{
            		printf("%d\t\t", k++);
            		printf("%s\t\t\t", myNode->token);
            		printf("%s\t\n", myNode->attr);
            		myNode = myNode->next;
        	}
	}
   	return;
}

int main(int argc, char** argv)
{
	int scan, slcline=0, mlc=0, mlcline=0, dq=0, dqline=0;
    if (argc >= 2) yyin = fopen(argv[1] ,"r");
	printf("\n");
	scan = yylex();
	while(scan)
	{
		if(lineno == slcline)
		{
			scan = yylex();
			continue;
		}
		if(lineno!=dqline && dqline!=0)
		{
			if(dq%2!=0)
				printf("\n******** ERROR!! INCOMPLETE STRING at Line %d ********\n\n", dqline);
			dq=0;
		}
		if((scan>=1 && scan<=32) && mlc==0)
		{
			printf("%s\t\t\tKEYWORD\t\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "KEYWORD");
		}
		if(scan==33 && mlc==0)
		{
			printf("%s\t\t\tIDENTIFIER\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "IDENTIFIER");
		}
		if(scan==34)
		{
			printf("%s\t\t\tSingleline Comment\t\tLine %d\n", yytext, lineno);
			slcline = lineno;
		}
		if(scan==35 && mlc==0)
		{
			printf("%s\t\t\tMultiline Comment Start\t\tLine %d\n", yytext, lineno);
			mlcline = lineno;
			mlc = 1;
		}
		else if(scan==35 && mlc==1)
		{
			printf("\n******** ERROR!! NESTED MULTILINE COMMENT at Line %d ********\n\n", lineno);
		}
		if(scan==36 && mlc==0)
		{
			printf("\n******** ERROR!! UNMATCHED MULTILINE COMMENT END %s at Line %d ********\n\n", yytext, lineno);
		}
		if(scan==36 && mlc==1)
		{
			mlc = 0;
			printf("%s\t\t\tMultiline Comment End\t\tLine %d\n", yytext, lineno);
		}
		if((scan>=37 && scan<=52) && mlc==0 && scan != 46)
		{
			printf("%s\t\t\tOPERATOR\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "OPERATOR");
		}
		if(scan==46 && mlc==0)
		{
			printf("%s\t\t\tSTAR\t\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "STAR");
		}
		if((scan==93||scan==53||scan==54||scan==63||(scan>=64 && scan<=68)) && mlc==0)
		{
			printf("%s\t\t\tSPECIAL SYMBOL\t\t\tLine %d\n", yytext, lineno);
			if(scan==63)
			{
				dq++;
				dqline = lineno;
			}
			insertToHash(yytext, "SPECIAL SYMBOL");
		}
		if((scan==55 || scan==80) && mlc==0)
		{
			printf("%s\t\tHEADER\t\t\t\tLine %d\n",yytext, lineno);
			insertToHash(yytext, "HEADER");
		}
		if(scan==56 && mlc==0)
		{
			printf("%s\t\t\tMAIN FUNCTION\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "IDENTIFIER");
		}
		if((scan==57 || scan==58 || scan==76 || scan==77 || scan==78 || scan==79) && mlc==0)
		{
			printf("%s\t\t\tPRE DEFINED FUNCTION\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "PRE DEFINED FUNCTION");
		}
		if((scan==59 || (scan>=90 && scan<=92)) && mlc==0)
		{
			printf("%s\t\tPRE PROCESSOR DIRECTIVE\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "PRE PROCESSOR DIRECTIVE");
		}
		if(scan==60 && mlc==0)
		{
			printf("%s\t\t\tINTEGER CONSTANT\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "INTEGER CONSTANT");
		}
		if(scan==61 && mlc==0)
		{
			printf("%s\t\t\tFLOATING POINT CONSTANT\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "FLOATING POINT CONSTANT");
		}
		if(scan==62 && mlc==0)
		{
			printf("%s\t\t\tTYPE SPECIFIER\t\t\tLine %d\n", yytext, lineno);
		}
		if(scan==69 && mlc==0)
		{
			printf("%s\t\t\tARRAY\t\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "ARRAY");
		}
		if(scan==70 && mlc==0)
		{
			printf("%s\t\t\tUSER DEFINED FUNCTION\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "USER DEFINED FUNCTION");
		}
		if(scan==71 && mlc==0)
		{
			printf("\n******** ERROR!! CONSTANT ERROR %s at Line %d ********\n\n", yytext, lineno);
		}
		if(scan==72 && mlc==0)
		{
			printf("\n******** ERROR!! UNKNOWN TOKEN %s at Line %d ********\n\n", yytext, lineno);
		}
		if(scan==73 && mlc==0)
		{
			printf("%s\t\t\tCHARACTER CONSTANT\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "CHARACTER CONSTANT");
		}
		if(scan==74 && mlc==0)
		{
			printf("%s\t\t\tSIGNED CONSTANT\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "SIGNED CONSTANT");
		}
		if(scan==75 && mlc==0)
		{
			printf("%s\t\t\tSTRING CONSTANT\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "STRING CONSTANT");
		}
		if(scan==81 && mlc==0)
		{
			printf("%s\t\t\tHEXADECIMAL CONSTANT\t\tLine %d\n",yytext, lineno);
			insertToHash(yytext, "HEXADECIMAL CONSTANT");
		}
		if(scan==82 && mlc==0)
		{
			printf("%s\t\t\tAMPERSAND\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "AMPERSAND");
		}
		if((scan>=83 && scan<=87) && mlc==0)
		{
			printf("%s\t\t\tBITWISE OPERATOR\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "BITWISE OPERATOR");
		}
		if((scan==88 || scan==89) && mlc==0)
		{
			printf("%s\t\t\tMEMBER ACCESS OPERATOR\t\tLine %d\n",yytext, lineno);
			insertToHash(yytext, "MEMBER ACCESS OPERATOR");
		}		

		scan = yylex();
	}
	if(mlc==1)
		printf("\n******** ERROR!! UNMATCHED COMMENT STARTING at Line %d ********\n\n",mlcline);
	printf("\n");
	printf("\n\t******** SYMBOL TABLE ********\t\t\n");
	display();
    printf("-------------------------------------------------------------------\n\n");
}
int yywrap()
{
	return 1;
}
