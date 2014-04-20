#include <stdio.h>
#include <stdlib.h>

void main()
{
	int i = 10;
	char buf[10];
	itoa(i, buf, 10);
	printf("%s\n", buf);
}
