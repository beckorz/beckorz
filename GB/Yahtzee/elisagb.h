/*
elisa�t�H���g�`��n 2000/8/5 mnagaku
���̌n���g�p����ꍇ�́A�I���W�i���̌b�����t�H���gelisa100.fnt��
2�o���N�擪(0x8000)����z�u���A
elisagb.tbl��5�o���N��(0x16000)�ɔz�u����K�v������܂��B
�z�u�ɂ�patchgb�Ȃǂ��g���ĉ������B
*/

typedef struct _E_T {
	UBYTE bank;
	UWORD start, end, addr;
	struct _E_T *small, *big;
} E_T;

#define TBL_BANK 5
#define TBL_ADDR (E_T *)0x6000
#define FONT_W 8
#define WAIT_BUTTON_MASK 0xff

extern UBYTE e_sx, e_sy, e_width, e_height, e_x, e_y;

// 1�����\��
void eputc(UBYTE x, UBYTE y, UWORD char_code);
// �\���ʒu���ڎw�蕶����\��
UBYTE eputsxy(UBYTE x, UBYTE y, void *str);
// �\���ʒu�ύX
void gotoexy(UBYTE x, UBYTE y);
// ������\��
UBYTE eputs(void *str);
// ������
void init_elisagb(UBYTE x, UBYTE y, UBYTE w, UBYTE h);
// cls
void ecls();

