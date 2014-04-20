#include <stdio.h>
#include <stdlib.h>

int sort_func(void *a, void *b);
int list[5] = {54, 21, 11, 67, 89};

int main(void)
{
	int x;

	qsort((void*)list, 5, sizeof (list[0]), sort_func);
	for (x = 0; x < 5; x++)
		printf("%d\n", list[x]);
	return 0;
}

int sort_func(void *a, void *b)
{
	return *(int*)b - *(int*)a;
}
