# 開発環境として香り屋版vimを使用する際には
# _gvimrcに「set makeprg=nmake\ /nologo\ /s」としておいて
# ソース編集時の最初に「:CdCurrent」や「set path+=C:\SDK\**\include」を実行しとくといいカモ。
TARGET = Yahtzee.gb
CC = C:\SDK\gbz80-gb\2-1-5\bin\lcc.exe
PATCHGB = C:\SDK\gbz80-gb\2-1-5\bin\patchgb.exe
ZIP = zip -9
CFLAGS = -Wa-l
LDFLAGS = -Wl-m -Wl-yt3 -Wl-yo8 -Wl-ya1
OBJS = \
	bank.o \
	elisagb.o \
	savedata.o \
	Yahtzee.o

#.SILENT:
.SUFFIXES: .c
.c.o:
	$(CC) $(CFLAGS) -c $<

all: $(TARGET)

clean:
	@del -f *.lst *.map *.o 2>nul

zip: $(TARGET)
	$(ZIP) $(TARGET:.gb=).zip $(TARGET)

$(TARGET): $(OBJS) elisa100.fnt elisagb.tbl
	$(CC) $(LDFLAGS) -o $@ $(OBJS)
	$(PATCHGB) $@ elisa100.fnt 0x8000
	$(PATCHGB) $@ elisagb.tbl 0x16000

savedata.o: savedata.c
	$(CC) $(CFLAGS) -Wf-ba0 -c $*.c
bank.o: bank.h
elisagb.o: elisagb.h
Yahtzee.o: Yahtzee.h bank.h elisagb.h
