#include <stdio.h>
#include <gb.h>
#include "Yahtzee.h"

extern SaveName[];
extern UWORD HighScore;
extern UWORD ExecCount;

void main() {
	// ú»(ÅåÌ17~16^C)
	init_elisagb(0, 0, 17, 16);
	if (strcmp(SaveName, SAVE_NAME)) {
		strcpy(SaveName, SAVE_NAME);
		HighScore = 0;
		ExecCount = 0;
	}
	ExecCount++;
	
	// ^CgæÊ\¦
	title();
	
	// Æè ¦¸ELISAGBÌeXg
	ecls();
	gotoexy(0, 0);
	eputs("\
PQRSTUVWXOPQRSTUV\
 ¡¢£¤¥¦§¨©ª«¬­®¯\
°±²³´µ¶·¸¹º»¼½¾¿À\
ÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑ\
ÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâ\
ãäåæçèéêëìíîïðñ@A\
BCDEFGHIJKLMNOPQR\
STUVWXYZ[\\]^_`abc\
defghijklmnopqrst\
uvwxyz{|}~\
@\
\
`abcdefghijklmnop\
IFGijopuvABH\
«¿¾ß¶eXg@U@@@@\
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
");
}

/*
	^CgæÊ\¦
*/
void title() {
	char score[6];
	char execCount[6];
	UBYTE key;
	
	// ^Cg\¦
	ecls();
	gotoexy(5, 3);
	eputs("Yahtzee!");
	gotoexy(2, 6);
	eputs("High Score:");
	sprintf(score, "%lu", HighScore);
	eputs(score);
	gotoexy(4, 12);
	eputs("PUSH START");
	
	gotoexy(0, 13);
	eputs("N®ñF");
	sprintf(execCount, "%lu", ExecCount);
	eputs(execCount);
	
	// START or A{^üÍÒ¿
	waitpad(J_START | J_A);
	waitpadup();
}
