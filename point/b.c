#include <stdlib.h>
#include <stdio.h>
#include "b.h"

struct stb{
	int i;
};

struct stb *set_b(int num)
{
	struct stb *pb = NULL;
	pb = (struct stb*)calloc(1, sizeof(struct stb));
	pb->i = num;
	return pb;
}

void PRINT_PB(struct stb *p)
{
	printf("%d\n", p->i);
}
