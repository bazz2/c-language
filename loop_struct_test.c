#include<stdio.h>

struct a{
	struct b *s;
};
struct b{
	struct a *s;
};
void main()
{
	struct a *s;
	int i = 0;
	while(s)
	{
		s = s->s;
		printf("%d\n", i++);
	}
	printf("\n");
}
