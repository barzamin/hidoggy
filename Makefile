floppydog.bin: boopsector.s
	nasm -o $@ -f bin $^

qsim: floppydog.bin
	qemu-system-i386 -drive file=floppydog.bin,format=raw,index=0,if=floppy

qsim-dbg: floppydog.bin
	(qemu-system-i386 -S -gdb tcp::1337 -drive file=floppydog.bin,format=raw,index=0,if=floppy &)
	gdb -ex 'target remote localhost:1337'

all: floppydog.bin
