TARGET = Yahtzee.gb
CC = lcc
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
	zip -9 $(TARGET:.gb=).zip $(TARGET)

$(TARGET): $(OBJS) elisa100.fnt elisagb.tbl
	$(CC) $(LDFLAGS) -o $@ $(OBJS)
	patchgb $@ elisa100.fnt 0x8000
	patchgb $@ elisagb.tbl 0x16000

savedata.o: savedata.c
	$(CC) $(CFLAGS) -Wf-ba0 -c $*.c
Yahtzee.o: Yahtzee.c Yahtzee.h
