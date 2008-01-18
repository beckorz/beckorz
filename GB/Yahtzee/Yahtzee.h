#ifndef _YAHTZEE_H
#define _YAHTZEE_H
/************************************************************************
 * GBDK Tips
 *
 * ���ϐ��̐錾�Ɠ����ɏ������̒���
 * 	�O���[�o���ϐ���static�ȕϐ���錾�Ɠ����ɏ����������
 * 	const�C���q��t���������ɂȂ��Ă��܂��炵���̂Œ��ӁB
 * 	�錾�Ɠ����ɏ��������Ȃ��Ă�ANSI-C�ł�0���������ۏ؂���Ă���H
 * 
 * ��1�̔z��̗v�f����127�����E
 * 	�R���p�C���̐����炵���H
 * 
 * ���f�[�^�^���̃T�C�Y�o������
 * 	char:0�`255
 * 	BYTE:-128�`127
 * 	UBYTE:0�`255
 * 	WORD:-32768�`32768
 * 	UWORD:0�`65535
 * 
 * ��printf����������o������(%03d�Ƃ��Ō������͂ł��Ȃ��患)
 * 	%c:����(char)
 * 	%d:10�i��(BYTE:-128�`127)
 * 	%u:10�i��(UBYTE:0�`255)
 * 	%o:8�i��(UBYTE:0�`0377)
 * 	%x:16�i��(UBYTE:0�`0xff)
 * 	%s:������(char�z��)
 * 	%ld:10�i��(WORD:-32768�`32768)
 * 	%lu:10�i��(UWORD:0�`65535)
 * 	%lo:8�i��(UWORD:0�`0177777)
 * 	%lx:16�i��(UWORD:0�`0xffff)
 ************************************************************************/

#define SAVE_NAME "Yahtzee"

// ��
typedef enum _HAND {
	ACES,
	TWOS,
	THREES,
	FOURS,
	FIVES,
	SIXES,
	BONUS,
	THREEOFAKIND,
	FOUROFAKIND,
	FULLHOUSE,
	SMALLSTRAIGHT,
	LARGESTRAIGHT,
	YAHTZEE,
	CHANCE,
	HAND_MAX
} HAND;

// �v���g�^�C�v�錾�Q
void init();
BYTE title();
BYTE isKonamiKeys(UBYTE);
void eputsFmtUW(UWORD, BYTE, void *);
void game();

#endif /* _YAHTZEE_H */
