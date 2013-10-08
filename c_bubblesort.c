int* bubblesort(int* array, int length)
	{
	char has_changed = 0;
	int temp;
	do {
		for (int* x = array; x-array < length -1 ; ++ x)
			if (*x > *(x+1) ) {
				temp = *x;
				*x = *(x+1);
				*(x+1) = temp;
				has_changed = 1;
			}
	} while (has_changed);
	return array;
	}
