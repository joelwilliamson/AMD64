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

print_array.o: print_array.S
	as -o print_array.{o,S}

print_array_test.o: print_array_test.S
	as -o print_array_test.{o,S}

print_array_test: print_array.o print_array_test.o exit.o print_integer.o
	ld -o print_array_test print_array.o print_array_test.o exit.o print_integer.o

printf.o: printf.S
	as -o printf.{o,S}

printf_test.o: printf_test.S
	as -o printf_test.{o,S}

printf_test: printf.o print_integer.o exit.o printf_test.o
	ld -o printf_test printf_test.o printf.o print_integer.o exit.o

clean:
	rm print_string_test atoi_test fibonacci print_array_test printf_test
	rm *.o
