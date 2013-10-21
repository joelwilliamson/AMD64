mbr.o:	mbr.S
	as mbr.S -o mbr.o

kernel.bin: mbr.o
	ld -o kernel.bin mbr.o --oformat=binary -Ttext=7c00 -Tdata=7dac

install: kernel.bin
	sudo dd bs=512 count=1 if=kernel.bin of=/dev/sdd

echo_mbr.o: echo_mbr.S
	as echo_mbr.S -o echo_mbr.o

echo_kernel.bin: echo_mbr.o
	ld -o echo_kernel.nbin echo_mbr.o --oformat=binary -Ttext=7c00
	./linker echo_kernel.nbin echo_kernel.bin
