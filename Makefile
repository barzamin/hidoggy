floppydog.bin: boopsector.s
	nasm -o $@ -f bin $^

qsim: floppydog.bin
	qemu-system-i386 -drive file=floppydog.bin,format=raw,index=0,if=floppy

bsim: floppydog.bin
	bochs -q

all: floppydog.bin
