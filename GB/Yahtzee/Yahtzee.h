#ifndef _YAHTZEE_H
#define _YAHTZEE_H
/*
กf[^^ฬTCYoฆซ
	char:0`255
	BYTE:-128`127
	UBYTE:0`255
	WORD:-32768`32768
	UWORD:0`65535

กprintfฎถ๑oฆซ(%03dฦฉลตฆอลซศขๆฃ)
	%c:ถ(char)
	%d:10i(BYTE:-128`127)
	%u:10i(UBYTE:0`255)
	%o:8i(UBYTE:0`0377)
	%x:16i(UBYTE:0`0xff)
	%s:ถ๑(charz๑)
	%ld:10i(WORD:-32768`32768)
	%lu:10i(UWORD:0`65535)
	%lo:8i(UWORD:0`0177777)
	%lx:16i(UWORD:0`0xffff)
*/

#define SAVE_NAME "Yahtzee"

void title();

#endif /* _YAHTZEE_H */
