/*
elisaï\é¶ä÷êîåQ 2000/8/5 mnagaku
*/

#include <gb.h>
#include <drawing.h>
#include "bank.h"
#include "elisagb.h"

extern UBYTE font_ibm_fixed_tiles[];

UBYTE e_sx, e_sy, e_width, e_height, e_x, e_y;

void eputc(UBYTE x, UBYTE y, UWORD char_code) {
	UBYTE bank = 0, *addr, xp, yp, i, j;
	E_T *ett;

	if(char_code & 0xff00) {
		push_rom_bank(TBL_BANK);
		ett = TBL_ADDR;
		while(1) {
			if(ett == NULL)
				return;
			if(ett->start > char_code)
				ett = ett->small;
			else if(ett->end < char_code)
				ett = ett->big;
			else
				break;
		}
		bank = ett->bank;
		addr = (UBYTE *)((char_code - ett->start) * 8 + ett->addr);
		pop_rom_bank();
		push_rom_bank(bank);
	}
	else
		addr = font_ibm_fixed_tiles + char_code * 8;

	xp = x;
	yp = y;
	for(j = 0; j < 8; j++) {
		for(i = 0; i < 8; i++) {
			if((addr[j] >> (7 - i)) & 1)
				plot_point(xp++, yp);
			else
				xp++;
		}
		xp = x;
		yp++;
	}

	if(bank)
		pop_rom_bank();
}

UBYTE eputsxy(UBYTE x, UBYTE y, void *str) {
	gotoexy(x, y);
	return eputs(str);
}

void gotoexy(UBYTE x, UBYTE y) {
	e_x = e_sx + x * FONT_W;
	e_y = e_sy + y * FONT_W;
}

UBYTE eputs(void *str) {
	UBYTE *now, count;
	UWORD c;

	for(now = str, count = 0; *now != 0; now++, count++) {
		if(*now == (UBYTE)0xA0) {
			break;
		}
		else if((*now < 0x7F) || ((*now > 0x9F) && (*now < 0xE0)))
			c = *now & 0xff;
		else {
			c = *now;
			c = c << 8;
			now++;
			c |= *now & 0xff;
		}
		eputc(e_x, e_y, c);
		e_x += FONT_W;
		if(e_x == e_sx + e_width * FONT_W) {
			e_x = e_sx;
			e_y += FONT_W;
			if(e_y == e_sy + e_height * FONT_W) {
				e_y = e_sy;
				waitpad(WAIT_BUTTON_MASK);
				waitpadup();
				color(WHITE, WHITE, SOLID);
				box(e_sx, e_sy, e_sx + e_width * FONT_W,
					e_sy + e_height * FONT_W, M_FILL);
				color(BLACK, WHITE, SOLID);
			}
		}
	}
	return count;
}

void init_elisagb(UBYTE x, UBYTE y, UBYTE w, UBYTE h) {
	init_bank_sys();
	e_sx = e_x = x;
	e_sy = e_y = y;
	e_width = w;
	e_height = h;
	color(BLACK, WHITE, SOLID);
	mode(M_DRAWING);
}

void ecls() {
	e_x = e_sx;
	e_y = e_sy;
	color(WHITE, WHITE, SOLID);
	box(e_sx, e_sy, e_sx + e_width * FONT_W,
		e_sy + e_height * FONT_W, M_FILL);
	color(BLACK, WHITE, SOLID);
}

