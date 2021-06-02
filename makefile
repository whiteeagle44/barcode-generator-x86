CC=gcc
ASMBIN=nasm

all : assemble compile link
assemble : put_pixel.asm
	$(ASMBIN) -o func.o -f elf -g -l put_pixel.lst put_pixel.asm
compile : assemble main.c
	$(CC) -m32 -c -g -O0 main.c
link : compile
	$(CC) -m32 -g -o program main.o func.o
run :
	./program
gdb :
	gdb program
clean :
	rm *.o
	rm *.lst
debug : all gdb