print_string_test: print_string_test.o print_string.o exit.o print_integer.o atoi.o
	ld print_string_test.o print_string.o exit.o print_integer.o atoi.o -o print_string_test
atoi_test: atoi.o atoi_test.o print_integer.o
	ld atoi.o atoi_test.o print_integer.o -o atoi_test

fibonacci: fibonacci.o print_integer.o atoi.o exit.o
	ld fibonacci.o print_integer.o atoi.o exit.o -o fibonacci

print_string_test.o: print_string_test.S
	as -o print_string_test.{o,S}

print_string.o: print_string.S
	as -o print_string.{o,S}

fibonacci.o: fibonacci.S
	as fibonacci.S -o fibonacci.o

atoi_test.o: atoi_test.S
	as atoi_test.S -o atoi_test.o

atoi.o: atoi.S
	as atoi.S -o atoi.o

print_integer.o: print_integer.S
	as print_integer.S -o print_integer.o

exit.o: exit.S
	as exit.S -o exit.o

clean:
	rm print_string_test atoi_test fibonacci
	rm *.o
