#include <stdio.h>
#include <gb.h>
#include "Yahtzee.h"

extern SaveName[];
extern UWORD HighScore;
extern UWORD ExecCount;

void main() {
	// 初期化(最大の17×16タイル)
	init_elisagb(0, 0, 17, 16);
	if (strcmp(SaveName, SAVE_NAME)) {
		strcpy(SaveName, SAVE_NAME);
		HighScore = 0;
		ExecCount = 0;
	}
	ExecCount++;
	
	// タイトル画面表示
	title();
	
	// とりあえずELISAGBのテスト
	ecls();
	gotoexy(0, 0);
	eputs("\
１２３４５６７８９０１２３４５６７\
ぁあぃいぅうぇえぉおかがきぎくぐけ\
げこごさざしじすずせぜそぞただちぢ\
っつづてでとどなにぬねのはばぱひび\
ぴふぶぷへべぺほぼぽまみむめもゃや\
ゅゆょよらりるれろゎわゐゑをんァア\
ィイゥウェエォオカガキギクグケゲコ\
ゴサザシジスズセゼソ\ゾタダチヂッツ\
ヅテデトドナニヌネノハバパヒビピフ\
ブプヘベペホボポマミムメモャヤュユ\
ョヨラリルレロヮワヰヱヲンヴヵヶ　\
ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑ\
ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱ\
！＠＃＄％：；＊（）｛｝「」、。？\
↓漢字＆だめ文字テスト①Ⅱ　　　　\
噂\浬\欺\圭\構\蚕\十\申\曾\箪\貼\能\表\暴\予\禄\兔\\
");
}

/*
	タイトル画面表示
*/
void title() {
	char score[6];
	char execCount[6];
	UBYTE key;
	
	// タイトル表示
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
	eputs("起動回数：");
	sprintf(execCount, "%lu", ExecCount);
	eputs(execCount);
	
	// START or Aボタン入力待ち
	waitpad(J_START | J_A);
	waitpadup();
}
