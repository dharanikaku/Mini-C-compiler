%{
#include <stdio.h>
#include <stdlib.h>
#include<string.h>


#include<ctype.h>

extern FILE *yyin;

//char* ex_status=malloc(sizeof(char)*10);
char ex_status[10]="true";
char* is_substring(char *a,char *b);
void print(char *,char *);
char* is_substring(char *a,char *b);
char* stripall(char *,char* );
char* strip(char *,char* );

//strcpy(ex_status,"true");

int count=0;

char* int_to_str(int);
char *recent_type[20];

 struct pl
{
	char type[20];
	char name[30];

};

struct pl F[100],sto[10];
//int fs_count1=0;
//int fs_count2=0;


struct sym{
	
	char name[30];
	//name=malloc(sizeof(char)*30);
	char type[30];
	char *value;

};

struct sym S[500];


void make_struct(char *,char *);
int find(char *);
void symboltable();
void assign(char *,char *);
char* arthematic_op(char *,char *,char *);
char* validate(char *,char *,char *);

%}

%union{

char *f;
//struct sym *S_V;
int t;

}

%type <f> TYPE DECLARATION START ASSIGNMENT FUNCTION Stmt StmtList CompoundStmt Arg ArgList ArgListOpt Expr IfStmt PrintStmt ;

%token <f> CHAR EQ F1 F2 PLUS SC SSTRING idlist STRIP STRIPALL qchar;
%token <f> INT;
%token <f> DOUBLE;
%token <f> FLOAT;
//%type <S_V> STRUCT_VARIABLE;
%token <f> num;
%token <f> id;
%token <f> IF ELSE PRINTF INPRINT1 INPRINT2;

%left <f> '<' '>' LE GE DE NE LT GT;




%%

START :	FUNCTION  {printf("sucessfully executed ,start state is reached.... "); printf("sym entries:%s %s\n",S[0].value,S[1].value); symboltable();}
	| DECLARATION {printf("yes");}
      ;

FUNCTION: TYPE id '(' ArgListOpt ')' CompoundStmt 
	;

ArgListOpt: ArgList {}
	| %empty {}
         ;

ArgList:  ArgList ',' Arg {}
	| Arg {}
	;


Arg    : TYPE id 
      ;

CompoundStmt:	F1 StmtList F2 {printf("compst %s\n",$2);}
	;
StmtList:	StmtList Stmt {printf(" more stmlist %s %s\n",$1,$2); strcat($1,$2);  strcat($1," "); strcpy($$,$1); }
	| Stmt  {printf("stmlist %s\n",$1);}
	
	;


Stmt: DECLARATION {printf("stmt %s\n",$$);}
	| SC
        | IfStmt {}
        | PrintStmt
	
    ;


DECLARATION: TYPE ASSIGNMENT SC {printf("declare %s\n",$$); make_struct($1,$2); strcat($1," ");  strcat($1,$2);  strcat($1,";"); strcpy($$,$1); 
		}
	| ASSIGNMENT SC {strcat($1,";"); strcpy($$,$1);}
    
	;

TYPE :	INT {printf("type %s\n",$$); strcpy(recent_type,"int");}
	| FLOAT
	| CHAR
	| DOUBLE
	;

IfStmt : IF '(' Expr ')'  { if(strcmp($3,"false")==0) {strcpy(ex_status,"false");} }
	 CompoundStmt {if(strcmp(ex_status,"false")==0) {strcpy(ex_status,"true"); strcpy($$,"false"); } else {strcpy($$,"true");}}
	|  IfStmt  ELSE {if(strcmp($1,"true")==0) strcpy(ex_status,"false"); }  CompoundStmt {if(strcmp(ex_status,"false")==0) strcpy(ex_status,"true");}
	;



PrintStmt : PRINTF '(' INPRINT1 INPRINT2 ')' SC  { print($3,$4); }
	;


