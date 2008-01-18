/*
elisaフォント描画系 2000/8/5 mnagaku
この系を使用する場合は、オリジナルの恵梨沙フォントelisa100.fntを
2バンク先頭(0x8000)から配置し、
elisagb.tblを5バンク中(0x16000)に配置する必要があります。
配置にはpatchgbなどを使って下さい。
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

// 1文字表示
void eputc(UBYTE x, UBYTE y, UWORD char_code);
// 表示位置直接指定文字列表示
UBYTE eputsxy(UBYTE x, UBYTE y, void *str);
// 表示位置変更
void gotoexy(UBYTE x, UBYTE y);
// 文字列表示
UBYTE eputs(void *str);
// 初期化
void init_elisagb(UBYTE x, UBYTE y, UBYTE w, UBYTE h);
// cls
void ecls();

