#include <drawing.h>
#include <gb.h>
#include <rand.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bank.h"
#include "elisagb.h"
#include "Yahtzee.h"

// セーブデータ群
extern char SaveName[];	// セーブデータ存在確認用
extern UWORD HighScore;	// ハイスコア

// コナミコマンド
const UBYTE KonamiKeys[] = { J_UP, J_UP, J_DOWN, J_DOWN, J_LEFT, J_RIGHT, J_LEFT, J_RIGHT, J_B, J_A };

/************************************************************************
 * メインルーチン
 ************************************************************************/
void main() {
	// 初期化
	init();

	// メインループ
	while (TRUE) {
		if (title()) {
			game();
		} else {
			// コナミコマンド成功時にはハイスコアをリセット
			HighScore = 0;
		}
	}
}

/************************************************************************
 * 初期化ルーチン
 ************************************************************************/
void init() {
	// ELISAGBの初期化
	// (0, 0, 20, 18)と初期化したいところだが、そうするとなぜか(0, 6)から2タイル分が表示できなくなる。
	// (1, 0, 20, 18)だとその現象が出ないものの、右に1ドットずれるせいか
	// 右端ギリギリまで文字を表示しようとすると同行の左側にその1ドット分がはみ出る(？)ので注意。
	init_elisagb(1, 0, 20, 18);

	// セーブデータ初期化
	if (strcmp(SaveName, SAVE_NAME)) {
		strcpy(SaveName, SAVE_NAME);
		HighScore = 0;
	}

	initrand(sys_time);
}

/************************************************************************
 * タイトル画面を表示してボタン入力待ち
 * 開始ボタンが押されたらTRUEを返します。
 ************************************************************************/
BYTE title() {
	char score[6];
	UBYTE key;

	// タイトル表示
	ecls();
	eputsxy(6, 4, "Yahtzee!");
	eputsxy(3, 7, "High Score:");
	eputsFmtUW(HighScore, 3, " ");
	eputsxy(5, 14, "PUSH START");

	// START or Aボタン入力待ち
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
 * コナミコマンドチェック
 * コナミコマンドに合致したらTRUEを返します。
 ************************************************************************/
BYTE isKonamiKeys(UBYTE key) {
	static UBYTE keys[sizeof(KonamiKeys)];
	BYTE ret = TRUE;
	UBYTE i;

	// 入力キーのキューにpush
	for (i = 1; i < sizeof(KonamiKeys); i++) {
		keys[i - 1] = keys[i];
	}
	keys[sizeof(KonamiKeys) - 1] = key;

	// 一致しているかチェック
	for (i = 0; i < sizeof(KonamiKeys); i++) {
		if (keys[i] != KonamiKeys[i]) {
			ret = FALSE;
			break;
		}
	}

	return ret;
}

/************************************************************************ 
 * UWORD値を指定桁で右揃えになるようにeputs
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
 * ゲームメイン
 ************************************************************************/
void game() {
	ecls();
	eputsxy(0, 8, "何かキーを押すとタイトルに戻ります。");
	gotoexy(0, 9);
	color(LTGREY, WHITE, SOLID);
	eputs("LTGREY");
	color(DKGREY, WHITE, SOLID);
	eputs(" DKGREY");
	waitpad(0xff);
	waitpadup();
}
