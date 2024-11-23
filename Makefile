all: main

ASFLAGS=--noexecstack 

main.s: main.S
	cpp $^ -o $@

main: main.o
	ld $^ -o $@

aslr_disable:
	echo 0 | sudo tee /proc/sys/kernel/randomize_va_space

.PHONY: clean aslr_disable

clean:
	rm -f main main.s *.o
