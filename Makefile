atoi_test: atoi.o atoi_test.o print_integer.o
	ld atoi.o atoi_test.o print_integer.o -o atoi_test

fibonacci: fibonacci.o print_integer.o
	ld fibonacci.o print_integer.o -o fibonacci

fibonacci.o: fibonacci.S
	as fibonacci.S -o fibonacci.o

atoi_test.o: atoi_test.S
	as atoi_test.S -o atoi_test.o

atoi.o: atoi.S
	as atoi.S -o atoi.o

print_integer.o: print_integer.S
	as print_integer.S -o print_integer.o