ASSIGNMENT : id EQ ASSIGNMENT  {     printf("assgn %s %s %s %s\n",$$,$1,$2,$3); assign($1,$3);strcat($2,$3);strcat($1,$2);strcpy($$,$1);//;
				} 
   | id PLUS ASSIGNMENT {$$=arthematic_op($1,$2,$3);}

   | id '*' ASSIGNMENT {$$=arthematic_op($1,"*",$3);}
   | id '/' ASSIGNMENT {$$=arthematic_op($1,"/",$3);}
   | id '-' ASSIGNMENT {$$=arthematic_op($1,"-",$3);}
   | num PLUS ASSIGNMENT {$$=arthematic_op($1,$2,$3);}
   | num '-' ASSIGNMENT {$$=arthematic_op($1,"-",$3);}
   | num '*' ASSIGNMENT {$$=arthematic_op($1,"*",$3);}
   | num '/' ASSIGNMENT {$$=arthematic_op($1,"/",$3);}
   |"-" ASSIGNMENT {}
   |'(' ASSIGNMENT ')' {$$=$2;}
   | '-' num {}
   | '-' id {//$$=negative($2);
	}
   |STRIP '(' idlist  qchar ')' { $$=strip($3,$4);}
   |STRIPALL '(' idlist  qchar ')' { $$=stripall($3,$4);}
   |num  {  $$=$1;}
   | idlist { printf("idlist %s\n",$1);}
   |id {}
   ;




/*idlist : idlist CAMA id {strcat($1,$2); strcat($1,$3); strcpy($$,$1); printf("idl %s\n",$$); }
	|id {printf("id---%s\n",$1);}
	;*/

Expr:	
	  ASSIGNMENT LE Expr {$$=validate($1,$2,$3);}
	|  ASSIGNMENT GE Expr {$$=validate($1,$2,$3);}
	|  ASSIGNMENT LT Expr {$$=validate($1,$2,$3);}
	| ASSIGNMENT GT Expr {$$=validate($1,$2,$3);}
	| ASSIGNMENT DE Expr {$$=validate($1,$2,$3);}
	| ASSIGNMENT NE Expr {$$=validate($1,$2,$3);}
	| ASSIGNMENT {$$=$1;}
        ;




%%


//#include"lex.yy.c"


char* is_substring(char *a,char *b)
{
	char *c;
	c=malloc(sizeof(char)*5);
	c="false";
	int status=1;	
	int i,j,length,k,z;
	length=strlen(b);
	for(i=0;i<length;i++)
	{
		status=1;
		if(a[0]==b[i])
		{
			c="true";
			j=strlen(a);
			z=1;
			while(z<j)
			{
				if(a[z]!=b[i+z])
				{
					status=0;
					c="false";
					break;			
				}
				z++;		
			}
			if(status==1)
				break;
						

		}
		
	}
	return c;
}	

int find(char *a)
{
	int i;
	for(i=0;i<count;i++)
	{
		if(strcmp(S[i].name,a)==0)
			return i;
	}
	return -1;
}

char* int_to_str(signed int n)
{
	int negative=0;
	if(n<0)
	{
		n=n*-1;	
		negative=1;
	}
	char *string;
	string=malloc(sizeof(char));
	int tmp,i,count=0,length;
	char c;
	while(n>0)
	{
		tmp=n%10;
		c=tmp+'0';
		realloc(string,(sizeof(char)));
		string[count]=c;
		count++;
		n=n/10;
	}
	if(negative==1)
	{
		string[count]='-';
		count++;
	}	
	string[count]='\0';
	length=strlen(string);
	for(i=0;i<(length/2);i++)
	{
		c=string[i];
		string[i]=string[length-1-i];
		string[length-1-i]=c;

	}

	return string;
}


