CC=gcc
ASMBIN=nasm

all : assemble compile link
assemble : functions.asm
	$(ASMBIN) -o functions.o -f elf -g -l functions.lst functions.asm
compile : assemble main.c
	$(CC) -m32 -c -g -O0 main.c
link : compile
	$(CC) -m32 -g -o program main.o functions.o
run :
	./program
gdb :
	gdb program
clean :
	rm *.o
	rm *.lst
debug : all gdb