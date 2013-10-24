mbr.o:	mbr.S
	as mbr.S -o mbr.o

kernel.bin: mbr.o
	ld -o kernel.bin mbr.o --oformat=binary -Ttext=7c00 -Tdata=7dac

install: kernel.bin
	sudo dd bs=512 count=1 if=kernel.bin of=/dev/sdd

linker: linker.c
	gcc -o linker linker.c

echo_mbr.o: echo_mbr.S
	as echo_mbr.S -o echo_mbr.o

echo_kernel.bin: echo_mbr.o linker
	ld -o echo_kernel.nbin echo_mbr.o --oformat=binary -Ttext=7c00
	./linker echo_kernel.nbin echo_kernel.bin
	rm echo_kernel.nbin

install_echo: echo_kernel.bin
	sudo dd bs=512 count=1 if=echo_kernel.bin of=/dev/sdd

echo_second_sector.o: echo_second_sector.S
	../pas echo_second_sector.S echo_second_sector.o

echo_second_sector.bin: echo_second_sector.o linker
	ld -o echo_second_sector.nbin echo_second_sector.o --oformat=binary -Ttext=7c00
	./linker echo_second_sector.{n,}bin
	rm echo_second_sector.nbin

install_echo_second_sector: echo_second_sector.bin
	sudo dd bs=512 count=1 if=echo_second_sector.bin of=/dev/sdd
	sudo dd bs=512 count=1 if=/dev/zero of=/dev/sdd seek=1
	echo -e -n \\xda\\xdaThis message should be found near the beginning of sector 2\\n\\r | sudo dd bs=512 count=1 of=/dev/sdd seek=1

load_code.o: load_code.S
	../pas load_code.S load_code.o

load_code.bin: load_code.o linker
	ld -o load_code.nbin load_code.o --oformat=binary -Ttext=7c00
	./linker load_code.{n,}bin
	rm load_code.nbin

loader: loader.c
	gcc -o loader{,.c}

echo_kernel_loadable.bin: echo_mbr.o loader
	ld -o echo_kernel_loadable.nbin echo_mbr.o --oformat=binary -Ttext=7e00
	./loader echo_kernel_loadable.{n,}bin
	rm echo_kernel_loadable.nbin

install_load_code: load_code.bin echo_kernel_loadable.bin
	sudo dd bs=512 count=1 if=load_code.bin of=/dev/sdd
	sudo dd bs=512 count=1 if=/dev/zero of=/dev/sdd seek=1
	sudo dd bs=512 count=1 if=echo_kernel_loadable.bin of=/dev/sdd seek=1

.PHONY: clean
clean:
	-rm linker loader mbr.o kernel.bin echo_mbr.o echo_kernel.bin echo_second_sector.{bin,o} echo_kernel_loadable{.o,.bin} load_code.{bin,o}
