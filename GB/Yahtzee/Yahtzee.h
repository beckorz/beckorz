#ifndef _YAHTZEE_H
#define _YAHTZEE_H
/************************************************************************
 * GBDK Tips
 *
 * ■変数の宣言と同時に初期化の注意
 * 	グローバル変数やstaticな変数を宣言と同時に初期化すると
 * 	const修飾子を付けた扱いになってしまうらしいので注意。
 * 	宣言と同時に初期化しなくてもANSI-Cでは0初期化が保証されている？
 * 
 * ■1つの配列の要素数は127個が限界
 * 	コンパイラの制限らしい？
 * 
 * ■データ型毎のサイズ覚え書き
 * 	char:0～255
 * 	BYTE:-128～127
 * 	UBYTE:0～255
 * 	WORD:-32768～32768
 * 	UWORD:0～65535
 * 
 * ■printf書式文字列覚え書き(%03dとかで桁揃えはできないよぅ)
 * 	%c:文字(char)
 * 	%d:10進数(BYTE:-128～127)
 * 	%u:10進数(UBYTE:0～255)
 * 	%o:8進数(UBYTE:0～0377)
 * 	%x:16進数(UBYTE:0～0xff)
 * 	%s:文字列(char配列)
 * 	%ld:10進数(WORD:-32768～32768)
 * 	%lu:10進数(UWORD:0～65535)
 * 	%lo:8進数(UWORD:0～0177777)
 * 	%lx:16進数(UWORD:0～0xffff)
 ************************************************************************/

#define SAVE_NAME "Yahtzee"

// 役
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

// プロトタイプ宣言群
void init();
BYTE title();
BYTE isKonamiKeys(UBYTE);
void eputsFmtUW(UWORD, BYTE, void *);
void game();

#endif /* _YAHTZEE_H */
