//bank�Ǘ��n 2000/1/17

void init_bank_sys(void);
void push_rom_bank(UBYTE no);
void pop_rom_bank(void);
void push_ram_bank(UBYTE no);
void pop_ram_bank(void);
UBYTE now_rom_bank(void);
UBYTE now_ram_bank(void);

// �o���N�ؑւ̃l�X�g�̐[���̏��
#define BANK_STACK_MAX 16
