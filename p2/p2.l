
%{
	bool read_input = false;
	int if_count = 0;
	int else_count = 0;
	bool done = false;
	char indent[1000] = "		"; 
	int select_count = 0;
	int write_count = 0;
	bool check_after_init = false;
	bool check_before_select = true;
%}


%%
#.* /*comments*/;
\n  /*newline*/;
INIT 	{
			fprintf(yyout,"	init();\n");
			check_after_init = true;
		}
^[a-z A-Z _][a-z A-Z 0-9 _]*:" "int	{
										if(check_after_init && check_before_select)
										{
											char * var_name = strtok(yytext,":");
											fprintf(yyout,"	int %s;\n",var_name);
											fprintf(yyout,"	while(1)\n");
											fprintf(yyout,"	{\n");
											read_input = true;
										}
									}
^[a-z A-Z _][a-z A-Z 0-9 _]*" "=" "readInt 	{
												if(read_input)
													fprintf(yyout,"		%s();\n",yytext);
											}
(Select|Delay):" "[0-9]+	{
								if(read_input == false && !done)
								{
									fprintf(yyout,"	while(1)\n");
									fprintf(yyout,"	{\n");
									done = true;
								}
								if(yytext[0] == 'S')
								{	
									select_count++;
									fprintf(yyout,"		select(%s);\n",yytext+8);
									check_before_select = false;
								}
								else
								{
									while(else_count)
									{
										fprintf(yyout,"		}\n");
										else_count--;
									}
									fprintf(yyout,"		delay(%s);\n",yytext+7);
								}
							}	
^(if|IF|If).*	{
					yytext[strlen(yytext)-1] = '\0';
					fprintf(yyout,"		if(%s)\n",yytext+3);
					fprintf(yyout,"		{\n");
					if_count++;
				}
^(else|ELSE|Else):	{
						fprintf(yyout,"		}\n");
						fprintf(yyout,"		else\n");
						fprintf(yyout,"		{\n");
						else_count++;
						write_count--;
					}
[\t 0-9]+{8}	{
					if(select_count == write_count + 1)
					{
						char seven_segment[8];
						for(int i=0,j=0;i<strlen(yytext);i++) 
						{
							if(yytext[i] == '0' || yytext[i] == '1') 
								seven_segment[j++] = yytext[i];

						}
						if(if_count)
						{
							strcat(indent,"	");
							fprintf(yyout,"%swrite(strtol(\"%s\"));\n",indent,seven_segment);
							if_count--;
						}
						else
						{
							if(else_count)
							{
								fprintf(yyout,"%swrite(strtol(\"%s\"));\n",indent,seven_segment);
								fprintf(yyout,"		}\n");
								else_count--;
							}
							else
								fprintf(yyout,"		write(strtol(\"%s\"));\n",seven_segment);
						}
						write_count++;
					}
				}												
<<EOF>>	{fprintf(yyout,"	}\n"); return 0;}					
%%

int yywrap(void){}

int main()
{
	yyout = fopen("output.c","w");

	fprintf(yyout,"#include<stdio.h>\n");
	fprintf(yyout,"#include<stdlib.h>\n");
	fprintf(yyout,"#include<seven_segment.h>\n");
	fprintf(yyout,"int main()\n");
	fprintf(yyout,"{\n");
    yylex();
	fprintf(yyout,"}\n");
    return 0;
}

