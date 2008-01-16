//bank管理系 2000/1/17

void init_bank_sys(void);
void push_rom_bank(UBYTE no);
void pop_rom_bank(void);
void push_ram_bank(UBYTE no);
void pop_ram_bank(void);
UBYTE now_rom_bank(void);
UBYTE now_ram_bank(void);

// バンク切替のネストの深さの上限
#define BANK_STACK_MAX 16
