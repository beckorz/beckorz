#ifndef _YAHTZEE_H
#define _YAHTZEE_H
/*
���f�[�^�^���̃T�C�Y�o������
	char:0�`255
	BYTE:-128�`127
	UBYTE:0�`255
	WORD:-32768�`32768
	UWORD:0�`65535

��printf����������o������(%03d�Ƃ��Ō������͂ł��Ȃ��患)
	%c:����(char)
	%d:10�i��(BYTE:-128�`127)
	%u:10�i��(UBYTE:0�`255)
	%o:8�i��(UBYTE:0�`0377)
	%x:16�i��(UBYTE:0�`0xff)
	%s:������(char�z��)
	%ld:10�i��(WORD:-32768�`32768)
	%lu:10�i��(UWORD:0�`65535)
	%lo:8�i��(UWORD:0�`0177777)
	%lx:16�i��(UWORD:0�`0xffff)
*/

#define SAVE_NAME "Yahtzee"

void title();

#endif /* _YAHTZEE_H */
