#include <drawing.h>
#include <gb.h>
#include <rand.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bank.h"
#include "elisagb.h"
#include "Yahtzee.h"

// �Z�[�u�f�[�^�Q
extern char SaveName[];	// �Z�[�u�f�[�^���݊m�F�p
extern UWORD HighScore;	// �n�C�X�R�A

// �R�i�~�R�}���h
const UBYTE KonamiKeys[] = { J_UP, J_UP, J_DOWN, J_DOWN, J_LEFT, J_RIGHT, J_LEFT, J_RIGHT, J_B, J_A };

/************************************************************************
 * ���C�����[�`��
 ************************************************************************/
void main() {
	// ������
	init();

	// ���C�����[�v
	while (TRUE) {
		if (title()) {
			game();
		} else {
			// �R�i�~�R�}���h�������ɂ̓n�C�X�R�A�����Z�b�g
			HighScore = 0;
		}
	}
}

/************************************************************************
 * ���������[�`��
 ************************************************************************/
void init() {
	// ELISAGB�̏�����
	// (0, 0, 20, 18)�Ə������������Ƃ��낾���A��������ƂȂ���(0, 6)����2�^�C�������\���ł��Ȃ��Ȃ�B
	// (1, 0, 20, 18)���Ƃ��̌��ۂ��o�Ȃ����̂́A�E��1�h�b�g����邹����
	// �E�[�M���M���܂ŕ�����\�����悤�Ƃ���Ɠ��s�̍����ɂ���1�h�b�g�����͂ݏo��(�H)�̂Œ��ӁB
	init_elisagb(1, 0, 20, 18);

	// �Z�[�u�f�[�^������
	if (strcmp(SaveName, SAVE_NAME)) {
		strcpy(SaveName, SAVE_NAME);
		HighScore = 0;
	}

	initrand(sys_time);
}

/************************************************************************
 * �^�C�g����ʂ�\�����ă{�^�����͑҂�
 * �J�n�{�^���������ꂽ��TRUE��Ԃ��܂��B
 ************************************************************************/
BYTE title() {
	char score[6];
	UBYTE key;

	// �^�C�g���\��
	ecls();
	eputsxy(6, 4, "Yahtzee!");
	eputsxy(3, 7, "High Score:");
	eputsFmtUW(HighScore, 3, " ");
	eputsxy(5, 14, "PUSH START");

	// START or A�{�^�����͑҂�
	while (TRUE) {
		key = waitpad(0xff);
		waitpadup();
		if (isKonamiKeys(key)) {
			return FALSE;
		}
		if ((key & J_START) || (key & J_A)) {
			break;
		}
	}

	return TRUE;
}

/************************************************************************
 * �R�i�~�R�}���h�`�F�b�N
 * �R�i�~�R�}���h�ɍ��v������TRUE��Ԃ��܂��B
 ************************************************************************/
BYTE isKonamiKeys(UBYTE key) {
	static UBYTE keys[sizeof(KonamiKeys)];
	BYTE ret = TRUE;
	UBYTE i;

	// ���̓L�[�̃L���[��push
	for (i = 1; i < sizeof(KonamiKeys); i++) {
		keys[i - 1] = keys[i];
	}
	keys[sizeof(KonamiKeys) - 1] = key;

	// ��v���Ă��邩�`�F�b�N
	for (i = 0; i < sizeof(KonamiKeys); i++) {
		if (keys[i] != KonamiKeys[i]) {
			ret = FALSE;
			break;
		}
	}

	return ret;
}

/************************************************************************ 
 * UWORD�l���w�茅�ŉE�����ɂȂ�悤��eputs
 ************************************************************************/
void eputsFmtUW(UWORD n, BYTE width, void *pad) {
	char buf[7];
	BYTE len, i;

	sprintf(buf, "%lu", n);
	len = strlen(buf);
	for (i = 0; i < width - len; i++) {
		eputs(pad);
	}
	eputs(buf);
}

/************************************************************************ 
 * �Q�[�����C��
 ************************************************************************/
void game() {
	ecls();
	eputsxy(0, 8, "�����L�[�������ƃ^�C�g���ɖ߂�܂��B");
	gotoexy(0, 9);
	color(LTGREY, WHITE, SOLID);
	eputs("LTGREY");
	color(DKGREY, WHITE, SOLID);
	eputs(" DKGREY");
	waitpad(0xff);
	waitpadup();
}
