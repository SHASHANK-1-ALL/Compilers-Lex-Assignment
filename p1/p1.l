
%{
	char board[9][9] =	{ 
							{' ','a','b','c','d','e','f','g','h'},
							{'1','R','N','B','Q','K','B','N','R'},
							{'2','P','P','P','P','P','P','P','P'},
							{'3',' ',' ',' ',' ',' ',' ',' ',' '},
							{'4',' ',' ',' ',' ',' ',' ',' ',' '},
							{'5',' ',' ',' ',' ',' ',' ',' ',' '},
							{'6',' ',' ',' ',' ',' ',' ',' ',' '},
							{'7','P','P','P','P','P','P','P','P'},
							{'8','R','N','B','Q','K','B','N','R'}
						};
%}


%%
[RNBQK][a-h][1-8][x-][a-h][1-8]	{
									board[yytext[5]-'0'][yytext[4]-'a'+1] = yytext[0];
									board[yytext[2]-'0'][yytext[1]-'a'+1] = ' ';
								}
[a-h][1-8][x-][a-h][1-8]	{
								board[yytext[4]-'0'][yytext[3]-'a'+1] = 'P';
								board[yytext[1]-'0'][yytext[0]-'a'+1] = ' ';
							}
[ \n]	/* newline or space*/;
[a-h][1-8]=[a-h][1-8]	{
							board[yytext[4]-'0'][yytext[3]-'a'+1] = 'Q';
							board[yytext[1]-'0'][yytext[0]-'a'+1] = ' ';
						}
<<EOF>>   {return 0;}
%%

int yywrap(void){}

int main()
{	
	yylex();
	for(int i=0;i<9;i++)
	{
		for(int j=0;j<9;j++)
		{
			printf("%c	",board[i][j]);
		}
		printf("\n\n");
	}
	return 0;
}