void make_struct(char *a,char *b)
{
	int length,i,cou=0;
	length=strlen(b);
	char *name;
	name=malloc(sizeof(char));
	if(strcmp(ex_status,"true")==0)
	{
	
		for(i=0;i<length;i++)
		{
			if(b[i]==',' || b[i]=='\0')
			{
				
				name[cou]='\0'; 
				cou=0;
				if(find(name)!=-1)
				{
					strcpy(S[count].name,name);
	
					strcpy(S[count].type,a);
			
					S[count].value=malloc(sizeof(char));
					strcpy(S[count].value,"");
					count=count+1;
				}

			}
			else
			{
			
				name[cou]=b[i];
				realloc(name,(sizeof(char)));
				cou=cou+1;
			}							
		}
			
	} 
}
 
void assign(char *a,char *b)
{
	int m,n;
	char *c=malloc(sizeof(char)*(m+n+5));
	c="";
        char t;
	int index,index1,fir_ind,sec_ind;
        t=b[0];
	if(strcmp(ex_status,"true")==0)
	{
		index=find(a);
		if(index!=-1)
		{


			if ((t>=97 && t<=122)||(t>=65 && t<=90))
			{

				S[index].value=b;
				strcpy(S[index].type,"string");
		
			}
			else
			{

				if(strcmp(S[index].type,"int")==0 && (t=='0' || t=='1' || t=='2' || t=='3' || t=='4' || t=='5' || t=='6' || t=='7' || t=='8' || t=='9' || t=='-'))
			 	{
			      		strcpy(S[index].value,b);
					strcpy(S[index].type,"int");
			 	}	
				else
				{
					index1=find(b);
					
					if(strcmp(S[index].type,S[index1].type)==0)
						strcpy(S[index].value,S[index1].value);			
				}
			}
		}
		else
		{
			strcpy(S[count].name,a);
	
			strcpy(S[count].type,recent_type);
		
			S[count].value=malloc(sizeof(char));
			strcpy(S[count].value,b);
			count=count+1;	
			
		} 
	
	}      
}
void negative(char *p)
{
	int i;
	for(i=0;i<count;i++)
	{

	}
}	

char* arthematic_op(char *a,char *b,char *c)
{
	int m,n,res,index;
	char *d;
	if(strcmp(ex_status,"true")==0)
	{
		index=find(a);
		if(index==-1)
			m=atoi(a);
		else
			m=atoi(S[index].value);
		index=find(c);
		if(index==-1)
			n=atoi(c);
		else
			n=atoi(S[index].value);
		d=malloc(sizeof(char)*(m+n));
	
		if(strcmp(b,"+")==0)
		{
			res=m+n;
			d=int_to_str(res);
		}
		else if(strcmp(b,"-")==0)
		{
			res=m-n;
			d=int_to_str(res);

		}
		else if(strcmp(b,"*")==0)
		{
			res=m*n;
			d=int_to_str(res);

		}
		else if(strcmp(b,"/")==0)
		{
			res=m/n;
			d=int_to_str(res);

		}
		return d;
	}
	else
	{
		d=malloc(sizeof(char)*2);
		d="";
		return d;
	}
	
}

char* validate(char *a,char *b,char *c)
{
	int t,index,m,n;
	char *d;
	char *u=malloc(sizeof(char)*7);
	if(strcmp(ex_status,"true")==0)
	{
		u="true";
		index=find(a);
		if(index==-1)
			m=atoi(a);
		else
			m=atoi(S[index].value);
		index=find(c);
		if(index==-1)
			n=atoi(c);
		else
			n=atoi(S[index].value);
	
		if(strcmp(b,"<=")==0)
		{
			if(m<=n)
				return u;
			else
			{ 
				u="false";
				//strcpy(ex_status,"false");
				return u;	
			}
		}
		else if(strcmp(b,">=")==0)
		{
		
			if(m>=n)
				return u;
			else
			{ 
				u="false";
				//strcpy(ex_status,"false");
				return u;	
			}
		
		}
		else if(strcmp(b,"==")==0)
		{
			if(m==n)
				return u;
			else
			{ 
				u="false";
				//strcpy(ex_status,"false");
				return u;	
			}
		
		}
		else if(strcmp(b,"!=")==0)
		{
			if(m!=n)
				return u;
			else
			{ 
				u="false";
				//strcpy(ex_status,"false");
				return u;	
			}
		}
		else if(strcmp(b,"<")==0)
		{
			if(m<n)
				return u;
			else
			{ 
				u="false";
				//strcpy(ex_status,"false");
				return u;	
			}
		}
		else if(strcmp(b,">")==0)
		{
		
			if(m>n)
				return u;
			else
			{ 
				u="false";
				//strcpy(ex_status,"false");
				return u;	
			}		
		}
	
		return u;
	}
	else
	{
		d=malloc(sizeof(char));
		d="";
		return d;

	}
}

