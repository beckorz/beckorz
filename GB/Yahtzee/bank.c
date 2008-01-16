//bank管理系 2000/1/17

#include <stdlib.h>
#include <stdio.h>
#include <gb.h>
#include "bank.h"

UBYTE rom_bank_stack[BANK_STACK_MAX];
UWORD rom_bank_sp;
UBYTE ram_bank_stack[BANK_STACK_MAX];
UWORD ram_bank_sp;

// バンク管理系を初期化する
void init_bank_sys(void)
{
	ENABLE_RAM_MBC1;
	rom_bank_sp = 0U;
	rom_bank_stack[0] = 1U;
	ram_bank_sp = 0U;
	ram_bank_stack[0] = 0U;

	SWITCH_ROM_MBC1(1);
	SWITCH_RAM_MBC1(0);
}

// ROMバンクを切り替える
void push_rom_bank(UBYTE no)
{
	rom_bank_sp++;
	rom_bank_stack[rom_bank_sp] = no;
	SWITCH_ROM_MBC1(no);
}

// ROMバンクを元に戻す
void pop_rom_bank(void)
{
	rom_bank_sp--;
	SWITCH_ROM_MBC1(rom_bank_stack[rom_bank_sp]);
}

// RAMバンクを切り替える
void push_ram_bank(UBYTE no)
{
	ram_bank_sp++;
	ram_bank_stack[ram_bank_sp] = no;
	SWITCH_RAM_MBC1(no);
}

// RAMバンクを元に戻す
void pop_ram_bank(void)
{
	ram_bank_sp--;
	SWITCH_RAM_MBC1(ram_bank_stack[ram_bank_sp]);
}

// 現在のROMバンクを参照
UBYTE now_rom_bank(void)
{
	return rom_bank_stack[rom_bank_sp];
}

// 現在のRAMバンクを参照
UBYTE now_ram_bank(void)
{
	return ram_bank_stack[ram_bank_sp];
}
