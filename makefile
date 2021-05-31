CC=gcc
ASMBIN=nasm

all : asm cc link
asm :
	$(ASMBIN) -o func.o -f elf -g -l func.lst func.asm
cc :
	$(CC) -m32 -c -g -O0 main.c
link :
	$(CC) -m32 -g -o program main.o func.o
run :
	./program
gdb :
	gdb program
clean :
	rm *.o
	rm *.lst
debug : all gdb