void print(char *a,char *b)
{
	int cou=0;
	int fs_count1=0;
	 int fs_count2=0;
	char *d=malloc(sizeof(char)*10);
	
	char *ip=malloc(sizeof(char)*7);
	//char *p=malloc(sizeof(char)*25);
	char p[10];
	char q[10];
	int i,j,length,index;
	length=strlen(a);
	for(i=0;i<length;i++)
	{
		strcpy(d,"false");
		if(a[i]=='%')
		{
			p[0]=a[i];
			p[1]=a[i+1];
			p[2]='\0';
			d=is_substring(p,a);
			
		}
		
		if(strcmp(d,"true")==0)
		{
			
			length=strlen(p);
		
			//F[fs_count1].type=malloc(sizeof(char)*(length));
			strcpy(F[fs_count1].type,p);
			strcpy(p,"");
			fs_count1=fs_count1+1;
		}
	}
	//printf("ggg%s ",F[fs_count1-1].type);
	length=strlen(b);
	for(i=0;i<length;i++)
	{
		if(b[i]==',')
		{
			cou=0;
			for(j=i+1;;j++)
			{
				if(b[j]==',' || b[j]=='\0')
					break;	
				q[cou]=b[j];
				cou=cou+1;
				
			}
			q[cou]='\0';
			strcpy(F[fs_count2].name,q);
			strcpy(q,"");
			fs_count2=fs_count2+1;						
		}
	}
	for(i=0;i<fs_count1;i++)
	{
		index=find(F[i].name);
		if((strcmp(F[i].type,"%d")==0 && strcmp(S[index].type,"int")==0) || (strcmp(F[i].type,"%s")==0 && strcmp(S[index].type,"string")==0))
		{
			printf("printf %s \n",S[index].value);
		}
		else
		{
			printf("please specify correct format specifier\n");
		}

	}
					
}


void symboltable()
{
	int i;
	printf("------------------------------------------------------\n");
	printf("type  variable  value\n");
	for(i=0;i<count;i++)
	{
		printf("%s     %s       %s  \n" ,S[i].type,S[i].name,S[i].value);
	}
}


char* stripall(char *a,char *ch)
{
	char *new;
	char c;
	new=malloc(sizeof(char));
	int i,length,cou=0;
	length=strlen(a);
	a[length-1]='\0';
	int index=find(a);
	length=strlen(S[index].value);
	for(i=0;i<length;i++)
	{
		c=S[index].value[i];
		if(c!=ch[1])
		{
			new[cou]=c;
			realloc(new,(sizeof(char)));
			cou++;					
		}
	}
	return new;	
}

char* strip(char *a,char *ch)
{
	char *new;
	char c;
	int status=0,cou=0;
	new=malloc(sizeof(char));
	int i,length;
	length=strlen(a);
	a[length-1]='\0';
	int index=find(a);
	length=strlen(S[index].value);
	for(i=0;i<length;i++)
	{
		c=S[index].value[i];
		if(c==ch[1] && status==0)
		{
			status=1;
			continue;
		}
		new[cou]=c;
		cou++;			
	}
	return new;
}





int main()
{
      //FILE *fp1;
	
	yyin = fopen("input.c", "r");
	yyparse();
   /*if(!yyparse())
		printf("\nParsing complete\n");
	else
		printf("\nParsing failed\n");*/
	
//fclose(fp1);
    return 0;
}

         
yyerror() {
	printf("error\n");
}         

